//// Cazic-Thule item stats / classes / races (IdleQuest items export).
//// Hover tooltips on Loot and Item cells. Regenerate: python tools/gen_ct_items.py

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import table_format.{type TableFormatter, FormattedCell}

pub type ItemInfo {
  ItemInfo(name: String, classes: String, races: String, stats: String)
}

/// Longest name first so a shorter item is not matched inside a longer one.
pub fn items() -> List(ItemInfo) {
  [
    ItemInfo("Ooze Covered Rubicite Greaves", "WAR SHD", "ALL", "Slot: LEGS, AC: 28, END: 35, STR: +5, WIS: +5, INT: +5, SV FIRE: +4, SV COLD: +4, SV MAGIC: +4, SV DISEASE: +4, SV POISON: +4"),
    ItemInfo("Staff of Primordial Summoning", "NEC WIZ MAG ENC", "ALL", "Slot: PRIMARY, 32/32 (1.00), HP: 35, MANA: 40, AGI: +8, DEX: +8, WIS: +8, INT: +8"),
    ItemInfo("Fetid Shiverback Hide Mantle", "RNG DRU", "ALL", "Slot: SHOULDERS, AC: 10, HP: 35, MANA: 30, STA: +5, DEX: +5, WIS: +4"),
    ItemInfo("Fetid Shiverback Hide Bracer", "DRU", "ALL", "Slot: WRIST, AC: 10, MANA: 35, WIS: +10"),
    ItemInfo("Rotting Gorilla Hide Sleeves", "DRU MNK BST", "ALL", "Slot: ARMS, AC: 10, HP: 20, MANA: 15, END: 15, WIS: +5, INT: +5"),
    ItemInfo("Slime Covered Rubicite Coif", "RNG ROG SHM", "ALL", "Slot: HEAD, AC: 16, HP: 65, AGI: +6, SV FIRE: +4, SV COLD: +4"),
    ItemInfo("Silver Shiverback Hide Sash", "MNK BST", "ALL", "Slot: WAIST, AC: 5, HP: 35, MANA: 30, END: 30, SV POISON: +5, Haste: 31%"),
    ItemInfo("Rotting Gorilla Hide Helmet", "DRU MNK BST", "ALL", "Slot: HEAD, AC: 9, HP: 35, STA: +4, AGI: +3, WIS: +3"),
    ItemInfo("Bloodstained Journal, Vol 1", "ALL", "ALL", ""),
    ItemInfo("Mantle of Paralyzing Fright", "WAR CLR PAL RNG SHD BRD ROG SHM", "ALL", "Slot: SHOULDERS, AC: 32, END: 35, AGI: +6, SV FIRE: +7, SV COLD: +7, SV MAGIC: +7, SV DISEASE: +7, SV POISON: +7"),
    ItemInfo("Bladed Thulian Eviscerator", "WAR PAL RNG SHD BRD ROG", "ALL", "Slot: PRIMARY, 13/18 (0.72), HP: 100, STR: +15, SV POISON: +25"),
    ItemInfo("Heavy Rubicite Breastplate", "WAR", "ALL", "Slot: CHEST, AC: 46, HP: 85, STR: +6, STA: +6, DEX: +4, SV FIRE: +2, SV COLD: +2, SV MAGIC: +2"),
    ItemInfo("Ooze Covered Rubicite Mask", "PAL RNG SHD BRD BST", "ALL", "Slot: FACE, AC: 8, HP: 35, MANA: 30, STA: +5, WIS: +5, INT: +5"),
    ItemInfo("Bone Shield of Cazic-Thule", "WAR CLR PAL RNG SHD DRU SHM", "ALL", "Slot: SECONDARY, AC: 25"),
    ItemInfo("Prelate's Rubicite Bracer", "CLR", "ALL", "Slot: WRIST, AC: 17, HP: 55, MANA: 30, STR: +4, WIS: +4, SV FIRE: +4, SV POISON: +2"),
    ItemInfo("Barbed Rubicite Pauldrons", "WAR CLR PAL RNG SHD MNK BRD ROG SHM BST", "ALL", "Slot: SHOULDERS, AC: 15, HP: 55, MANA: 55, END: 55, STR: +5, STA: +15, AGI: +10, DEX: +15, WIS: -10, INT: -10, SV FIRE: +10, SV COLD: -10, SV MAGIC: +10, SV DISEASE: -10, SV POISON: +10"),
    ItemInfo("Thulian Crusaders Earring", "PAL SHD", "ALL", "Slot: EAR, AC: 10, HP: 50, MANA: 35, WIS: +7, INT: +7, SV FIRE: +6"),
    ItemInfo("Tae Ew Spiritcallers Coif", "SHM", "ALL", "Slot: HEAD, AC: 15, HP: 45, MANA: 40, STR: +4, DEX: +4, WIS: +7, SV POISON: +5"),
    ItemInfo("Imbued Froglokhide Shield", "PAL SHD", "ALL", "Slot: SECONDARY, AC: 25, HP: 30, MANA: 30, STA: +3, WIS: +4, INT: +4"),
    ItemInfo("Striped Raptor Hide Boots", "MNK BST", "ALL", "Slot: FEET, AC: 10, HP: 45, MANA: 20, END: 20, STA: +4, SV FIRE: +3, SV COLD: +3, SV MAGIC: +4"),
    ItemInfo("Stonebladed Axe of Dismay", "WAR", "ALL", "Slot: PRIMARY, 44/44 (1.00), HP: 75"),
    ItemInfo("Tae Ew Bloodletters Sword", "WAR RNG BRD ROG", "ALL", "Slot: PRIMARY/SECONDARY, 10/20 (0.50), HP: 65, STR: +3, WIS: +3, INT: +3, SV DISEASE: +3"),
    ItemInfo("Terror Forged Short Sword", "WAR RNG BRD ROG", "ALL", "Slot: PRIMARY/SECONDARY, 15/20 (0.75), AC: 12, AGI: +5, DEX: +5, SV FIRE: +10, SV MAGIC: +10"),
    ItemInfo("Fright Imbued Battlestaff", "NEC WIZ MAG ENC", "ALL", "Slot: PRIMARY, 19/22 (0.86), AC: 15, HP: 75, MANA: 100, INT: +10, CHA: +10, SV FIRE: +10, SV COLD: +10, SV MAGIC: +10, SV DISEASE: +10, SV POISON: +10"),
    ItemInfo("Trinket of Ancient Fears", "ALL", "ALL", "Slot: NECK/RANGE/SECONDARY, AC: 10, HP: 50, STA: +15, AGI: +10, WIS: +15, CHA: +10, SV MAGIC: +15"),
    ItemInfo("Ornate Rubicite Greaves", "PAL SHD", "ALL", "Slot: LEGS, AC: 33, HP: 50, MANA: 15, STA: +3, WIS: +3, INT: +3, SV FIRE: +3, SV COLD: +3"),
    ItemInfo("Prelate's Rubicite Helm", "CLR", "ALL", "Slot: HEAD, AC: 20, MANA: 35, STA: +3, WIS: +3"),
    ItemInfo("Piranha Scale Fistwraps", "MNK BST", "ALL", "Slot: HANDS, AC: 12, HP: 45, MANA: 20, END: 20, STR: +2, STA: +4, AGI: +4, DEX: +4"),
    ItemInfo("Piranha Scale Wristwrap", "WIZ MAG", "ALL", "Slot: WRIST, AC: 5, MANA: 65, SV FIRE: +8, SV MAGIC: +8"),
    ItemInfo("Spiked Ringmail Sleeves", "WAR PAL RNG SHD BRD ROG", "ALL", "Slot: ARMS, AC: 21, STR: +10, STA: +13, SV FIRE: +2, SV COLD: +2, SV MAGIC: +2, SV DISEASE: +2, SV POISON: +2"),
    ItemInfo("Ring of Dreadful Dreams", "ALL", "ALL", "Slot: FINGER, AC: 12, HP: 50, MANA: 50, END: 50, STA: +10, DEX: +5, Haste: 33%"),
    ItemInfo("Feartouched Greatsword", "WAR PAL RNG SHD", "ALL", "Slot: PRIMARY, 46/40 (1.15), AC: 5, END: 100, STR: +10, STA: +10, AGI: +20, INT: +10"),
    ItemInfo("Barbed Rubicite Bracer", "RNG ROG SHM", "ALL", "Slot: WRIST, AC: 13, HP: 35, WIS: +5, INT: +5"),
    ItemInfo("Tae Ew Ritualists Mask", "RNG DRU SHM WIZ MAG ENC", "ALL", "Slot: FACE, AC: 6, HP: 40, MANA: 45, WIS: +7, INT: +7, CHA: +7"),
    ItemInfo("Boots of Flowing Slime", "ALL except WAR MNK ROG", "ALL", "Slot: FEET, AC: 7, HP: 20, MANA: 65, SV MAGIC: +10"),
    ItemInfo("Amygdalan's Chain Mask", "WAR PAL RNG SHD BRD ROG", "ALL", "Slot: FACE, AC: 8, HP: 85, STA: +5, AGI: +5, DEX: +5, WIS: +5"),
    ItemInfo("Spear of the Despoiler", "SHM", "ALL", "Slot: PRIMARY, 15/22 (0.68), HP: 35, MANA: 40"),
    ItemInfo("Boots of Hidden Terror", "NEC WIZ MAG ENC", "ALL", "Slot: FEET, AC: 15, MANA: 90, AGI: +7, INT: +9, SV FIRE: +8, SV COLD: +8"),
    ItemInfo("Heavy Rubicite Girdle", "WAR", "ALL", "Slot: WAIST, AC: 25, HP: 85, STR: +4, STA: +4, CHA: +2, SV FIRE: +4, SV COLD: +4"),
    ItemInfo("Frightforged War Mask", "WAR CLR PAL SHD BRD", "ALL", "Slot: FACE, AC: 12, HP: 35, END: 25, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Jungle Spider Fur Cap", "WIZ", "ALL", "Slot: HEAD, AC: 8, MANA: 65, STR: +6, INT: +6, SV MAGIC: +2"),
    ItemInfo("Ring of Flowing Slime", "PAL RNG SHD BRD BST", "ALL", "Slot: FINGER, AC: 8, HP: 55, MANA: 35, STR: +15, STA: +10"),
    ItemInfo("Barbed Rubicite Belt", "RNG ROG SHM", "ALL", "Slot: WAIST, AC: 12, HP: 40, MANA: 25, END: 25, STA: +3, AGI: +3, DEX: +3, WIS: +3, INT: +3"),
    ItemInfo("Lizard Tooth Earring", "ALL", "ALL", "Slot: EAR, AC: 5, HP: 75, STR: +6, STA: +8, AGI: +6, SV FIRE: +5, SV COLD: +5, SV MAGIC: +5"),
    ItemInfo("Tae Ew Tribal Shield", "WAR CLR PAL RNG SHD DRU SHM", "ALL", "Slot: SECONDARY, AC: 25"),
    ItemInfo("Bowl of Vicious Ooze", "CLR PAL RNG DRU SHM NEC WIZ MAG ENC BST", "ALL", "Slot: PRIMARY/SECONDARY, HP: 35, MANA: 40, STR: +9, STA: +9, WIS: +9, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Mosquito Leg Earring", "WAR PAL RNG SHD MNK BRD ROG BST", "ALL", "Slot: EAR, AC: 8, HP: 65, STA: +7, SV DISEASE: +7"),
    ItemInfo("Poison Silk Necklace", "SHD NEC", "ALL", "Slot: NECK, AC: 5, MANA: 65, DEX: +7, INT: +7, SV COLD: +8, SV MAGIC: +5, SV DISEASE: +8"),
    ItemInfo("Slime Crusted Shoes", "CLR DRU SHM NEC WIZ MAG ENC", "ALL", "Slot: FEET, AC: 15, HP: 40, MANA: 70, STA: +5, AGI: +3, DEX: +3, WIS: +12, INT: +12, SV MAGIC: +5"),
    ItemInfo("Lizard Bone Earring", "ALL", "ALL", "Slot: EAR, AC: 2, HP: 70, MANA: 35, END: 35, STA: +10, AGI: +6, DEX: +6, CHA: +5, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Frightchaser's Hide", "CLR DRU MNK SHM BST", "ALL", "Slot: CHEST, AC: 20, HP: 45, MANA: 40, END: 40, STR: +5, STA: +5, DEX: +5, WIS: +5, SV DISEASE: +5"),
    ItemInfo("Piranha Scale Sash", "DRU MNK BST", "ALL", "Slot: WAIST, AC: 8, MANA: 35, END: 35, CHA: +10"),
    ItemInfo("Spiderfang Earring", "WAR MNK ROG", "ALL", "Slot: EAR, AC: 7, HP: 35, END: 20, AGI: +7, DEX: +7"),
    ItemInfo("Raptor Hide Shield", "PAL RNG SHD BST", "ALL", "Slot: SECONDARY, AC: 25, HP: 25, MANA: 40, WIS: +5, INT: +5, SV MAGIC: +5, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Shield of Striding", "CLR DRU SHM", "ALL", "Slot: SECONDARY, AC: 35, HP: 30, MANA: 55, STA: +5, AGI: +3, WIS: +5, SV FIRE: +3, SV COLD: +3, SV MAGIC: +3"),
    ItemInfo("Envenomed Necklace", "RNG DRU", "ALL", "Slot: NECK, AC: 6, HP: 35, MANA: 30, STR: +7, WIS: +7, SV FIRE: +8, SV MAGIC: +5, SV POISON: +8"),
    ItemInfo("Terror Woven Wraps", "NEC WIZ MAG ENC", "ALL", "Slot: ARMS/LEGS, AC: 14, MANA: 80, STA: +10, INT: +15, SV FIRE: +8, SV COLD: +8"),
    ItemInfo("Talisman of Fright", "ALL", "ALL", "Slot: NECK, AC: 22, SV MAGIC: +15, SV DISEASE: +15, SV POISON: +15"),
    ItemInfo("Terrorclaw's Hide", "NEC", "ALL", "Slot: SHOULDERS, AC: 9, HP: 55, MANA: 30, STA: +7, INT: +7, SV DISEASE: +3"),
    ItemInfo("Tae Ew Blood Vial", "ALL", "ALL", ""),
    ItemInfo("Small Stone Totem", "ALL", "ALL", ""),
    ItemInfo("Mosquito Leg Wand", "NEC WIZ MAG ENC", "ALL", "Slot: PRIMARY, HP: 30, MANA: 35, AGI: +12, DEX: +12, SV FIRE: +4, SV COLD: +4, SV MAGIC: +4"),
    ItemInfo("Lizard Skin Sash", "NEC WIZ MAG ENC", "ALL", "Slot: WAIST, AC: 2, HP: 10, MANA: 25, AGI: +5, DEX: +5"),
    ItemInfo("Silverflank Belt", "NEC MAG BST", "ALL", "Slot: WAIST, HP: 40, MANA: 25, AGI: +5, DEX: +5, INT: +5"),
    ItemInfo("Frightful Shroud", "NEC WIZ MAG ENC", "ALL", "Slot: CHEST, AC: 25, MANA: 50, AGI: +10, INT: +10, CHA: +10, SV FIRE: +15, SV COLD: +15, SV MAGIC: +15, SV DISEASE: +15, SV POISON: +15"),
    ItemInfo("Fearsome Girdle", "ALL", "ALL", "Slot: WAIST, AC: 20, STA: +8, AGI: +8, DEX: +8, SV FIRE: +7, SV COLD: +7, SV MAGIC: +7, SV DISEASE: +7, SV POISON: +7, Haste: 41%"),
    ItemInfo("Tae Ew War Helm", "WAR CLR PAL SHD BRD", "ALL", "Slot: HEAD, AC: 24, HP: 25, MANA: 40, END: 40, AGI: +4, DEX: +4, SV FIRE: +3, SV DISEASE: +3"),
    ItemInfo("Dreadfangs Hide", "NEC WIZ MAG ENC", "ALL", "Slot: LEGS, AC: 12, HP: 40, MANA: 45, AGI: +3, WIS: +3, INT: +3, CHA: +3, SV FIRE: +2, SV COLD: +2, SV MAGIC: +4"),
    ItemInfo("Silverfang Club", "WAR RNG MNK BRD ROG BST", "ALL", "Slot: PRIMARY/SECONDARY, 10/17 (0.59), HP: 75"),
    ItemInfo("Toxiferious Axe", "RNG", "ALL", "Slot: PRIMARY/SECONDARY, 10/17 (0.59), HP: 35, MANA: 40, STA: +5, WIS: +5"),
    ItemInfo("Earring of Pain", "ALL", "ALL", "Slot: EAR, AC: 6, HP: 35, END: 20, STA: +10, WIS: +5, INT: +5, SV MAGIC: +5, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Dreadfang Mask", "ALL", "ALL", "Slot: FACE, AC: 6, HP: 50, MANA: 50, END: 50, CHA: +4, SV FIRE: +3, SV COLD: +3, SV MAGIC: +3, SV DISEASE: +5, SV POISON: +5"),
    ItemInfo("Radiant Gloves", "ENC", "HUM ERU HIE DEF GNM DRA", "Slot: HANDS, AC: 4"),
    ItemInfo("Pearl of Dread", "ALL", "ALL", "Slot: RANGE, AC: 26, HP: 50, MANA: 20, END: 20, STR: +10, STA: +10, SV FIRE: +8, SV COLD: +8, SV MAGIC: +8, SV DISEASE: +8, SV POISON: +8"),
    ItemInfo("Oozing Bracer", "RNG ROG", "ALL", "Slot: WRIST, AC: 13, HP: 30, MANA: 35, END: 35, STA: +5, DEX: +5, WIS: +5"),
    ItemInfo("Sanguine Wand", "NEC WIZ MAG ENC", "ALL", "Slot: PRIMARY, HP: 35, MANA: 40, AGI: +9, DEX: +9, INT: +9, CHA: +9"),
    ItemInfo("Sanguine Tome", "NEC WIZ MAG ENC", "ALL", "Slot: RANGE/PRIMARY/SECONDARY, HP: 30, MANA: 35, WIS: +8, INT: +8"),
    ItemInfo("Dread Coronet", "ALL", "ALL", "Slot: HEAD, AC: 23, HP: 70, MANA: 70, END: 70, WIS: +10, INT: +10, SV COLD: +25"),
    ItemInfo("Scalecracker", "WAR PAL SHD", "ALL", "Slot: RANGE/PRIMARY, 48/43 (1.12), AC: 33, HP: 100, END: 25, STA: +15, WIS: +10, Haste: 41%"),
    ItemInfo("Fetid Orb", "ALL", "ALL", "Slot: PRIMARY/SECONDARY, SV FIRE: +3, SV COLD: +3, SV MAGIC: +3, SV DISEASE: +3, SV POISON: +3"),
  ]
}

