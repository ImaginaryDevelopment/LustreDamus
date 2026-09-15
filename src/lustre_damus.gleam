import gleam/dict.{type Dict}
import gleam/http/response.{type Response}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import markdown_table.{type Table}
import pal_index
import rsvp
import samples.{type Sample}
import table_format.{type FormattedCell, type TableFormatter}
import table_sort.{
  type Direction, type EmptyPlacement, type SortKind, type SortSpec,
  type TableSort, type TextPlacement, Asc, Desc, EmptiesFirst, EmptiesLast,
  SortNumeric, SortText, TextAfterNumbers, TextBeforeNumbers,
}

pub type Page {
  PastePage
  SamplePage(Sample)
}

pub type SortSlot {
  Primary
  Secondary
}

pub type Model {
  Model(
    page: Page,
    markdown: String,
    filter: String,
    loading: Bool,
    error: Option(String),
    sorts: Dict(String, TableSort),
    optional_columns: Dict(String, Dict(String, Bool)),
    pal_elements: Dict(String, String),
  )
}

pub type Msg {
  UserChosePaste
  UserChoseSample(Sample)
  UserUpdatedMarkdown(String)
  UserUpdatedFilter(String)
  UserClickedColumn(String, Int)
  UserSetSortKind(String, SortSlot, SortKind)
  UserSetDirection(String, SortSlot, Direction)
  UserSetEmptyPlacement(String, SortSlot, EmptyPlacement)
  UserSetTextPlacement(String, SortSlot, TextPlacement)
  UserClearSecondary(String)
  UserClearSort(String)
  UserToggledOptionalColumn(String, String, Bool)
  SampleLoaded(Result(String, String))
  PalIndexLoaded(Result(String, String))
}

pub fn main() -> Nil {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn init(_flags: Nil) -> #(Model, Effect(Msg)) {
  #(
    Model(
      page: PastePage,
      markdown: "",
      filter: "",
      loading: False,
      error: None,
      sorts: dict.new(),
      optional_columns: dict.new(),
      pal_elements: dict.new(),
    ),
    effect.none(),
  )
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserChosePaste -> #(
      Model(..model, page: PastePage, error: None, loading: False),
      effect.none(),
    )

    UserChoseSample(sample) -> #(
      Model(
        page: SamplePage(sample),
        markdown: "",
        filter: "",
        loading: True,
        error: None,
        sorts: dict.new(),
        optional_columns: dict.new(),
        pal_elements: model.pal_elements,
      ),
      effect.batch([
        load_sample(samples.url(sample)),
        case samples.is_palworld(sample) {
          True -> ensure_pal_index(model.pal_elements)
          False -> effect.none()
        },
      ]),
    )

    UserUpdatedMarkdown(markdown) -> #(
      Model(
        ..model,
        markdown:,
        error: None,
        sorts: dict.new(),
        optional_columns: dict.new(),
      ),
      effect.none(),
    )

    UserUpdatedFilter(filter) -> #(Model(..model, filter:), effect.none())

    UserClickedColumn(table_id, column) -> #(
      Model(..model, sorts: update_column_sort(model, table_id, column)),
      effect.none(),
    )

    UserSetSortKind(table_id, slot, kind) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, kind:, direction: Asc)
        }),
      ),
      effect.none(),
    )

    UserSetDirection(table_id, slot, direction) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, direction:)
        }),
      ),
      effect.none(),
    )

    UserSetEmptyPlacement(table_id, slot, empties) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, empties:)
        }),
      ),
      effect.none(),
    )

    UserSetTextPlacement(table_id, slot, texts) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, texts:)
        }),
      ),
      effect.none(),
    )

    UserClearSecondary(table_id) -> #(
      Model(..model, sorts: case dict.get(model.sorts, table_id) {
        Ok(table_sort.TableSort(primary:, secondary: _)) ->
          dict.insert(
            model.sorts,
            table_id,
            table_sort.TableSort(primary:, secondary: None),
          )
        Error(_) -> model.sorts
      }),
      effect.none(),
    )

    UserClearSort(table_id) -> #(
      Model(..model, sorts: dict.delete(model.sorts, table_id)),
      effect.none(),
    )

    UserToggledOptionalColumn(table_id, header, shown) -> #(
      Model(
        ..model,
        optional_columns: set_optional_column(
          model.optional_columns,
          table_id,
          header,
          shown,
        ),
      ),
      effect.none(),
    )

    SampleLoaded(Ok(markdown)) -> #(
      Model(..model, markdown:, loading: False, error: None),
      effect.none(),
    )

    SampleLoaded(Error(message)) -> #(
      Model(..model, loading: False, error: Some(message)),
      effect.none(),
    )

    PalIndexLoaded(Ok(markdown)) -> #(
      Model(..model, pal_elements: pal_index.parse_elements_index(markdown)),
      effect.none(),
    )

    PalIndexLoaded(Error(_)) -> #(model, effect.none())
  }
}

