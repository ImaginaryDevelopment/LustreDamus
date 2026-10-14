//// Classic–Velious raid targets: localStorage beaten flags + loot status.

import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/string
import table_sort.{
  type TableSort, Asc, EmptiesLast, SortNumeric, SortSpec, SortText,
  TextAfterNumbers, TableSort,
}

pub const storage_key: String = "lustredamus.raid-targets.beaten.v1"

pub const status_storage_key: String = "lustredamus.raid-targets.status.v1"

pub const kill_mode_storage_key: String = "lustredamus.raid-targets.kill-mode.v1"

pub type Status {
  Unknown
  Blah
  Broken
  NeedForEpic
  NeedTheLoot
}

/// How the target was cleared — group (no raid) vs formed raid.
pub type KillMode {
  KillUnknown
  Group
  Raid
}

/// Markdown table title (`## Targets`) used for default sort wiring.
pub const table_title: String = "Targets"

pub type Target {
  Target(
    id: String,
    name: String,
    zone: String,
    expansion: String,
    /// Approximate HP from zone sheets / IdleQuest when known.
    hp: Option(Int),
    note: String,
  )
}

/// Stable ids used for localStorage — keep in sync with Raid-Targets.md.
pub fn targets() -> List(Target) {
  list.flatten([
    classic(),
    kunark(),
    temple_of_veeshan(),
    velious(),
  ])
  |> list.sort(compare_expansion_then_hp)
}

fn classic() -> List(Target) {
  [
    // HP from idlequest-content npc_types (classic zone rows; not Fabled).
    t("lord-nagafen", "Lord Nagafen", "Nagafen's Lair", "Classic", Some(32_000), "Fire giant dragon"),
    t("lady-vox", "Lady Vox", "Permafrost", "Classic", Some(32_000), "Ice dragon"),
    t("innoruuk", "Innoruuk", "Plane of Hate", "Classic", Some(32_000), "God"),
    t("cazic-thule", "Cazic-Thule", "Plane of Fear", "Classic", Some(450_000), "God"),
  ]
}

fn kunark() -> List(Target) {
  [
    t("construct-of-sathir", "Construct of Sathir", "Karnor's Castle", "Kunark", Some(10_750), "2-group"),
    t("drusella-sathir", "Drusella Sathir", "Howling Stones", "Kunark", Some(15_750), "2-group east boss"),
    t("venril-sathir", "Venril Sathir", "Karnor's Castle", "Kunark", Some(18_325), "Live VS"),
    t(
      "venril-sathir-triggered",
      "Venril Sathir (Triggered)",
      "Karnor's Castle",
      "Kunark",
      Some(18_325),
      "2-group; Pulsing Green Stones",
    ),
    t("korocust", "Korocust", "Chardok", "Kunark", Some(22_125), "2-group bridge"),
    t("prince-selrach", "Prince Selrach Di`zok", "Chardok", "Kunark", Some(25_000), "Royals"),
    t("trunt", "Trunt", "Mines of Nurga", "Kunark", Some(29_000), "2-group triggered"),
    t("queen-velazul", "Queen Velazul Di`zok", "Chardok", "Kunark", Some(30_000), "Royals"),
    t("overking-bathezid", "Overking Bathezid", "Chardok", "Kunark", Some(32_000), "Royals"),
    t("trakanon", "Trakanon", "Old Sebilis", "Kunark", Some(32_000), "Dragon lair"),
    t("faydedar", "Faydedar", "Timorous Deep", "Kunark", Some(32_000), "Water dragon"),
    t("gorenaire", "Gorenaire", "Dreadlands", "Kunark", Some(32_000), "Outdoor dragon"),
    t("severilous", "Severilous", "Emerald Jungle", "Kunark", Some(32_000), "Outdoor dragon"),
    t("talendor", "Talendor", "Skyfire Mountains", "Kunark", Some(32_000), "Outdoor dragon"),
    t("hoshkar", "Hoshkar", "Veeshan's Peak", "Kunark", Some(32_000), "VP crawl"),
    t("silverwing", "Silverwing", "Veeshan's Peak", "Kunark", Some(454_000), "VP crawl"),
    t("druushk", "Druushk", "Veeshan's Peak", "Kunark", Some(470_000), "VP crawl"),
    t("phara-dar", "Phara Dar", "Veeshan's Peak", "Kunark", Some(681_000), "VP top"),
    t("nexona", "Nexona", "Veeshan's Peak", "Kunark", Some(800_000), "VP crawl"),
    t("xygoz", "Xygoz", "Veeshan's Peak", "Kunark", Some(814_000), "VP crawl"),
  ]
}

