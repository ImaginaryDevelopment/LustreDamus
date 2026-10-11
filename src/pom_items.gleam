//// Plane of Mischief item stats / classes (IdleQuest items export).
//// Used for hover tooltips and class labels on PoM tables / deck tracker.
//// Regenerate data with: python tools/gen_pom_items.py

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import markdown_table.{type Table, Table as MdTable}
import table_format.{type TableFormatter, FormattedCell}
import table_sort

pub type ItemInfo {
  ItemInfo(name: String, classes: String, stats: String)
}

pub fn items() -> List(ItemInfo) {
  [
    ItemInfo("Belt of Inconsistency", "ALL", "Slot: WAIST, AC: 15, HP: 70, MANA: 70, END: 70, STR: +1, AGI: +1, DEX: +1, WIS: +1, INT: +1, SV FIRE: +3, SV COLD: +3, SV MAGIC: +3, SV DISEASE: +3, SV POISON: +3"),
    ItemInfo("Black Flower of Functionality", "ALL", "Slot: HEAD/RANGE, AC: 10, Effect: disease resist aura"),
    ItemInfo("Blam Stick", "WAR CLR PAL RNG SHD DRU MNK BRD ROG SHM BST", "Slot: PRIMARY, 30/40 (0.75), Proc: Fireball animation"),
    ItemInfo("Blue Flower of Functionality", "ALL", "Slot: HEAD/RANGE, AC: 10, Effect: magic resist aura"),
    ItemInfo("Boots of Distraction", "WAR CLR PAL SHD BRD", "Slot: FEET, AC: 24, HP: 20, MANA: 20, END: 20, WIS: +10, INT: +10, WT: 5"),
    ItemInfo("Bracelet of the Twisted Mind", "NEC WIZ MAG ENC", "Slot: WRIST, AC: 10, HP: 35, MANA: 35, STA: +5, INT: +5"),
    ItemInfo("Breastplate of Distraction", "WAR CLR PAL SHD BRD", "Slot: CHEST, AC: 36, HP: 50, MANA: 30, END: 30, STA: +10, DEX: +10, WT: 7"),
    ItemInfo("Buckler of Doom", "ALL", "Slot: SECONDARY, AC: 10, HP: 45, MANA: 40, END: 40, STR: +15"),
    ItemInfo("Cloak of Confusion", "ALL", "Slot: BACK, AC: 14, HP: 45, STR: +10, STA: +15, CHA: +15, SV FIRE: +5, SV COLD: +5, SV MAGIC: +10, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Crazy Cleric Arm Plate", "CLR", "Slot: ARMS, AC: 32, MANA: 25, STR: +5, STA: +5, SV FIRE: +5, SV COLD: +5, WT: 4"),
    ItemInfo("Crazy Cleric Boots", "CLR", "Slot: FEET, AC: 30, HP: 20, MANA: 30, STA: +5, AGI: +5, SV MAGIC: +10, WT: 3"),
    ItemInfo("Crazy Cleric Breastplate", "CLR", "Slot: CHEST, AC: 60, HP: 40, MANA: 90, STR: +5, STA: +5, WIS: +15, SV MAGIC: +10, SV DISEASE: +5, SV POISON: +5, WT: 6"),
    ItemInfo("Crazy Cleric Gauntlets", "CLR", "Slot: HANDS, AC: 25, HP: 10, MANA: 40, DEX: +10, WIS: +5, INT: +5, SV POISON: +5, WT: 3"),
    ItemInfo("Crazy Cleric Greaves", "CLR", "Slot: LEGS, AC: 45, HP: 20, MANA: 60, STR: +5, STA: +5, AGI: +5, SV DISEASE: +5, SV POISON: +5, WT: 6"),
    ItemInfo("Crazy Cleric Helm", "CLR", "Slot: HEAD, AC: 35, HP: 20, MANA: 25, WIS: +10, CHA: +10, SV FIRE: +5, SV COLD: +5, WT: 1"),
    ItemInfo("Crazy Cleric Wrist Guard", "CLR", "Slot: WRIST, AC: 23, MANA: 40, STR: +5, WIS: +5, SV MAGIC: +5, WT: 2"),
    ItemInfo("Crown of Distraction", "WAR CLR PAL SHD BRD", "Slot: HEAD, AC: 18, STR: +3, STA: +3, AGI: +3, DEX: +3, WIS: +3, INT: +3, CHA: +3, SV FIRE: +3, SV COLD: +3, SV MAGIC: +3, SV DISEASE: +3, SV POISON: +3"),
    ItemInfo("Globe of Darkness", "ALL", "Slot: RANGE, STA: +7, SV DISEASE: +15"),
    ItemInfo("Gloves of Distraction", "WAR CLR PAL SHD BRD", "Slot: HANDS, AC: 20, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5, SV DISEASE: +5, SV POISON: +5, WT: 5"),
    ItemInfo("Greaves of Distraction", "WAR CLR PAL SHD BRD", "Slot: LEGS, AC: 30, STR: +12, CHA: +12, WT: 5"),
    ItemInfo("Green Flower of Functionality", "ALL", "Slot: HEAD/RANGE, AC: 10, Effect: poison resist aura (stacks)"),
    ItemInfo("Green Wristguard", "RNG DRU", "Slot: WRIST, AC: 20, MANA: 35, STR: +5, WIS: +5, WT: 5"),
    ItemInfo("Idiot Savant's Cap", "ALL", "Slot: HEAD, AC: 21, STR: +8, DEX: +8, WIS: -5, INT: -5"),
    ItemInfo("Maleficent Boots", "NEC", "Slot: FEET, AC: 8, HP: 35, MANA: 5, STR: +5, STA: +5, SV DISEASE: +5, WT: 0.4"),
    ItemInfo("Maleficent Bracer", "NEC", "Slot: WRIST, AC: 6, HP: 20, MANA: 5, STA: +4, DEX: +4, INT: +4, SV MAGIC: +5, WT: 0.2"),
    ItemInfo("Maleficent Crown", "NEC", "Slot: HEAD, AC: 10, HP: 35, MANA: 15, WIS: +4, INT: +10, CHA: -10, SV MAGIC: +5, SV POISON: +5, WT: 0.2"),
    ItemInfo("Maleficent Gloves", "NEC", "Slot: HANDS, AC: 8, HP: 25, MANA: 30, STA: +5, INT: +6, SV FIRE: +5, SV COLD: +5, WT: 0.2"),
    ItemInfo("Maleficent Leggings", "NEC", "Slot: LEGS, AC: 10, MANA: 15, STA: +15, AGI: +15, SV FIRE: +5, SV COLD: +5, WT: 0.4"),
    ItemInfo("Maleficent Robe", "NEC", "Slot: CHEST, AC: 22, HP: 100, MANA: 40, STR: +5, STA: +15, AGI: +5, INT: +15, CHA: -10, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5, SV DISEASE: +20, SV POISON: +15, WT: 0.5"),
    ItemInfo("Maleficent Sleeves", "NEC", "Slot: ARMS, AC: 10, HP: 40, MANA: 10, STR: +2, INT: +5, SV POISON: +5, WT: 0.2"),
    ItemInfo("Mask of Melodies", "BRD", "Slot: FACE, AC: 14, HP: 50, CHA: +15"),
    ItemInfo("Mischievous Dazzler Bracer", "ENC", "Slot: WRIST, AC: 10, HP: 10, MANA: 20, DEX: +5, INT: +5, SV FIRE: +5, SV COLD: +5, WT: 0.2"),
    ItemInfo("Mischievous Dazzler Crown", "ENC", "Slot: HEAD, AC: 14, HP: 20, MANA: 30, WIS: +5, INT: +10, CHA: +10, SV MAGIC: +15, WT: 0.2"),
    ItemInfo("Mischievous Dazzler Gloves", "ENC", "Slot: HANDS, AC: 12, HP: 10, MANA: 25, DEX: +10, INT: +10, SV DISEASE: +5, SV POISON: +5, WT: 0.2"),
    ItemInfo("Mischievous Dazzler Leggings", "ENC", "Slot: LEGS, AC: 16, HP: 15, MANA: 20, STA: +10, AGI: +10, CHA: +5, SV FIRE: +10, SV COLD: +10, WT: 0.5"),
    ItemInfo("Mischievous Dazzler Robe", "ENC", "Slot: CHEST, AC: 22, HP: 50, MANA: 80, STR: +5, INT: +15, CHA: +15, SV FIRE: +10, SV COLD: +10, SV MAGIC: +10, WT: 0.5"),
    ItemInfo("Mischievous Dazzler Shoes", "ENC", "Slot: FEET, AC: 12, HP: 15, MANA: 20, STA: +5, AGI: +5, SV DISEASE: +5, SV POISON: +5, WT: 0.5"),
    ItemInfo("Mischievous Dazzler Sleeves", "ENC", "Slot: ARMS, AC: 14, HP: 20, MANA: 20, STR: +5, STA: +5, CHA: +5, SV DISEASE: +10, SV POISON: +10, WT: 0.2"),
    ItemInfo("Monkey Hide Arm Plate", "MNK", "Slot: ARMS, AC: 14, HP: 25, END: 20, STR: +5, STA: +5, CHA: +5, SV COLD: +5, SV POISON: +5, WT: 0.1"),
    ItemInfo("Monkey Hide Boots", "MNK", "Slot: FEET, AC: 12, HP: 40, AGI: +5, INT: +5, SV MAGIC: +10, WT: 0.1"),
    ItemInfo("Monkey Hide Breastplate", "MNK", "Slot: CHEST, AC: 25, HP: 60, END: 40, STR: +15, STA: +15, AGI: +10, SV MAGIC: +5, SV DISEASE: +5, SV POISON: +5, WT: 0.5"),
    ItemInfo("Monkey Hide Gauntlets", "MNK", "Slot: HANDS, AC: 11, HP: 35, STR: +5, DEX: +5, CHA: +5, SV COLD: +5, SV DISEASE: +5, WT: 0.1"),
    ItemInfo("Monkey Hide Greaves", "MNK", "Slot: LEGS, AC: 15, HP: 30, END: 20, STA: +15, AGI: +15, SV MAGIC: +5, SV DISEASE: +5, WT: 0.1"),
    ItemInfo("Monkey Hide Helm", "MNK", "Slot: HEAD, AC: 15, HP: 30, DEX: +10, INT: +5, SV FIRE: +5, SV COLD: +5, WT: 0.1"),
    ItemInfo("Monkey Hide Wrist Guard", "MNK", "Slot: WRIST, AC: 10, HP: 20, END: 15, STR: +5, DEX: +5, WIS: +5, SV FIRE: +5, SV POISON: +5, WT: 0.1"),
    ItemInfo("Mushroom Bracelet", "MNK", "Slot: WRIST, AC: 18, STR: +6, AGI: +6, SV FIRE: +3, SV COLD: +3, SV MAGIC: +3, SV DISEASE: +3, SV POISON: +3"),
    ItemInfo("Onyx Wristbands", "SHD", "Slot: WRIST, AC: 23, HP: 25, MANA: 25, STR: +7, INT: +7, SV FIRE: +2, SV COLD: +2, SV MAGIC: +2, SV DISEASE: +2, SV POISON: +2, WT: 5"),
    ItemInfo("Red Flower of Functionality", "ALL", "Slot: HEAD/RANGE, AC: 10, Effect: fire resist aura"),
    ItemInfo("Robe of Distraction", "NEC WIZ MAG ENC", "Slot: CHEST, AC: 20, MANA: 90, STA: +10, INT: +10"),
    ItemInfo("Shamanistic Shenanigan Gauntlets", "SHM", "Slot: HANDS, AC: 16, HP: 20, DEX: +5, WIS: +5, SV DISEASE: +5, SV POISON: +5, WT: 3"),
    ItemInfo("Shamanistic Shenannigan Arm Guard", "SHM", "Slot: ARMS, AC: 23, HP: 20, STR: +10, STA: +5, SV FIRE: +5, SV COLD: +5, WT: 4"),
    ItemInfo("Shamanistic Shenannigan Boots", "SHM", "Slot: FEET, AC: 45, HP: 50, MANA: 10, STR: +5, STA: +10, AGI: +10, SV COLD: +5, SV DISEASE: +5, WT: 3"),
    ItemInfo("Shamanistic Shenannigan Bracer", "SHM", "Slot: WRIST, AC: 16, HP: 20, DEX: +5, WIS: +5, SV DISEASE: +5, SV POISON: +5, WT: 2"),
    ItemInfo("Shamanistic Shenannigan Chestplate", "SHM", "Slot: CHEST, AC: 52, HP: 60, MANA: 40, STR: +5, WIS: +15, INT: +15, SV MAGIC: +10, SV DISEASE: +15, SV POISON: +15, WT: 6"),
    ItemInfo("Shamanistic Shenannigan Greaves", "SHM", "Slot: LEGS, AC: 20, HP: 30, MANA: 10, DEX: +10, WIS: +10, SV COLD: +5, SV POISON: +5, WT: 6"),
    ItemInfo("Shamanistic Shenannigan Helm", "SHM", "Slot: HEAD, AC: 24, HP: 25, MANA: 20, WIS: +10, INT: +5, CHA: +10, SV FIRE: +5, SV COLD: +5, WT: 1"),
    ItemInfo("Shimmering Wristguard", "CLR PAL", "Slot: WRIST, AC: 22, HP: 20, MANA: 20, WIS: +8, WT: 5"),
    ItemInfo("Silver Wristguards", "PAL", "Slot: WRIST, AC: 23, STR: +7, WIS: +7, SV FIRE: +2, SV COLD: +2, SV MAGIC: +2, SV DISEASE: +2, SV POISON: +2, WT: 5"),
    ItemInfo("Sly Summoners Crown", "MAG", "Slot: HEAD, AC: 10, HP: 25, MANA: 25, WIS: +10, INT: +7, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5, WT: 0.2"),
    ItemInfo("Sly Summoners Gloves", "MAG", "Slot: HANDS, AC: 8, HP: 50, MANA: 50, DEX: +6, INT: +6, SV DISEASE: +5, SV POISON: +5, WT: 0.4"),
    ItemInfo("Sly Summoners Pants", "MAG", "Slot: LEGS, AC: 10, HP: 20, MANA: 20, STA: +10, AGI: +10, INT: +10, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5, SV DISEASE: +5, SV POISON: +5, WT: 0.5"),
    ItemInfo("Sly Summoners Robe", "MAG", "Slot: CHEST, AC: 22, HP: 50, MANA: 90, STR: +10, STA: +15, INT: +15, SV FIRE: +20, SV COLD: +20, SV MAGIC: +10, WT: 0.5"),
    ItemInfo("Sly Summoners Sleeves", "MAG", "Slot: ARMS, AC: 10, HP: 20, MANA: 20, STR: +4, INT: +4, SV FIRE: +10, SV COLD: +10, SV DISEASE: +10, SV POISON: +10, WT: 0.4"),
    ItemInfo("Sly Summoners Wristguard", "MAG", "Slot: WRIST, AC: 6, HP: 10, MANA: 10, AGI: +5, INT: +5, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5, WT: 0.3"),
    ItemInfo("Sly Summoners boots", "MAG", "Slot: FEET, AC: 8, HP: 15, MANA: 25, CHA: +3, SV FIRE: +5, SV COLD: +5, SV DISEASE: +5, SV POISON: +5, WT: 0.4"),
    ItemInfo("Twisted Nature Armband", "DRU", "Slot: ARMS, AC: 16, HP: 20, STR: +5, STA: +5, CHA: +5, SV FIRE: +10, SV COLD: +10, WT: 2"),
    ItemInfo("Twisted Nature Boots", "DRU", "Slot: FEET, AC: 12, HP: 15, MANA: 25, STA: +5, AGI: +5, SV MAGIC: +5, WT: 1.5"),
    ItemInfo("Twisted Nature Bracer", "DRU", "Slot: WRIST, AC: 10, HP: 20, DEX: +5, WIS: +5, SV DISEASE: +5, SV POISON: +5, WT: 1"),
    ItemInfo("Twisted Nature Chestguard", "DRU", "Slot: CHEST, AC: 32, HP: 50, MANA: 90, STR: +5, WIS: +15, INT: +15, SV MAGIC: +15, SV DISEASE: +15, SV POISON: +15, WT: 3"),
    ItemInfo("Twisted Nature Crown", "DRU", "Slot: HEAD, AC: 15, HP: 25, MANA: 25, WIS: +10, INT: +5, CHA: +10, SV FIRE: +5, SV COLD: +5, WT: 0.5"),
    ItemInfo("Twisted Nature Gloves", "DRU", "Slot: HANDS, AC: 15, HP: 50, MANA: 40, DEX: +10, WIS: +10, SV FIRE: +5, SV COLD: +5, WT: 1.5"),
    ItemInfo("Twisted Nature Leggings", "DRU", "Slot: LEGS, AC: 25, HP: 20, MANA: 20, STA: +10, AGI: +10, WIS: +5, SV COLD: +5, SV DISEASE: +5, WT: 2.5"),
    ItemInfo("Vambraces of Distraction", "WAR CLR PAL SHD BRD", "Slot: ARMS, AC: 27, AGI: +8, WIS: +5, WT: 5"),
    ItemInfo("Very Rusty Dagger", "SHD ROG BST", "Slot: RANGE/PRIMARY/SECONDARY, 12/23 (0.52), STR: +10, SV DISEASE: -10, WT: 6, Proc"),
    ItemInfo("White Flower of Functionality", "ALL", "Slot: HEAD/RANGE, AC: 10, Effect: cold resist aura (stacks)"),
    ItemInfo("Wily Warlock Boots", "WIZ", "Slot: FEET, AC: 8, HP: 20, MANA: 35, STA: +5, AGI: +10, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5, WT: 0.4"),
    ItemInfo("Wily Warlock Bracer", "WIZ", "Slot: WRIST, AC: 6, HP: 5, MANA: 25, DEX: +5, INT: +5, SV FIRE: +2, SV COLD: +2, SV MAGIC: +2, SV DISEASE: +2, SV POISON: +2, WT: 0.1"),
    ItemInfo("Wily Warlock Crown", "WIZ", "Slot: HEAD, AC: 10, HP: 25, MANA: 35, WIS: +10, INT: +10, CHA: +5, SV MAGIC: +10, WT: 0.1"),
    ItemInfo("Wily Warlock Gloves", "WIZ", "Slot: HANDS, AC: 8, MANA: 40, DEX: +10, INT: +10, SV DISEASE: +5, SV POISON: +5, WT: 0.1"),
    ItemInfo("Wily Warlock Pants", "WIZ", "Slot: LEGS, AC: 20, HP: 5, MANA: 5, STA: +10, AGI: +10, SV FIRE: +2, SV COLD: +2, SV MAGIC: +2, SV DISEASE: +2, SV POISON: +2, WT: 0.4"),
    ItemInfo("Wily Warlock Robe", "WIZ", "Slot: CHEST, AC: 22, HP: 40, MANA: 100, STR: +5, AGI: +10, INT: +20, SV FIRE: +10, SV COLD: +10, SV MAGIC: +10, SV DISEASE: +10, SV POISON: +10, WT: 0.5"),
    ItemInfo("Wily Warlock Sleeves", "WIZ", "Slot: ARMS, AC: 10, HP: 10, MANA: 45, STR: +5, STA: +5, AGI: +5, WT: 0.2"),
    ItemInfo("Wristguard of Distraction", "WAR CLR PAL SHD BRD", "Slot: WRIST, AC: 19, HP: 35, MANA: 35, END: 35, STR: +3, WIS: +3, INT: +3"),
  ]
}