fn update_column_sort(
  model: Model,
  table_id: String,
  column: Int,
) -> Dict(String, TableSort) {
  let kind = inferred_kind(model, table_id, column)
  case dict.get(model.sorts, table_id) {
    Ok(table_sort.TableSort(primary:, secondary:)) if primary.column == column ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.TableSort(
          primary: table_sort.toggle_direction(primary),
          secondary:,
        ),
      )

    Ok(table_sort.TableSort(primary:, secondary: Some(secondary)))
      if secondary.column == column
    ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.TableSort(
          primary:,
          secondary: Some(table_sort.toggle_direction(secondary)),
        ),
      )

    Ok(table_sort.TableSort(primary:, secondary: _)) ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.TableSort(
          primary:,
          secondary: Some(table_sort.default_spec(column, kind)),
        ),
      )

    Error(_) ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.single(table_sort.default_spec(column, kind)),
      )
  }
}

fn inferred_kind(model: Model, table_id: String, column: Int) -> SortKind {
  let tables =
    model.markdown
    |> markdown_table.extract_tables
    |> markdown_table.filter_tables(model.filter)
  case find_table(tables, table_id) {
    Ok(table) ->
      case table_sort.column_looks_numeric(table.rows, column) {
        True -> SortNumeric
        False -> SortText
      }
    Error(_) -> SortText
  }
}

fn update_slot(
  sorts: Dict(String, TableSort),
  table_id: String,
  slot: SortSlot,
  alter: fn(SortSpec) -> SortSpec,
) -> Dict(String, TableSort) {
  case dict.get(sorts, table_id) {
    Ok(table_sort.TableSort(primary:, secondary:)) -> {
      let updated = case slot {
        Primary -> table_sort.TableSort(primary: alter(primary), secondary:)
        Secondary ->
          case secondary {
            Some(spec) ->
              table_sort.TableSort(primary:, secondary: Some(alter(spec)))
            None -> table_sort.TableSort(primary:, secondary:)
          }
      }
      dict.insert(sorts, table_id, updated)
    }
    Error(_) -> sorts
  }
}

fn find_table(tables: List(Table), table_id: String) -> Result(Table, Nil) {
  list.find(tables, fn(table) { table_id_for(table) == table_id })
}

fn table_id_for(table: Table) -> String {
  table.title
}

fn load_sample(url: String) -> Effect(Msg) {
  rsvp.get(
    url,
    rsvp.expect_ok_response(
      fn(result: Result(Response(String), rsvp.Error(String))) {
        case result {
          Ok(response) -> SampleLoaded(Ok(response.body))
          Error(error) -> SampleLoaded(Error(describe_error(error)))
        }
      },
    ),
  )
}

fn ensure_pal_index(pal_elements: Dict(String, String)) -> Effect(Msg) {
  case dict.size(pal_elements) {
    0 ->
      rsvp.get(
        samples.breeding_sheet_url(),
        rsvp.expect_ok_response(
          fn(result: Result(Response(String), rsvp.Error(String))) {
            case result {
              Ok(response) -> PalIndexLoaded(Ok(response.body))
              Error(error) -> PalIndexLoaded(Error(describe_error(error)))
            }
          },
        ),
      )
    _ -> effect.none()
  }
}

