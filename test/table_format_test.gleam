import gleam/option.{None, Some}
import gleam/string
import gleeunit
import table_format

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn identity_keeps_raw_value_test() {
  let ctx =
    table_format.make_context("Flying", ["Pal", "Sprint"], 1, 0, [
      "Jetragon",
      "3300",
    ])
  let formatted = table_format.identity(ctx)
  assert formatted.text == "3300"
  assert formatted.class_name == ""
  assert formatted.title == None
}

pub fn decorate_stacks_empty_and_approx_styles_test() {
  let formatter =
    table_format.plain()
    |> table_format.decorate_all([
      table_format.style_empty_cells,
      table_format.style_approximate_numbers,
    ])

  let empty_ctx =
    table_format.make_context("Flying", ["Wild min"], 0, 0, ["—"])
  let empty = table_format.format_cell(formatter, empty_ctx)
  assert empty.class_name == "cell-empty"
  assert empty.title == Some("Empty / unknown")

  let approx_ctx =
    table_format.make_context("Flying", ["Wild min"], 0, 0, ["~76"])
  let approx = table_format.format_cell(formatter, approx_ctx)
  assert approx.class_name == "cell-approx"
  assert approx.title == Some("Approximate value")
}

pub fn trailing_asterisk_sets_title_tooltip_test() {
  let note = "Friendly NPC caution"
  let formatter =
    table_format.plain()
    |> table_format.with_trailing_asterisk_tooltip(note)

  let starred =
    table_format.make_context("By zone", ["Shortname"], 0, 0, ["akanon*"])
  let starred_cell = table_format.format_cell(formatter, starred)
  assert starred_cell.title == Some(note)
  assert string.contains(starred_cell.class_name, "cell-note")

  let plain =
    table_format.make_context("By zone", ["Shortname"], 0, 0, ["befallen"])
  let plain_cell = table_format.format_cell(formatter, plain)
  assert plain_cell.title == None
  assert plain_cell.class_name == ""
}

pub fn custom_formatter_can_rewrite_display_text_test() {
  let formatter =
    table_format.with_cell(table_format.plain(), fn(ctx) {
      case ctx.header {
        "Sprint" ->
          table_format.FormattedCell(
            text: ctx.value <> " spd",
            class_name: "cell-speed",
            title: None,
          )
        _ -> table_format.identity(ctx)
      }
    })

  let ctx =
    table_format.make_context("Flying", ["Pal", "Sprint"], 1, 0, [
      "Jetragon",
      "3300",
    ])
  let formatted = table_format.format_cell(formatter, ctx)
  assert formatted.text == "3300 spd"
  assert formatted.class_name == "cell-speed"
}
