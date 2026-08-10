import gleam/dict.{type Dict}
import gleam/http/response.{type Response}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import markdown_table.{type Table}
import rsvp
import samples.{type Sample}
import table_sort.{
  type Direction, type EmptyPlacement, type SortKind, type SortSpec,
  type TextPlacement, Asc, Desc, EmptiesFirst, EmptiesLast, SortNumeric,
  SortText, TextAfterNumbers, TextBeforeNumbers,
}

pub type Page {
  PastePage
  SamplePage(Sample)
}

pub type Model {
  Model(
    page: Page,
    markdown: String,
    filter: String,
    loading: Bool,
    error: Option(String),
    sorts: Dict(String, SortSpec),
  )
}

pub type Msg {
  UserChosePaste
  UserChoseSample(Sample)
  UserUpdatedMarkdown(String)
  UserUpdatedFilter(String)
  UserClickedColumn(String, Int)
  UserSetSortKind(String, SortKind)
  UserSetDirection(String, Direction)
  UserSetEmptyPlacement(String, EmptyPlacement)
  UserSetTextPlacement(String, TextPlacement)
  UserClearSort(String)
  SampleLoaded(Result(String, String))
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
      ),
      load_sample(samples.url(sample)),
    )

    UserUpdatedMarkdown(markdown) -> #(
      Model(..model, markdown:, error: None, sorts: dict.new()),
      effect.none(),
    )

    UserUpdatedFilter(filter) -> #(Model(..model, filter:), effect.none())

    UserClickedColumn(table_id, column) -> #(
      Model(..model, sorts: update_column_sort(model, table_id, column)),
      effect.none(),
    )

    UserSetSortKind(table_id, kind) -> #(
      Model(
        ..model,
        sorts: update_sort(model.sorts, table_id, fn(spec) {
          table_sort.SortSpec(..spec, kind:, direction: Asc)
        }),
      ),
      effect.none(),
    )

    UserSetDirection(table_id, direction) -> #(
      Model(
        ..model,
        sorts: update_sort(model.sorts, table_id, fn(spec) {
          table_sort.SortSpec(..spec, direction:)
        }),
      ),
      effect.none(),
    )

    UserSetEmptyPlacement(table_id, empties) -> #(
      Model(
        ..model,
        sorts: update_sort(model.sorts, table_id, fn(spec) {
          table_sort.SortSpec(..spec, empties:)
        }),
      ),
      effect.none(),
    )

    UserSetTextPlacement(table_id, texts) -> #(
      Model(
        ..model,
        sorts: update_sort(model.sorts, table_id, fn(spec) {
          table_sort.SortSpec(..spec, texts:)
        }),
      ),
      effect.none(),
    )

    UserClearSort(table_id) -> #(
      Model(..model, sorts: dict.delete(model.sorts, table_id)),
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
  }
}

fn update_column_sort(
  model: Model,
  table_id: String,
  column: Int,
) -> Dict(String, SortSpec) {
  case dict.get(model.sorts, table_id) {
    Ok(spec) if spec.column == column ->
      dict.insert(model.sorts, table_id, table_sort.toggle_direction(spec))
    _ -> {
      let tables =
        model.markdown
        |> markdown_table.extract_tables
        |> markdown_table.filter_tables(model.filter)
      let kind = case find_table(tables, table_id) {
        Ok(table) ->
          case table_sort.column_looks_numeric(table.rows, column) {
            True -> SortNumeric
            False -> SortText
          }
        Error(_) -> SortText
      }
      dict.insert(model.sorts, table_id, table_sort.default_spec(column, kind))
    }
  }
}

fn update_sort(
  sorts: Dict(String, SortSpec),
  table_id: String,
  alter: fn(SortSpec) -> SortSpec,
) -> Dict(String, SortSpec) {
  case dict.get(sorts, table_id) {
    Ok(spec) -> dict.insert(sorts, table_id, alter(spec))
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
    rsvp.expect_ok_response(fn(
      result: Result(Response(String), rsvp.Error(String)),
    ) {
      case result {
        Ok(response) -> SampleLoaded(Ok(response.body))
        Error(error) -> SampleLoaded(Error(describe_error(error)))
      }
    }),
  )
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
        html.div([attribute.class("nav-group")], [
          html.p([attribute.class("nav-label")], [html.text("Palworld")]),
          html.div(
            [attribute.class("nav-links")],
            list.map(samples.all(), fn(sample) {
              nav_button(
                sample.label,
                is_sample_page(model.page, sample),
                UserChoseSample(sample),
              )
            }),
          ),
        ]),
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
        tables_section(model, tables),
      ]
      SamplePage(sample) -> [
        html.p([attribute.class("sample-meta")], [
          html.text("Sample: " <> sample.label <> " — " <> sample.blurb),
        ]),
        filter_controls(model),
        tables_section(model, tables),
      ]
    }),
  ])
}