fn describe_error(error: rsvp.Error(String)) -> String {
  case error {
    rsvp.BadUrl(url) -> "Bad sample URL: " <> url
    rsvp.HttpError(response) ->
      "Could not load sample (HTTP " <> int.to_string(response.status) <> ")."
    rsvp.NetworkError -> "Network error while loading sample."
    rsvp.UnhandledResponse(_) -> "Unexpected response while loading sample."
    rsvp.BadBody -> "Sample body could not be read."
    rsvp.JsonError(_) -> "Sample was not valid text."
  }
}

fn view(model: Model) -> Element(Msg) {
  let formatter = page_formatter(model.page, model.pal_elements)
  let tables =
    model.markdown
    |> markdown_table.extract_tables
    |> markdown_table.filter_tables(model.filter)
    |> list.map(fn(table) { apply_sort(table, model.sorts) })

  html.div([attribute.class("app")], [
    html.header([], [
      html.h1([], [html.text("LustreDamus")]),
      html.p([], [
        html.text(
          "Read Markdown tables in the browser — paste your own, or open a sample.",
        ),
      ]),
    ]),
    html.nav(
      [
        attribute.class("site-nav"),
        attribute.attribute("aria-label", "Sections"),
      ],
      [
        nav_button("Paste Markdown", model.page == PastePage, UserChosePaste),
        ..list.map(samples.groups(), fn(group) {
          sample_nav_bucket(group, model.page)
        })
      ],
    ),
    html.main([], case model.page {
      PastePage -> [
        html.label([attribute.for("markdown")], [html.text("Markdown")]),
        html.textarea(
          [
            attribute.id("markdown"),
            attribute.rows(12),
            attribute.placeholder(
              "| Name | Role |\n| ---- | ---- |\n| Ada  | Lead |",
            ),
            event.on_input(UserUpdatedMarkdown),
          ],
          model.markdown,
        ),
        filter_controls(model),
        tables_section(model, tables, formatter),
      ]
      SamplePage(sample) -> [
        html.p([attribute.class("sample-meta")], [
          html.text("Sample: " <> sample.label <> " — " <> sample.blurb),
        ]),
        filter_controls(model),
        tables_section(model, tables, formatter),
      ]
    }),
  ])
}

fn page_formatter(
  page: Page,
  pal_elements: Dict(String, String),
) -> TableFormatter {
  case page {
    SamplePage(sample) -> samples.table_formatter(sample, pal_elements)
    PastePage -> table_format.plain()
  }
}

fn is_sample_page(page: Page, sample: Sample) -> Bool {
  case page {
    SamplePage(current) -> current.id == sample.id
    PastePage -> False
  }
}

fn apply_sort(table: Table, sorts: Dict(String, TableSort)) -> Table {
  let id = table_id_for(table)
  case dict.get(sorts, id) {
    Ok(sort) ->
      markdown_table.Table(
        ..table,
        rows: table_sort.sort_rows(table.rows, sort),
      )
    Error(_) -> table
  }
}

fn sample_nav_bucket(group: samples.SampleGroup, page: Page) -> Element(Msg) {
  let open = case page {
    SamplePage(sample) -> samples.group_contains(group, sample)
    PastePage -> False
  }
  let parent_msg = case samples.group_samples(group) {
    [first, ..] -> UserChoseSample(first)
    [] -> UserChosePaste
  }

  html.div([attribute.class("nav-group")], [
    nav_button(group.label, open, parent_msg),
    case open {
      False -> element.none()
      True ->
        html.div(
          [attribute.class("nav-children")],
          nav_bucket_children(group, page),
        )
    },
  ])
}