pub fn alias_target(label: String) -> String {
  case label {
    "Black Flower" -> "Black Flower of Functionality"
    "Blam Stick (1H Blunt)" -> "Blam Stick"
    "Blue Flower" -> "Blue Flower of Functionality"
    "Green Flower" -> "Green Flower of Functionality"
    "Red Flower" -> "Red Flower of Functionality"
    "Sly Summoners Boots" -> "Sly Summoners boots"
    "White Flower" -> "White Flower of Functionality"
    _ -> label
  }
}

pub fn lookup(name: String) -> Option(ItemInfo) {
  let key = normalize(alias_target(normalize(name)))
  case key {
    "" -> None
    _ ->
      list.find(items(), fn(item) { normalize(item.name) == key })
      |> option.from_result
  }
}

pub fn tooltip(name: String) -> Option(String) {
  case lookup(name) {
    None -> None
    Some(item) -> {
      let body = case item.stats {
        "" -> "Quest / combine reagent"
        stats -> stats
      }
      case item.classes {
        "ALL" | "" -> Some(body)
        classes -> Some(classes <> " — " <> body)
      }
    }
  }
}

/// Restricted classes only (None when ALL / unknown).
pub fn classes_for(name: String) -> Option(String) {
  case lookup(name) {
    Some(ItemInfo(_, "ALL", _)) -> None
    Some(ItemInfo(_, "", _)) -> None
    Some(ItemInfo(_, classes, _)) -> Some(classes)
    None -> None
  }
}

