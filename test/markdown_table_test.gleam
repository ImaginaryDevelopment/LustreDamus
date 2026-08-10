import gleeunit
import markdown_table
import table_sort.{
  Asc, Desc, EmptiesFirst, EmptiesLast, SortNumeric, SortText,
  TextAfterNumbers, TextBeforeNumbers,
}

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn extracts_tables_from_mixed_markdown_test() {
  let markdown =
    "
# Title

Intro paragraph.

## Flying

| Pal | Sprint |
| --- | ---: |
| Jetragon | 3300 |
| Nitewing | 750 |

More notes.

## Passives

| Passive | Bonus |
| --- | ---: |
| Swift | +30% |
"

  let tables = markdown_table.extract_tables(markdown)
  assert list_length(tables) == 2

  let assert [flying, passives] = tables
  assert flying.title == "Flying"
  assert flying.headers == ["Pal", "Sprint"]
  assert flying.rows == [["Jetragon", "3300"], ["Nitewing", "750"]]
  assert passives.title == "Passives"
  assert passives.rows == [["Swift", "+30%"]]
}

pub fn filter_tables_keeps_matching_rows_test() {
  let tables =
    markdown_table.extract_tables(
      "
| Pal | Sprint |
| --- | ---: |
| Jetragon | 3300 |
| Nitewing | 750 |
",
    )

  let filtered = markdown_table.filter_tables(tables, "jet")
  let assert [table] = filtered
  assert table.rows == [["Jetragon", "3300"]]
}

pub fn empty_fillers_are_empty_test() {
  assert table_sort.is_empty_cell("")
  assert table_sort.is_empty_cell(" ")
  assert table_sort.is_empty_cell("-")
  assert table_sort.is_empty_cell("--")
  assert table_sort.is_empty_cell("—")
  assert !table_sort.is_empty_cell("none")
  assert !table_sort.is_empty_cell("~76")
}

pub fn parse_tilde_and_embedded_numbers_test() {
  let assert Ok(76.0) = table_sort.parse_number("~76")
  let assert Ok(60.0) = table_sort.parse_number("Alpha ~60")
  let assert Ok(100.0) = table_sort.parse_number("100*")
  let assert Ok(3300.0) = table_sort.parse_number("3300")
  let assert Error(Nil) = table_sort.parse_number("Raid only")
}

pub fn numeric_sort_numbers_then_text_then_empty_test() {
  let rows = [
    ["Raid only"],
    ["—"],
    ["~76"],
    ["6"],
    ["-"],
    ["Alpha ~60"],
    ["World Tree"],
  ]

  let sorted =
    table_sort.sort_rows(
      rows,
      table_sort.SortSpec(
        column: 0,
        kind: SortNumeric,
        direction: Asc,
        empties: EmptiesLast,
        texts: TextAfterNumbers,
      ),
    )

  assert sorted
    == [
      ["6"],
      ["Alpha ~60"],
      ["~76"],
      ["Raid only"],
      ["World Tree"],
      ["-"],
      ["—"],
    ]
}

pub fn numeric_sort_desc_and_empties_first_test() {
  let rows = [["~76"], ["—"], ["6"], ["Raid only"]]

  let sorted =
    table_sort.sort_rows(
      rows,
      table_sort.SortSpec(
        column: 0,
        kind: SortNumeric,
        direction: Desc,
        empties: EmptiesFirst,
        texts: TextAfterNumbers,
      ),
    )

  assert sorted == [["—"], ["~76"], ["6"], ["Raid only"]]
}

pub fn text_before_numbers_placement_test() {
  let rows = [["~76"], ["Raid only"], ["-"]]

  let sorted =
    table_sort.sort_rows(
      rows,
      table_sort.SortSpec(
        column: 0,
        kind: SortNumeric,
        direction: Asc,
        empties: EmptiesLast,
        texts: TextBeforeNumbers,
      ),
    )

  assert sorted == [["Raid only"], ["~76"], ["-"]]
}

pub fn text_sort_respects_empties_test() {
  let rows = [["Nitewing"], ["-"], ["Jetragon"], ["—"]]

  let sorted =
    table_sort.sort_rows(
      rows,
      table_sort.SortSpec(
        column: 0,
        kind: SortText,
        direction: Asc,
        empties: EmptiesLast,
        texts: TextAfterNumbers,
      ),
    )

  assert sorted == [["Jetragon"], ["Nitewing"], ["-"], ["—"]]
}

fn list_length(items: List(a)) -> Int {
  case items {
    [] -> 0
    [_, ..rest] -> 1 + list_length(rest)
  }
}
