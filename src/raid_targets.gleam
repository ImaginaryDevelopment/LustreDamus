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
    /// Classic | Kunark | Velious
    expansion: String,
    /// Zone subsection when the zone has more than 2 raid targets (e.g. ToV, ST, VP).
    section: Option(String),
    /// Approximate HP from zone sheets / IdleQuest when known.
    hp: Option(Int),
    note: String,
  )
}

/// One block under an expansion heading — either ungrouped targets or a named zone section.
pub type SectionBlock {
  SectionBlock(title: Option(String), targets: List(Target))
}

/// Stable ids used for localStorage — keep in sync with Raid-Targets.md.
pub fn targets() -> List(Target) {
  list.flatten([classic(), kunark(), velious()])
  |> list.sort(compare_expansion_then_hp)
}

fn classic() -> List(Target) {
  [
    // HP from idlequest-content npc_types (classic zone rows; not Fabled).
    t("lord-nagafen", "Lord Nagafen", "Nagafen's Lair", "Classic", None, Some(32_000), "Fire giant dragon"),
    t("lady-vox", "Lady Vox", "Permafrost", "Classic", None, Some(32_000), "Ice dragon"),
    t("innoruuk", "Innoruuk", "Plane of Hate", "Classic", None, Some(32_000), "God"),
    t("cazic-thule", "Cazic-Thule", "Plane of Fear", "Classic", None, Some(450_000), "God"),
  ]
}

fn kunark() -> List(Target) {
  let karnor = Some("Karnor's Castle")
  let chardok = Some("Chardok")
  let vp = Some("Veeshan's Peak")
  [
    t("construct-of-sathir", "Construct of Sathir", "Karnor's Castle", "Kunark", karnor, Some(10_750), "2-group"),
    t("drusella-sathir", "Drusella Sathir", "Howling Stones", "Kunark", None, Some(15_750), "2-group east boss"),
    t("venril-sathir", "Venril Sathir", "Karnor's Castle", "Kunark", karnor, Some(18_325), "Live VS"),
    t(
      "venril-sathir-triggered",
      "Venril Sathir (Triggered)",
      "Karnor's Castle",
      "Kunark",
      karnor,
      Some(18_325),
      "2-group; Pulsing Green Stones",
    ),
    t("korocust", "Korocust", "Chardok", "Kunark", chardok, Some(22_125), "2-group bridge"),
    t("prince-selrach", "Prince Selrach Di`zok", "Chardok", "Kunark", chardok, Some(25_000), "Royals"),
    t("trunt", "Trunt", "Mines of Nurga", "Kunark", None, Some(29_000), "2-group triggered"),
    t("queen-velazul", "Queen Velazul Di`zok", "Chardok", "Kunark", chardok, Some(30_000), "Royals"),
    t("overking-bathezid", "Overking Bathezid", "Chardok", "Kunark", chardok, Some(32_000), "Royals"),
    t("trakanon", "Trakanon", "Old Sebilis", "Kunark", None, Some(32_000), "Dragon lair"),
    t("faydedar", "Faydedar", "Timorous Deep", "Kunark", None, Some(32_000), "Water dragon"),
    t("gorenaire", "Gorenaire", "Dreadlands", "Kunark", None, Some(32_000), "Outdoor dragon"),
    t("severilous", "Severilous", "Emerald Jungle", "Kunark", None, Some(32_000), "Outdoor dragon"),
    t("talendor", "Talendor", "Skyfire Mountains", "Kunark", None, Some(32_000), "Outdoor dragon"),
    t("hoshkar", "Hoshkar", "Veeshan's Peak", "Kunark", vp, Some(32_000), "VP crawl"),
    t("silverwing", "Silverwing", "Veeshan's Peak", "Kunark", vp, Some(454_000), "VP crawl"),
    t("druushk", "Druushk", "Veeshan's Peak", "Kunark", vp, Some(470_000), "VP crawl"),
    t("phara-dar", "Phara Dar", "Veeshan's Peak", "Kunark", vp, Some(681_000), "VP top"),
    t("nexona", "Nexona", "Veeshan's Peak", "Kunark", vp, Some(800_000), "VP crawl"),
    t("xygoz", "Xygoz", "Veeshan's Peak", "Kunark", vp, Some(814_000), "VP crawl"),
  ]
}