fn temple_of_veeshan() -> List(Target) {
  let exp = "Temple of Veeshan"
  let zone = "Temple of Veeshan"
  [
    // HP from IdleQuest npc_types (templeveeshan spawn rows).
    t("sevalak", "Sevalak", zone, exp, Some(101_500), "Great Spear of Dawn / Shield of Midnight"),
    t("zlexak", "Zlexak", zone, exp, Some(121_500), "Dragonspine Rapier / Windraider's Belt"),
    t("eashen", "Eashen of the Sky", zone, exp, Some(240_000), "Sky ring / bracelet / cloak"),
    t("ikatiar", "Ikatiar the Venom", zone, exp, Some(250_000), "Ancient Wyvern Hide / Stinger"),
    t("jorlleag", "Jorlleag", zone, exp, Some(250_000), "Sprinkler of the Spirits / Facesmasher"),
    t("gozzrem", "Gozzrem", zone, exp, Some(280_000), "Wand of the Black Dragon Eye"),
    t("telkorenar", "Telkorenar", zone, exp, Some(280_000), "True Mithril Breastplate / Lance of Thunder"),
    t("dagarn", "Dagarn the Destroyer", zone, exp, Some(300_000), "Live spawn; Destroyer set / haste belt"),
    t("lendiniara", "Lendiniara the Keeper", zone, exp, Some(320_000), "Talisman / Superiority set"),
    t("lord-vyemm", "Lord Vyemm", zone, exp, Some(350_000), "Gaudralek / Vyemm's Eyes / Fang"),
    t("lady-mirenilla", "Lady Mirenilla", zone, exp, Some(380_000), "Mithril helm/gaunts/boots / Frostwrath"),
    t("dozekar", "Dozekar the Cursed", zone, exp, Some(386_500), "West; Tear set"),
    t("aaryonar", "Aaryonar", zone, exp, Some(390_000), "Amulet of the Dreadgazer / Hand of the Master"),
    t("cekenar", "Cekenar", zone, exp, Some(425_000), "Cekenar's Claw / Blackstar"),
    t("lord-feshlak", "Lord Feshlak", zone, exp, Some(455_000), "Amulet of the Storm / Chestplate of Fiery Might"),
    t("lord-kreizenn", "Lord Kreizenn", zone, exp, Some(465_000), "Dawncaller / Flame Etched Short Sword"),
    t("lady-nevederia", "Lady Nevederia", zone, exp, Some(525_000), "Nevederia's Eyes / Girdle of Dark Power"),
    t("lord-koi-doken", "Lord Koi`Doken", zone, exp, Some(580_000), "Deep Sea set / Siren Song"),
  ]
}

fn velious() -> List(Target) {
  [
    t("vaniki", "Vaniki", "Dragon Necropolis", "Velious", Some(45_000), "Chetari raid named"),
    t("zlandicar", "Zlandicar", "Dragon Necropolis", "Velious", Some(110_000), "Necropolis dragon"),
    t(
      "doljon",
      "Lord Doljonijiarnimorinar",
      "Velketor's Labyrinth",
      "Velious",
      Some(147_000),
      "Efreeti",
    ),
    t("derakor", "Derakor the Vindicator", "Kael Drakkel", "Velious", Some(180_000), "Near throne"),
    t("tukaarak", "Tukaarak the Warder", "Sleeper's Tomb", "Velious", Some(200_000), "Ice warder"),
    t("nanzata", "Nanzata the Warder", "Sleeper's Tomb", "Velious", Some(200_000), "Fire warder"),
    t("ventani", "Ventani the Warder", "Sleeper's Tomb", "Velious", Some(200_000), "Disease warder"),
    t("hraashna", "Hraashna the Warder", "Sleeper's Tomb", "Velious", Some(200_000), "Magic warder"),
    t("velketor", "Velketor the Sorcerer", "Velketor's Labyrinth", "Velious", Some(201_500), "Tower boss"),
    t("guardian-of-tunare", "Guardian of Tunare", "Plane of Growth", "Velious", Some(310_000), "With Tunare"),
    t("master-of-the-guard", "Master of the Guard", "Sleeper's Tomb", "Velious", Some(326_000), "ST (~100k–326k)"),
    t("progenitor", "The Progenitor", "Sleeper's Tomb", "Velious", Some(327_000), "ST (~150k–327k)"),
    t("dain-frostreaver", "Dain Frostreaver IV", "Icewell Keep", "Velious", Some(352_000), "Coldain king"),
    t("kildrukaun", "Kildrukaun the Ancient", "Sleeper's Tomb", "Velious", Some(352_000), "Black ancient"),
    t("vyskudra", "Vyskudra the Ancient", "Sleeper's Tomb", "Velious", Some(352_000), "Storm ancient"),
    t("tjudawos", "Tjudawos the Ancient", "Sleeper's Tomb", "Velious", Some(352_000), "Gold ancient"),
    t("final-arbiter", "The Final Arbiter", "Sleeper's Tomb", "Velious", Some(357_000), "ST (~200k–357k)"),
    t("zeixshi-kar", "Zeixshi-Kar the Ancient", "Sleeper's Tomb", "Velious", Some(377_000), "Silver ancient"),
    t("king-tormax", "King Tormax", "Kael Drakkel", "Velious", Some(452_000), "Kromzek king"),
    t("lord-yelinak", "Lord Yelinak", "Skyshrine", "Velious", Some(500_000), "Dragon king"),
    t("tunare", "Tunare", "Plane of Growth", "Velious", Some(530_000), "Goddess"),
    t("all-seeing-eye", "All-Seeing Eye", "Plane of Mischief", "Velious", Some(709_000), "Huge HP fluff"),
    t("the-sleeper", "The Sleeper (Kerafyrm)", "Sleeper's Tomb", "Velious", Some(3_500_000), "Wake event"),
  ]
}

