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

pub type Page {
  PastePage
  PalworldMountsPage
}

pub type Model {
  Model(
    page: Page,
    markdown: String,
    filter: String,
    loading: Bool,
    error: Option(String),
  )
}

pub type Msg {
  UserChosePaste
  UserChosePalworldMounts
  UserUpdatedMarkdown(String)
  UserUpdatedFilter(String)
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

    UserChosePalworldMounts -> #(
      Model(
        page: PalworldMountsPage,
        markdown: "",
        filter: "",
        loading: True,
        error: None,
      ),
      load_sample("./samples/palworld/Mounts.md"),
    )

    UserUpdatedMarkdown(markdown) -> #(
      Model(..model, markdown:, error: None),
      effect.none(),
    )

    UserUpdatedFilter(filter) -> #(Model(..model, filter:), effect.none())

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

fn load_sample(url: String) -> Effect(Msg) {
  rsvp.get(
    url,
    rsvp.expect_ok_response(fn(result: Result(Response(String), rsvp.Error(String))) {
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

  html.div([attribute.class("app")], [
    html.header([], [
      html.h1([], [html.text("LustreDamus")]),
      html.p([], [
        html.text(
          "Read Markdown tables in the browser — paste your own, or open a sample.",
        ),
      ]),
    ]),
    html.nav([attribute.class("site-nav"), attribute.attribute("aria-label", "Sections")], [
      nav_button("Paste Markdown", model.page == PastePage, UserChosePaste),
      html.div([attribute.class("nav-group")], [
        html.p([attribute.class("nav-label")], [html.text("Palworld")]),
        nav_button(
          "Mounts",
          model.page == PalworldMountsPage,
          UserChosePalworldMounts,
        ),
      ]),
    ]),
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
      PalworldMountsPage -> [
        html.p([attribute.class("sample-meta")], [
          html.text("Sample: Palworld mounts (speed, stamina & saddles)."),
        ]),
        filter_controls(model),
        tables_section(model, tables),
      ]
    }),
  ])
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
          None -> render_tables(tables, model.markdown)
        }
    },
  ])
}

fn render_tables(tables: List(Table), markdown: String) -> Element(Msg) {
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
        list.map(tables, render_table),
      )
  }
}

fn render_table(table: Table) -> Element(Msg) {
  html.section([attribute.class("md-table")], [
    html.h3([], [html.text(table.title)]),
    html.div([attribute.class("table-wrap")], [
      html.table([], [
        html.thead([], [
          html.tr(
            [],
            list.map(table.headers, fn(cell) {
              html.th([], [html.text(cell)])
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
