import ct_items
import gleam/option.{None, Some}
import gleam/string
import gleeunit/should
import table_format

pub fn loot_cell_lists_each_item_test() {
  let assert Some(tip) =
    ct_items.tooltip_for_cell(
      "**Piranha Scale Fistwraps** / **Piranha Scale Wristwrap**",
    )
  string.contains(tip, "Piranha Scale Fistwraps") |> should.be_true
  string.contains(tip, "MNK") |> should.be_true
  string.contains(tip, "Piranha Scale Wristwrap") |> should.be_true
  string.contains(tip, "WIZ") |> should.be_true
}

pub fn item_cell_ignores_slot_suffix_test() {
  let assert Some(tip) = ct_items.tooltip_for_cell("Fearsome Girdle (Waist)")
  string.contains(tip, "all classes, all races") |> should.be_true
  string.contains(tip, "Haste: 41%") |> should.be_true
}

pub fn radiant_gloves_include_races_test() {
  let assert Some(tip) = ct_items.tooltip("Radiant Gloves")
  string.contains(tip, "ENC") |> should.be_true
  string.contains(tip, "HUM") |> should.be_true
  string.contains(tip, "DRA") |> should.be_true
}

pub fn only_loot_and_item_columns_hover_test() {
  let formatter = table_format.plain() |> ct_items.with_item_tooltips
  let loot =
    table_format.make_context(
      "Named spawn",
      ["Loot"],
      0,
      0,
      ["Radiant Gloves"],
    )
    |> table_format.format_cell(formatter, _)
  let assert Some(tip) = loot.title
  string.contains(tip, "ENC") |> should.be_true

  let notes =
    table_format.make_context(
      "Named spawn",
      ["PH / notes"],
      0,
      0,
      ["Radiant Gloves"],
    )
    |> table_format.format_cell(formatter, _)
  notes.title |> should.equal(None)
  ct_items.tooltip("not an item") |> should.be_none
}