fn t(
  id: String,
  name: String,
  zone: String,
  expansion: String,
  hp: Option(Int),
  note: String,
) -> Target {
  Target(id:, name:, zone:, expansion:, hp:, note:)
}

pub fn by_expansion() -> List(#(String, List(Target))) {
  [
    #("Classic", sorted_group(classic())),
    #("Kunark", sorted_group(kunark())),
    #("Temple of Veeshan", sorted_group(temple_of_veeshan())),
    #("Velious", sorted_group(velious())),
  ]
}

fn sorted_group(group: List(Target)) -> List(Target) {
  list.sort(group, compare_hp_then_name)
}

fn compare_expansion_then_hp(a: Target, b: Target) -> order.Order {
  case string.compare(a.expansion, b.expansion) {
    order.Eq -> compare_hp_then_name(a, b)
    other -> other
  }
}

fn compare_hp_then_name(a: Target, b: Target) -> order.Order {
  case a.hp, b.hp {
    Some(l), Some(r) ->
      case int.compare(l, r) {
        order.Eq -> string.compare(a.name, b.name)
        other -> other
      }
    None, Some(_) -> order.Gt
    Some(_), None -> order.Lt
    None, None -> string.compare(a.name, b.name)
  }
}

pub fn hp_label(hp: Option(Int)) -> String {
  case hp {
    None -> "—"
    Some(3_500_000) -> "~3.5M"
    Some(n) if n >= 1_000_000 && n % 1_000_000 == 0 ->
      "~" <> int.to_string(n / 1_000_000) <> "M"
    Some(n) if n >= 1000 -> "~" <> int.to_string(n / 1000) <> "k"
    Some(n) -> int.to_string(n)
  }
}

/// Default table sort: Expansion (text), then HP (numeric).
pub fn default_sorts() -> Dict(String, TableSort) {
  dict.from_list([
    #(
      table_title,
      TableSort(
        primary: SortSpec(
          column: 0,
          kind: SortText,
          direction: Asc,
          empties: EmptiesLast,
          texts: TextAfterNumbers,
        ),
        secondary: Some(SortSpec(
          column: 3,
          kind: SortNumeric,
          direction: Asc,
          empties: EmptiesLast,
          texts: TextAfterNumbers,
        )),
      ),
    ),
  ])
}

pub fn has_beaten(beaten: Dict(String, Bool), id: String) -> Bool {
  case dict.get(beaten, id) {
    Ok(True) -> True
    _ -> False
  }
}

pub fn toggle(beaten: Dict(String, Bool), id: String, on: Bool) -> Dict(String, Bool) {
  case on {
    True -> dict.insert(beaten, id, True)
    False -> dict.delete(beaten, id)
  }
}

pub fn encode(beaten: Dict(String, Bool)) -> String {
  targets()
  |> list.filter(fn(t) { has_beaten(beaten, t.id) })
  |> list.map(fn(t) { t.id })
  |> string.join(",")
}

pub fn decode(raw: String) -> Dict(String, Bool) {
  let known =
    targets()
    |> list.map(fn(t) { t.id })
  raw
  |> string.split(",")
  |> list.map(string.trim)
  |> list.filter(fn(s) { s != "" && list.contains(known, s) })
  |> list.fold(dict.new(), fn(acc, id) { dict.insert(acc, id, True) })
}

pub fn beaten_count(beaten: Dict(String, Bool)) -> Int {
  targets()
  |> list.filter(fn(t) { has_beaten(beaten, t.id) })
  |> list.length
}

pub fn statuses() -> List(Status) {
  [Unknown, Blah, Broken, NeedForEpic, NeedTheLoot]
}

pub fn status_id(status: Status) -> String {
  case status {
    Unknown -> "unknown"
    Blah -> "blah"
    Broken -> "broken"
    NeedForEpic -> "needForEpic"
    NeedTheLoot -> "needTheLoot"
  }
}