pub fn normalize(value: String) -> String {
  value
  |> string.trim
  |> string.replace("**", "")
  |> string.replace("__", "")
  |> string.trim
}

/// Hover stats on Item / Set cells (and any cell that exactly matches a known item).
pub fn with_item_tooltips(formatter: TableFormatter) -> TableFormatter {
  table_format.decorate(formatter, fn(ctx, cell) {
    case should_tooltip(ctx.header, ctx.value) {
      False -> cell
      True ->
        case tooltip(ctx.value) {
          Some(text) ->
            FormattedCell(
              ..cell,
              class_name: append_class(cell.class_name, "cell-item"),
              title: Some(text),
            )
          None -> cell
        }
    }
  })
}

fn should_tooltip(header: String, value: String) -> Bool {
  let h = string.lowercase(string.trim(header))
  case h {
    "item" | "set" -> True
    _ ->
      case lookup(value) {
        Some(_) -> True
        None -> False
      }
  }
}

fn append_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}

/// Add or fill a Classes column from IdleQuest restrictions (blank when ALL).
pub fn with_classes_on_item_rows(tables: List(Table)) -> List(Table) {
  list.map(tables, enrich_table)
}

fn enrich_table(table: Table) -> Table {
  case column_index(table.headers, "Item") {
    Error(_) -> table
    Ok(item_i) ->
      case class_column_index(table.headers) {
        Ok(class_i) -> fill_classes(table, item_i, class_i)
        Error(_) -> insert_classes(table, item_i)
      }
  }
}

