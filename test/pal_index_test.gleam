import gleam/dict
import gleam/option.{None, Some}
import gleam/string
import gleeunit
import pal_index
import table_format

pub fn main() -> Nil {
  gleeunit.main()
}

const breeding_snippet = "
## Fixed traits

| Trait | Typical carriers | Effect |
| --- | --- | --- |
| Legend | Jetragon | buff |

## Full list (by 1.0 Paldex ID)

| ID | Name | Element(s) | Ride | Breed rank | Food | Notes |
| --- | --- | --- | --- | ---: | ---: | --- |
| 001 | Lamball | Neutral | - | 1470 | 2 |  |
| 021B | Ice Kingpaca | Ice | Ground | 440 | 7 |  |
| 137 | Blazamut | Fire | - |  |  |  |
| 202 | Jetragon | Dragon | Fly |  |  |  |
"

pub fn parse_full_list_elements_index_test() {
  let index = pal_index.parse_elements_index(breeding_snippet)
  assert dict.size(index) == 4
  let assert Ok("Neutral") = dict.get(index, "Lamball")
  let assert Ok("Ice") = dict.get(index, "Ice Kingpaca")
  let assert Ok("Dragon") = dict.get(index, "Jetragon")
}

pub fn lookup_strips_bold_and_role_suffix_test() {
  let index = pal_index.parse_elements_index(breeding_snippet)
  assert pal_index.lookup_elements(index, "**Jetragon**") == Some("Dragon")
  assert pal_index.lookup_elements(index, "Direhowl (ground)") == None
  assert pal_index.lookup_elements(index, "Ice Kingpaca") == Some("Ice")

  let with_dire = dict.insert(index, "Direhowl", "Neutral")
  assert pal_index.lookup_elements(with_dire, "Direhowl (ground)")
    == Some("Neutral")
  assert pal_index.lookup_elements(with_dire, "Direhowl (fly)")
    == Some("Neutral")
}

pub fn tooltip_decorator_sets_title_on_pal_columns_test() {
  let index = pal_index.parse_elements_index(breeding_snippet)
  let formatter =
    table_format.plain()
    |> pal_index.with_pal_element_tooltips(index)

  let ctx =
    table_format.make_context("Flying", ["Pal", "Sprint"], 0, 0, [
      "Jetragon",
      "3300",
    ])
  let formatted = table_format.format_cell(formatter, ctx)
  assert formatted.title == Some("Dragon")
  assert string.contains(formatted.class_name, "cell-pal")

  let other =
    table_format.make_context("Flying", ["Pal", "Sprint"], 1, 0, [
      "Jetragon",
      "3300",
    ])
  let sprint = table_format.format_cell(formatter, other)
  assert sprint.title == None
}
