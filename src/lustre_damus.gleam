import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub type Model {
  Model(markdown: String)
}

pub type Msg {
  UserUpdatedMarkdown(String)
}

pub fn main() -> Nil {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn init(_flags: Nil) -> Model {
  Model(markdown: "")
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserUpdatedMarkdown(markdown) -> Model(markdown:)
  }
}

fn view(model: Model) -> Element(Msg) {
  html.div([attribute.class("app")], [
    html.header([], [
      html.h1([], [html.text("LustreDamus")]),
      html.p([], [
        html.text("Paste Markdown with tables to preview them in the browser."),
      ]),
    ]),
    html.main([], [
      html.label([attribute.for("markdown")], [html.text("Markdown")]),
      html.textarea(
        [
          attribute.id("markdown"),
          attribute.rows(16),
          attribute.placeholder(
            "| Name | Role |\n| ---- | ---- |\n| Ada  | Lead |",
          ),
          event.on_input(UserUpdatedMarkdown),
        ],
        model.markdown,
      ),
      html.section([attribute.class("preview")], [
        html.h2([], [html.text("Preview")]),
        preview(model.markdown),
      ]),
    ]),
  ])
}

fn preview(markdown: String) -> Element(Msg) {
  case markdown {
    "" ->
      html.p([attribute.class("empty")], [
        html.text("Your table preview will show up here."),
      ])
    _ ->
      html.pre([], [
        html.code([], [html.text(markdown)]),
      ])
  }
}