fn velious() -> List(Target) {
  list.flatten([
    velious_misc(),
    temple_of_veeshan(Some("Temple of Veeshan")),
    sleeper_tomb(Some("Sleeper's Tomb")),
  ])
}

fn velious_misc() -> List(Target) {
  [
    t("vaniki", "Vaniki", "Dragon Necropolis", "Velious", None, Some(45_000), "Chetari raid named"),
    t("zlandicar", "Zlandicar", "Dragon Necropolis", "Velious", None, Some(110_000), "Necropolis dragon"),
    t(
      "doljon",
      "Lord Doljonijiarnimorinar",
      "Velketor's Labyrinth",
      "Velious",
      None,
      Some(147_000),
      "Efreeti",
    ),
    t("derakor", "Derakor the Vindicator", "Kael Drakkel", "Velious", None, Some(180_000), "Near throne"),
    t("velketor", "Velketor the Sorcerer", "Velketor's Labyrinth", "Velious", None, Some(201_500), "Tower boss"),
    t("guardian-of-tunare", "Guardian of Tunare", "Plane of Growth", "Velious", None, Some(310_000), "With Tunare"),
    t("dain-frostreaver", "Dain Frostreaver IV", "Icewell Keep", "Velious", None, Some(352_000), "Coldain king"),
    t("king-tormax", "King Tormax", "Kael Drakkel", "Velious", None, Some(452_000), "Kromzek king"),
    t("lord-yelinak", "Lord Yelinak", "Skyshrine", "Velious", None, Some(500_000), "Dragon king"),
    t("tunare", "Tunare", "Plane of Growth", "Velious", None, Some(530_000), "Goddess"),
    t("all-seeing-eye", "All-Seeing Eye", "Plane of Mischief", "Velious", None, Some(709_000), "Huge HP fluff"),
  ]
}

fn sleeper_tomb(section: Option(String)) -> List(Target) {
  let zone = "Sleeper's Tomb"
  let exp = "Velious"
  [
    t("tukaarak", "Tukaarak the Warder", zone, exp, section, Some(200_000), "Ice warder"),
    t("nanzata", "Nanzata the Warder", zone, exp, section, Some(200_000), "Fire warder"),
    t("ventani", "Ventani the Warder", zone, exp, section, Some(200_000), "Disease warder"),
    t("hraashna", "Hraashna the Warder", zone, exp, section, Some(200_000), "Magic warder"),
    t("master-of-the-guard", "Master of the Guard", zone, exp, section, Some(326_000), "ST (~100k–326k)"),
    t("progenitor", "The Progenitor", zone, exp, section, Some(327_000), "ST (~150k–327k)"),
    t("kildrukaun", "Kildrukaun the Ancient", zone, exp, section, Some(352_000), "Black ancient"),
    t("vyskudra", "Vyskudra the Ancient", zone, exp, section, Some(352_000), "Storm ancient"),
    t("tjudawos", "Tjudawos the Ancient", zone, exp, section, Some(352_000), "Gold ancient"),
    t("final-arbiter", "The Final Arbiter", zone, exp, section, Some(357_000), "ST (~200k–357k)"),
    t("zeixshi-kar", "Zeixshi-Kar the Ancient", zone, exp, section, Some(377_000), "Silver ancient"),
    t("the-sleeper", "The Sleeper (Kerafyrm)", zone, exp, section, Some(3_500_000), "Wake event"),
  ]
}

