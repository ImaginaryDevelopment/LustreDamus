import gleeunit
import markdown_table

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

fn list_length(items: List(a)) -> Int {
  case items {
    [] -> 0
    [_, ..rest] -> 1 + list_length(rest)
  }
}
