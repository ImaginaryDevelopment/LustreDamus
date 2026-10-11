import gleam/option.{Some}
import gleam/string
import gleeunit/should
import markdown_table
import pom_items

pub fn tooltip_includes_stats_and_classes_test() {
  let assert Some(tip) = pom_items.tooltip("Boots of Distraction")
  string.contains(tip, "WAR") |> should.be_true
  string.contains(tip, "AC:") |> should.be_true
}

pub fn flower_alias_resolves_test() {
  let assert Some(tip) = pom_items.tooltip("Black Flower")
  string.contains(tip, "disease") |> should.be_true
}

pub fn classes_for_skips_all_test() {
  pom_items.classes_for("Belt of Inconsistency")
  |> should.be_none
  let assert Some(classes) = pom_items.classes_for("Mask of Melodies")
  classes |> should.equal("BRD")
}

pub fn with_classes_inserts_column_test() {
  let tables =
    "
## Rewards

| Item | Cards |
| --- | --- |
| Mask of Melodies | Red Throne, Red Crown, Red Knight, Red Squire |
| Buckler of Doom | Black Throne, Black Crown, Black Knight, Black Squire |
"
    |> markdown_table.extract_tables
    |> pom_items.with_classes_on_item_rows

  let assert [table] = tables
  table.headers
  |> should.equal(["Item", "Classes", "Cards"])
  let assert [mask, buckler] = table.rows
  mask
  |> should.equal([
    "Mask of Melodies",
    "BRD",
    "Red Throne, Red Crown, Red Knight, Red Squire",
  ])
  // ALL stays blank
  buckler
  |> should.equal([
    "Buckler of Doom",
    "",
    "Black Throne, Black Crown, Black Knight, Black Squire",
  ])
}