fn is_sample_page(page: Page, sample: Sample) -> Bool {
  case page {
    SamplePage(current) -> current.id == sample.id
    PastePage -> False
  }
}

fn apply_sort(table: Table, sorts: Dict(String, SortSpec)) -> Table {
  let id = table_id_for(table)
  case dict.get(sorts, id) {
    Ok(spec) ->
      markdown_table.Table(
        ..table,
        rows: table_sort.sort_rows(table.rows, spec),
      )
    Error(_) -> table
  }
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

fn tables_section(model: Model, tables: List(Table)) -> Element(Msg) {
  html.section([attribute.class("preview")], [
    html.h2([], [html.text("Tables")]),
    case model.loading {
      True -> html.p([attribute.class("empty")], [html.text("Loading sample…")])
      False ->
        case model.error {
          Some(message) ->
            html.p([attribute.class("error")], [html.text(message)])
          None -> render_tables(tables, model.markdown, model.sorts)
        }
    },
  ])
}

fn render_tables(
  tables: List(Table),
  markdown: String,
  sorts: Dict(String, SortSpec),
) -> Element(Msg) {
  case tables {
    [] if markdown == "" ->
      html.p([attribute.class("empty")], [
        html.text("Paste Markdown or open a Palworld sample to see tables."),
      ])
    [] ->
      html.p([attribute.class("empty")], [
        html.text("No tables matched this Markdown (or filter)."),
      ])
    _ ->
      html.div(
        [attribute.class("tables")],
        list.map(tables, fn(table) { render_table(table, sorts) }),
      )
  }
}

fn render_table(table: Table, sorts: Dict(String, SortSpec)) -> Element(Msg) {
  let id = table_id_for(table)
  let active = dict.get(sorts, id)

  html.section([attribute.class("md-table")], [
    html.h3([], [html.text(table.title)]),
    case active {
      Ok(spec) -> sort_controls(id, spec, table.headers)
      Error(_) ->
        html.p([attribute.class("sort-hint")], [
          html.text("Click a column header to sort. Click again to reverse."),
        ])
    },
    html.div([attribute.class("table-wrap")], [
      html.table([], [
        html.thead([], [
          html.tr(
            [],
            list.index_map(table.headers, fn(cell, index) {
              let selected = case active {
                Ok(spec) if spec.column == index -> True
                _ -> False
              }
              let marker = case active {
                Ok(spec) if spec.column == index ->
                  case spec.direction {
                    Asc -> " ↑"
                    Desc -> " ↓"
                  }
                _ -> ""
              }
              let class = case selected {
                True -> "sortable selected"
                False -> "sortable"
              }
              html.th([attribute.class(class)], [
                html.button(
                  [
                    attribute.type_("button"),
                    attribute.class("sort-header"),
                    event.on_click(UserClickedColumn(id, index)),
                  ],
                  [html.text(cell <> marker)],
                ),
              ])
            }),
          ),
        ]),
        html.tbody(
          [],
          list.map(table.rows, fn(row) {
            html.tr(
              [],
              list.map(row, fn(cell) { html.td([], [html.text(cell)]) }),
            )
          }),
        ),
      ]),
    ]),
  ])
}

fn sort_controls(
  table_id: String,
  spec: SortSpec,
  headers: List(String),
) -> Element(Msg) {
  let column_name = case list.drop(headers, spec.column) {
    [name, ..] -> name
    [] -> "Column"
  }

  html.div([attribute.class("sort-controls")], [
    html.p([attribute.class("sort-active")], [
      html.text("Sorting by " <> column_name),
    ]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Type")]),
      toggle_btn(
        "Text",
        spec.kind == SortText,
        UserSetSortKind(table_id, SortText),
      ),
      toggle_btn(
        "Numeric",
        spec.kind == SortNumeric,
        UserSetSortKind(table_id, SortNumeric),
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
        UserSetDirection(table_id, Asc),
      ),
      toggle_btn(
        case spec.kind {
          SortText -> "Z → A"
          SortNumeric -> "9 → 0"
        },
        spec.direction == Desc,
        UserSetDirection(table_id, Desc),
      ),
    ]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Empties")]),
      toggle_btn(
        "First",
        spec.empties == EmptiesFirst,
        UserSetEmptyPlacement(table_id, EmptiesFirst),
      ),
      toggle_btn(
        "Last",
        spec.empties == EmptiesLast,
        UserSetEmptyPlacement(table_id, EmptiesLast),
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
            UserSetTextPlacement(table_id, TextBeforeNumbers),
          ),
          toggle_btn(
            "After numbers",
            spec.texts == TextAfterNumbers,
            UserSetTextPlacement(table_id, TextAfterNumbers),
          ),
        ])
      SortText -> element.none()
    },
    html.button(
      [
        attribute.type_("button"),
        attribute.class("sort-clear"),
        event.on_click(UserClearSort(table_id)),
      ],
      [html.text("Clear sort")],
    ),
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