fn temple_of_veeshan(section: Option(String)) -> List(Target) {
  let zone = "Temple of Veeshan"
  let exp = "Velious"
  [
    // HP from IdleQuest npc_types (templeveeshan spawn rows).
    t("sevalak", "Sevalak", zone, exp, section, Some(101_500), "Great Spear of Dawn / Shield of Midnight"),
    t("zlexak", "Zlexak", zone, exp, section, Some(121_500), "Dragonspine Rapier / Windraider's Belt"),
    t("eashen", "Eashen of the Sky", zone, exp, section, Some(240_000), "Sky ring / bracelet / cloak"),
    t("ikatiar", "Ikatiar the Venom", zone, exp, section, Some(250_000), "Ancient Wyvern Hide / Stinger"),
    t("jorlleag", "Jorlleag", zone, exp, section, Some(250_000), "Sprinkler of the Spirits / Facesmasher"),
    t("gozzrem", "Gozzrem", zone, exp, section, Some(280_000), "Wand of the Black Dragon Eye"),
    t("telkorenar", "Telkorenar", zone, exp, section, Some(280_000), "True Mithril Breastplate / Lance of Thunder"),
    t("dagarn", "Dagarn the Destroyer", zone, exp, section, Some(300_000), "Live spawn; Destroyer set / haste belt"),
    t("lendiniara", "Lendiniara the Keeper", zone, exp, section, Some(320_000), "Talisman / Superiority set"),
    t("lord-vyemm", "Lord Vyemm", zone, exp, section, Some(350_000), "Gaudralek / Vyemm's Eyes / Fang"),
    t("lady-mirenilla", "Lady Mirenilla", zone, exp, section, Some(380_000), "Mithril helm/gaunts/boots / Frostwrath"),
    t("dozekar", "Dozekar the Cursed", zone, exp, section, Some(386_500), "West; Tear set"),
    t("aaryonar", "Aaryonar", zone, exp, section, Some(390_000), "Amulet of the Dreadgazer / Hand of the Master"),
    t("cekenar", "Cekenar", zone, exp, section, Some(425_000), "Cekenar's Claw / Blackstar"),
    t("lord-feshlak", "Lord Feshlak", zone, exp, section, Some(455_000), "Amulet of the Storm / Chestplate of Fiery Might"),
    t("lord-kreizenn", "Lord Kreizenn", zone, exp, section, Some(465_000), "Dawncaller / Flame Etched Short Sword"),
    t("lady-nevederia", "Lady Nevederia", zone, exp, section, Some(525_000), "Nevederia's Eyes / Girdle of Dark Power"),
    t("lord-koi-doken", "Lord Koi`Doken", zone, exp, section, Some(580_000), "Deep Sea set / Siren Song"),
  ]
}

fn t(
  id: String,
  name: String,
  zone: String,
  expansion: String,
  section: Option(String),
  hp: Option(Int),
  note: String,
) -> Target {
  Target(id:, name:, zone:, expansion:, section:, hp:, note:)
}

/// Expansion headings with optional zone subsections (>2 raid targets in that zone).
pub fn by_expansion() -> List(#(String, List(SectionBlock))) {
  [
    #("Classic", blocks_for(classic())),
    #("Kunark", blocks_for(kunark())),
    #("Velious", blocks_for(velious())),
  ]
}

fn blocks_for(group: List(Target)) -> List(SectionBlock) {
  let section_titles =
    group
    |> list.filter_map(fn(t) {
      case t.section {
        Some(title) -> Ok(title)
        None -> Error(Nil)
      }
    })
    |> list.unique
  let ungrouped =
    group
    |> list.filter(fn(t) { t.section == None })
    |> list.sort(compare_hp_then_name)
  let sections =
    list.map(section_titles, fn(title) {
      SectionBlock(
        title: Some(title),
        targets: group
          |> list.filter(fn(t) { t.section == Some(title) })
          |> list.sort(compare_hp_then_name),
      )
    })
  case ungrouped {
    [] -> sections
    rows -> [SectionBlock(title: None, targets: rows), ..sections]
  }
}

fn compare_expansion_then_hp(a: Target, b: Target) -> order.Order {
  case int.compare(expansion_rank(a.expansion), expansion_rank(b.expansion)) {
    order.Eq -> compare_section_then_hp(a, b)
    other -> other
  }
}

fn compare_section_then_hp(a: Target, b: Target) -> order.Order {
  case section_key(a.section), section_key(b.section) {
    l, r if l == r -> compare_hp_then_name(a, b)
    l, r -> string.compare(l, r)
  }
}

fn section_key(section: Option(String)) -> String {
  case section {
    None -> ""
    Some(title) -> title
  }
}

fn expansion_rank(expansion: String) -> Int {
  case expansion {
    "Classic" -> 0
    "Kunark" -> 1
    "Velious" -> 2
    _ -> 9
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

/// Display label for the markdown Expansion column (includes zone subsection).
pub fn expansion_label(t: Target) -> String {
  case t.section {
    None -> t.expansion
    Some(section) -> t.expansion <> " › " <> section
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