fn nav_bucket_children(
  group: samples.SampleGroup,
  page: Page,
) -> List(Element(Msg)) {
  let sample_links = case group.samples {
    [] -> element.none()
    direct ->
      html.div(
        [attribute.class("nav-links")],
        list.map(direct, fn(sample) {
          nav_button(
            sample.label,
            is_sample_page(page, sample),
            UserChoseSample(sample),
          )
        }),
      )
  }
  [
    sample_links,
    ..list.map(group.buckets, fn(bucket) { sample_nav_bucket(bucket, page) })
  ]
}

fn nav_button(label: String, active: Bool, msg: Msg) -> Element(Msg) {
  let class = case active {
    True -> "nav-link active"
    False -> "nav-link"
  }
  html.button(
    [attribute.type_("button"), attribute.class(class), event.on_click(msg)],
    [html.text(label)],
  )
}

fn filter_controls(model: Model) -> Element(Msg) {
  html.div([attribute.class("filter-row")], [
    html.label([attribute.for("filter")], [html.text("Filter tables")]),
    html.input([
      attribute.id("filter"),
      attribute.type_("search"),
      attribute.placeholder("Search rows…"),
      attribute.value(model.filter),
      event.on_input(UserUpdatedFilter),
    ]),
  ])
}

fn tables_section(
  model: Model,
  tables: List(Table),
  formatter: TableFormatter,
) -> Element(Msg) {
  html.section([attribute.class("preview")], [
    html.h2([], [html.text("Tables")]),
    case model.loading {
      True -> html.p([attribute.class("empty")], [html.text("Loading sample…")])
      False ->
        case model.error {
          Some(message) ->
            html.p([attribute.class("error")], [html.text(message)])
          None ->
            render_tables(
              tables,
              model.markdown,
              model.sorts,
              model.optional_columns,
              formatter,
            )
        }
    },
  ])
}

fn render_tables(
  tables: List(Table),
  markdown: String,
  sorts: Dict(String, TableSort),
  optional_columns: Dict(String, Dict(String, Bool)),
  formatter: TableFormatter,
) -> Element(Msg) {
  case tables {
    [] if markdown == "" ->
      html.p([attribute.class("empty")], [
        html.text("Paste Markdown or open a sample to see tables."),
      ])
    [] ->
      html.p([attribute.class("empty")], [
        html.text("No tables matched this Markdown (or filter)."),
      ])
    _ ->
      html.div(
        [attribute.class("tables")],
        list.map(tables, fn(table) {
          render_table(table, sorts, optional_columns, formatter)
        }),
      )
  }
}

fn render_table(
  table: Table,
  sorts: Dict(String, TableSort),
  optional_columns: Dict(String, Dict(String, Bool)),
  formatter: TableFormatter,
) -> Element(Msg) {
  let id = table_id_for(table)
  let active = dict.get(sorts, id)
  let optional_headers =
    list.filter(table.headers, is_optional_header)

  html.section([attribute.class("md-table")], [
    html.h3([], [html.text(table.title)]),
    case active {
      Ok(sort) -> sort_controls(id, sort, table.headers)
      Error(_) ->
        html.p([attribute.class("sort-hint")], [
          html.text(
            "Click a column to sort. Click another column to add a secondary sort.",
          ),
        ])
    },
    optional_column_toggles(id, optional_headers, optional_columns),
    html.div([attribute.class("table-wrap")], [
      html.table([], [
        html.thead([], [
          html.tr(
            [],
            visible_header_cells(table.headers, id, optional_columns, active),
          ),
        ]),
        html.tbody(
          [],
          list.index_map(table.rows, fn(row, row_index) {
            html.tr(
              [],
              visible_body_cells(
                table,
                row,
                row_index,
                id,
                optional_columns,
                formatter,
              ),
            )
          }),
        ),
      ]),
    ]),
  ])
}