pub fn status_label(status: Status) -> String {
  status_id(status)
}

/// Hover / option title text.
pub fn status_tooltip(status: Status) -> String {
  case status {
    Unknown -> "Not decided yet"
    Blah -> "Loot is bad or already owned"
    Broken -> "Spawn, script, or fight is broken"
    NeedForEpic -> "Need a drop for an epic"
    NeedTheLoot -> "Need the loot"
  }
}

pub fn parse_status(raw: String) -> Result(Status, Nil) {
  case string.trim(raw) {
    "unknown" -> Ok(Unknown)
    "blah" -> Ok(Blah)
    "broken" -> Ok(Broken)
    "needForEpic" -> Ok(NeedForEpic)
    "needTheLoot" -> Ok(NeedTheLoot)
    _ -> Error(Nil)
  }
}

pub fn get_status(statuses: Dict(String, Status), id: String) -> Status {
  case dict.get(statuses, id) {
    Ok(status) -> status
    Error(_) -> Unknown
  }
}

pub fn set_status(
  statuses: Dict(String, Status),
  id: String,
  status: Status,
) -> Dict(String, Status) {
  case status {
    Unknown -> dict.delete(statuses, id)
    _ -> dict.insert(statuses, id, status)
  }
}

pub fn encode_status(statuses: Dict(String, Status)) -> String {
  targets()
  |> list.filter_map(fn(t) {
    case dict.get(statuses, t.id) {
      Ok(Unknown) | Error(_) -> Error(Nil)
      Ok(status) -> Ok(t.id <> ":" <> status_id(status))
    }
  })
  |> string.join(",")
}

pub fn decode_status(raw: String) -> Dict(String, Status) {
  let known =
    targets()
    |> list.map(fn(t) { t.id })
  raw
  |> string.split(",")
  |> list.map(string.trim)
  |> list.filter(fn(s) { s != "" })
  |> list.fold(dict.new(), fn(acc, entry) {
    case string.split_once(entry, ":") {
      Ok(#(id, status_raw)) -> {
        let id = string.trim(id)
        case list.contains(known, id), parse_status(status_raw) {
          True, Ok(status) -> set_status(acc, id, status)
          _, _ -> acc
        }
      }
      Error(_) -> acc
    }
  })
}

pub fn kill_modes() -> List(KillMode) {
  [KillUnknown, Group, Raid]
}

pub fn kill_mode_id(mode: KillMode) -> String {
  case mode {
    KillUnknown -> "unknown"
    Group -> "group"
    Raid -> "raid"
  }
}

pub fn kill_mode_label(mode: KillMode) -> String {
  kill_mode_id(mode)
}

pub fn kill_mode_tooltip(mode: KillMode) -> String {
  case mode {
    KillUnknown -> "Not decided yet"
    Group -> "Cleared without a formed raid (group / 2-group)"
    Raid -> "Cleared with a formed raid"
  }
}

pub fn parse_kill_mode(raw: String) -> Result(KillMode, Nil) {
  case string.trim(raw) {
    "unknown" -> Ok(KillUnknown)
    "group" -> Ok(Group)
    "raid" -> Ok(Raid)
    _ -> Error(Nil)
  }
}

pub fn get_kill_mode(modes: Dict(String, KillMode), id: String) -> KillMode {
  case dict.get(modes, id) {
    Ok(mode) -> mode
    Error(_) -> KillUnknown
  }
}

pub fn set_kill_mode(
  modes: Dict(String, KillMode),
  id: String,
  mode: KillMode,
) -> Dict(String, KillMode) {
  case mode {
    KillUnknown -> dict.delete(modes, id)
    _ -> dict.insert(modes, id, mode)
  }
}

pub fn encode_kill_mode(modes: Dict(String, KillMode)) -> String {
  targets()
  |> list.filter_map(fn(t) {
    case dict.get(modes, t.id) {
      Ok(KillUnknown) | Error(_) -> Error(Nil)
      Ok(mode) -> Ok(t.id <> ":" <> kill_mode_id(mode))
    }
  })
  |> string.join(",")
}

pub fn decode_kill_mode(raw: String) -> Dict(String, KillMode) {
  let known =
    targets()
    |> list.map(fn(t) { t.id })
  raw
  |> string.split(",")
  |> list.map(string.trim)
  |> list.filter(fn(s) { s != "" })
  |> list.fold(dict.new(), fn(acc, entry) {
    case string.split_once(entry, ":") {
      Ok(#(id, mode_raw)) -> {
        let id = string.trim(id)
        case list.contains(known, id), parse_kill_mode(mode_raw) {
          True, Ok(mode) -> set_kill_mode(acc, id, mode)
          _, _ -> acc
        }
      }
      Error(_) -> acc
    }
  })
}