pub fn tooltip(name: String) -> Option(String) {
  case lookup(name) {
    None -> None
    Some(item) -> Some(line(item))
  }
}

/// Stats for every known item named in a cell (Loot / Item columns).
pub fn tooltip_for_cell(value: String) -> Option(String) {
  let hits = mentions(normalize(value), items(), [])
  case hits {
    [] -> None
    _ -> Some(string.join(list.reverse(hits), "\n"))
  }
}

pub fn with_item_tooltips(formatter: TableFormatter) -> TableFormatter {
  table_format.decorate(formatter, fn(ctx, cell) {
    case should_tooltip(ctx.header) {
      False -> cell
      True ->
        case tooltip_for_cell(ctx.value) {
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

fn should_tooltip(header: String) -> Bool {
  case string.lowercase(string.trim(header)) {
    "item" | "loot" -> True
    _ -> False
  }
}

fn lookup(name: String) -> Option(ItemInfo) {
  let key = normalize(name)
  list.find(items(), fn(item) { item.name == key })
  |> option.from_result
}

fn mentions(
  text: String,
  items: List(ItemInfo),
  acc: List(String),
) -> List(String) {
  case items {
    [] -> acc
    [item, ..rest] ->
      case string.contains(text, item.name) {
        True ->
          mentions(
            string.replace(text, item.name, " "),
            rest,
            [line(item), ..acc],
          )
        False -> mentions(text, rest, acc)
      }
  }
}

fn line(item: ItemInfo) -> String {
  let who = case item.classes, item.races {
    "ALL", "ALL" -> "all classes, all races"
    classes, "ALL" -> classes <> " — all races"
    "ALL", races -> "all classes — " <> races
    classes, races -> classes <> " — " <> races
  }
  case item.stats {
    "" -> item.name <> " — " <> who
    stats -> item.name <> " — " <> who <> " — " <> stats
  }
}

fn normalize(value: String) -> String {
  value
  |> string.trim
  |> string.replace("**", "")
  |> string.replace("__", "")
  |> string.trim
}

fn append_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}