fn class_column_index(headers: List(String)) -> Result(Int, Nil) {
  case column_index(headers, "Classes") {
    Ok(i) -> Ok(i)
    Error(_) -> column_index(headers, "Class")
  }
}

fn fill_classes(table: Table, item_i: Int, class_i: Int) -> Table {
  let rows =
    list.map(table.rows, fn(row) {
      let current = cell_at(row, class_i)
      case table_sort.is_empty_cell(current) || string.trim(current) == "" {
        False -> row
        True ->
          case classes_for(cell_at(row, item_i)) {
            None -> row
            Some(classes) -> set_cell(row, class_i, classes)
          }
      }
    })
  MdTable(..table, rows:)
}

fn insert_classes(table: Table, item_i: Int) -> Table {
  let headers = insert_at(table.headers, item_i + 1, "Classes")
  let rows =
    list.map(table.rows, fn(row) {
      let classes = case classes_for(cell_at(row, item_i)) {
        Some(c) -> c
        None -> ""
      }
      insert_at(row, item_i + 1, classes)
    })
  MdTable(..table, headers:, rows:)
}

fn column_index(headers: List(String), wanted: String) -> Result(Int, Nil) {
  list.index_map(headers, fn(header, i) { #(header, i) })
  |> list.find(fn(pair) {
    let #(header, _) = pair
    string.lowercase(string.trim(header)) == string.lowercase(wanted)
  })
  |> result_map_second
}

fn result_map_second(found: Result(#(String, Int), Nil)) -> Result(Int, Nil) {
  case found {
    Ok(#(_, i)) -> Ok(i)
    Error(Nil) -> Error(Nil)
  }
}

fn cell_at(row: List(String), index: Int) -> String {
  case list.drop(row, index) {
    [cell, ..] -> cell
    [] -> ""
  }
}

fn set_cell(row: List(String), index: Int, value: String) -> List(String) {
  list.index_map(row, fn(cell, i) {
    case i == index {
      True -> value
      False -> cell
    }
  })
}

fn insert_at(items: List(String), index: Int, value: String) -> List(String) {
  let #(before, after) = list.split(items, index)
  list.append(before, [value, ..after])
}