fn visible_header_cells(
  headers: List(String),
  table_id: String,
  optional_columns: Dict(String, Dict(String, Bool)),
  active: Result(TableSort, Nil),
) -> List(Element(Msg)) {
  headers
  |> list.index_map(fn(cell, index) { #(cell, index) })
  |> list.filter_map(fn(pair) {
    let #(cell, index) = pair
    case column_is_shown(optional_columns, table_id, cell) {
      False -> Error(Nil)
      True -> {
        let role = column_role(active, index)
        let marker = case role {
          Some(#(Primary, Asc)) -> " ↑1"
          Some(#(Primary, Desc)) -> " ↓1"
          Some(#(Secondary, Asc)) -> " ↑2"
          Some(#(Secondary, Desc)) -> " ↓2"
          None -> ""
        }
        let class = case role {
          Some(#(Primary, _)) -> "sortable selected primary"
          Some(#(Secondary, _)) -> "sortable selected secondary"
          None -> "sortable"
        }
        Ok(
          html.th([attribute.class(join_class(class, column_class(cell)))], [
            html.button(
              [
                attribute.type_("button"),
                attribute.class("sort-header"),
                event.on_click(UserClickedColumn(table_id, index)),
              ],
              [html.text(cell <> marker)],
            ),
          ]),
        )
      }
    }
  })
}

fn visible_body_cells(
  table: Table,
  row: List(String),
  row_index: Int,
  table_id: String,
  optional_columns: Dict(String, Dict(String, Bool)),
  formatter: TableFormatter,
) -> List(Element(Msg)) {
  table.headers
  |> list.index_map(fn(header, column) { #(header, column) })
  |> list.filter_map(fn(pair) {
    let #(header, column) = pair
    case column_is_shown(optional_columns, table_id, header) {
      False -> Error(Nil)
      True -> {
        let ctx =
          table_format.make_context(
            table.title,
            table.headers,
            column,
            row_index,
            row,
          )
        let formatted = table_format.format_cell(formatter, ctx)
        Ok(render_td(formatted, column_class(header)))
      }
    }
  })
}

fn optional_column_toggles(
  table_id: String,
  headers: List(String),
  optional_columns: Dict(String, Dict(String, Bool)),
) -> Element(Msg) {
  case headers {
    [] -> html.text("")
    _ ->
      html.div(
        [attribute.class("column-toggles")],
        list.map(headers, fn(header) {
          let shown = column_is_shown(optional_columns, table_id, header)
          html.label([], [
            html.input([
              attribute.type_("checkbox"),
              attribute.checked(shown),
              event.on_check(fn(checked) {
                UserToggledOptionalColumn(table_id, header, checked)
              }),
            ]),
            html.text(" Show " <> header),
          ])
        }),
      )
  }
}

fn is_optional_header(header: String) -> Bool {
  header == "Wing" || header == "Loc"
}

fn column_is_shown(
  optional_columns: Dict(String, Dict(String, Bool)),
  table_id: String,
  header: String,
) -> Bool {
  case is_optional_header(header) {
    False -> True
    True ->
      case dict.get(optional_columns, table_id) {
        Ok(columns) ->
          case dict.get(columns, header) {
            Ok(True) -> True
            Ok(False) -> False
            Error(_) -> False
          }
        Error(_) -> False
      }
  }
}

fn set_optional_column(
  optional_columns: Dict(String, Dict(String, Bool)),
  table_id: String,
  header: String,
  shown: Bool,
) -> Dict(String, Dict(String, Bool)) {
  let columns = case dict.get(optional_columns, table_id) {
    Ok(existing) -> existing
    Error(_) -> dict.new()
  }
  dict.insert(
    optional_columns,
    table_id,
    dict.insert(columns, header, shown),
  )
}

fn render_td(formatted: FormattedCell, extra_class: String) -> Element(Msg) {
  let class_name = join_class(formatted.class_name, extra_class)
  let class_attr = case class_name {
    "" -> []
    _ -> [attribute.class(class_name)]
  }
  let title_attr = case formatted.title {
    Some(title) -> [attribute.title(title)]
    None -> []
  }
  html.td(list.append(class_attr, title_attr), [html.text(formatted.text)])
}

fn column_class(header: String) -> String {
  "col-" <> string.replace(string.lowercase(header), " ", "-")
}

fn join_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}

fn column_role(
  active: Result(TableSort, Nil),
  index: Int,
) -> Option(#(SortSlot, Direction)) {
  case active {
    Ok(table_sort.TableSort(primary:, secondary: _))
      if primary.column == index
    -> Some(#(Primary, primary.direction))
    Ok(table_sort.TableSort(primary: _, secondary: Some(secondary)))
      if secondary.column == index
    -> Some(#(Secondary, secondary.direction))
    _ -> None
  }
}

fn sort_controls(
  table_id: String,
  sort: TableSort,
  headers: List(String),
) -> Element(Msg) {
  html.div([attribute.class("sort-panels")], [
    sort_panel(table_id, Primary, sort.primary, headers),
    case sort.secondary {
      Some(secondary) ->
        html.div([attribute.class("sort-secondary-wrap")], [
          sort_panel(table_id, Secondary, secondary, headers),
          html.button(
            [
              attribute.type_("button"),
              attribute.class("sort-clear"),
              event.on_click(UserClearSecondary(table_id)),
            ],
            [html.text("Clear secondary")],
          ),
        ])
      None ->
        html.p([attribute.class("sort-hint")], [
          html.text("Click another column header to add a secondary sort."),
        ])
    },
    html.button(
      [
        attribute.type_("button"),
        attribute.class("sort-clear"),
        event.on_click(UserClearSort(table_id)),
      ],
      [html.text("Clear all sorts")],
    ),
  ])
}

fn sort_panel(
  table_id: String,
  slot: SortSlot,
  spec: SortSpec,
  headers: List(String),
) -> Element(Msg) {
  let column_name = case list.drop(headers, spec.column) {
    [name, ..] -> name
    [] -> "Column"
  }
  let title = case slot {
    Primary -> "Primary: " <> column_name
    Secondary -> "Secondary: " <> column_name
  }

  html.div([attribute.class("sort-controls")], [
    html.p([attribute.class("sort-active")], [html.text(title)]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Type")]),
      toggle_btn(
        "Text",
        spec.kind == SortText,
        UserSetSortKind(table_id, slot, SortText),
      ),
      toggle_btn(
        "Numeric",
        spec.kind == SortNumeric,
        UserSetSortKind(table_id, slot, SortNumeric),
      ),
    ]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Direction")]),
      toggle_btn(
        case spec.kind {
          SortText -> "A → Z"
          SortNumeric -> "0 → 9"
        },
        spec.direction == Asc,
        UserSetDirection(table_id, slot, Asc),
      ),
      toggle_btn(
        case spec.kind {
          SortText -> "Z → A"
          SortNumeric -> "9 → 0"
        },
        spec.direction == Desc,
        UserSetDirection(table_id, slot, Desc),
      ),
    ]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Empties")]),
      toggle_btn(
        "First",
        spec.empties == EmptiesFirst,
        UserSetEmptyPlacement(table_id, slot, EmptiesFirst),
      ),
      toggle_btn(
        "Last",
        spec.empties == EmptiesLast,
        UserSetEmptyPlacement(table_id, slot, EmptiesLast),
      ),
    ]),
    case spec.kind {
      SortNumeric ->
        html.div([attribute.class("sort-group")], [
          html.span([attribute.class("sort-group-label")], [
            html.text("Non-numbers"),
          ]),
          toggle_btn(
            "Before numbers",
            spec.texts == TextBeforeNumbers,
            UserSetTextPlacement(table_id, slot, TextBeforeNumbers),
          ),
          toggle_btn(
            "After numbers",
            spec.texts == TextAfterNumbers,
            UserSetTextPlacement(table_id, slot, TextAfterNumbers),
          ),
        ])
      SortText -> element.none()
    },
  ])
}

fn toggle_btn(label: String, active: Bool, msg: Msg) -> Element(Msg) {
  let class = case active {
    True -> "sort-option active"
    False -> "sort-option"
  }
  html.button(
    [attribute.type_("button"), attribute.class(class), event.on_click(msg)],
    [html.text(label)],
  )
}
