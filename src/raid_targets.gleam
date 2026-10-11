//// Classic–Velious raid targets with sessionStorage "beaten" flags.

import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub const storage_key: String = "lustredamus.raid-targets.beaten.v1"

pub type Target {
  Target(id: String, name: String, zone: String, expansion: String, note: String)
}

/// Stable ids used for sessionStorage — keep in sync with Raid-Targets.md.
pub fn targets() -> List(Target) {
  list.flatten([
    classic(),
    kunark(),
    velious(),
  ])
}

fn classic() -> List(Target) {
  [
    Target("phara-dar-sky", "Phara Dar (Sky isle)", "Plane of Sky", "Classic", "Island dragon"),
    Target("lord-nagafen", "Lord Nagafen", "Nagafen's Lair", "Classic", "Fire giant dragon"),
    Target("lady-vox", "Lady Vox", "Permafrost", "Classic", "Ice dragon"),
    Target("innoruuk", "Innoruuk", "Plane of Hate", "Classic", "God"),
    Target("cazic-thule", "Cazic-Thule", "Plane of Fear", "Classic", "God"),
  ]
}

fn kunark() -> List(Target) {
  [
    Target("trakanon", "Trakanon", "Old Sebilis", "Kunark", "Dragon lair"),
    Target("venril-sathir", "Venril Sathir", "Karnor's Castle", "Kunark", "Live VS"),
    Target("venril-sathir-triggered", "Venril Sathir (Triggered)", "Karnor's Castle", "Kunark", "2-group; Pulsing Green Stones"),
    Target("construct-of-sathir", "Construct of Sathir", "Karnor's Castle", "Kunark", "2-group"),
    Target("drusella-sathir", "Drusella Sathir", "Howling Stones", "Kunark", "2-group east boss"),
    Target("overking-bathezid", "Overking Bathezid", "Chardok", "Kunark", "Royals"),
    Target("queen-velazul", "Queen Velazul Di`zok", "Chardok", "Kunark", "Royals"),
    Target("prince-selrach", "Prince Selrach Di`zok", "Chardok", "Kunark", "Royals"),
    Target("korocust", "Korocust", "Chardok", "Kunark", "2-group bridge"),
    Target("trunt", "Trunt", "Mines of Nurga", "Kunark", "2-group triggered"),
    Target("faydedar", "Faydedar", "Timorous Deep", "Kunark", "Water dragon"),
    Target("gorenaire", "Gorenaire", "Dreadlands", "Kunark", "Outdoor dragon"),
    Target("severilous", "Severilous", "Emerald Jungle", "Kunark", "Outdoor dragon"),
    Target("talendor", "Talendor", "Skyfire Mountains", "Kunark", "Outdoor dragon"),
    Target("silverwing", "Silverwing", "Veeshan's Peak", "Kunark", "VP crawl"),
    Target("hoshkar", "Hoshkar", "Veeshan's Peak", "Kunark", "VP crawl"),
    Target("xygoz", "Xygoz", "Veeshan's Peak", "Kunark", "VP crawl"),
    Target("druushk", "Druushk", "Veeshan's Peak", "Kunark", "VP crawl"),
    Target("nexona", "Nexona", "Veeshan's Peak", "Kunark", "VP crawl"),
    Target("phara-dar", "Phara Dar", "Veeshan's Peak", "Kunark", "VP top"),
  ]
}

fn velious() -> List(Target) {
  [
    Target("king-tormax", "King Tormax", "Kael Drakkel", "Velious", "Kromzek king"),
    Target("derakor", "Derakor the Vindicator", "Kael Drakkel", "Velious", "Near throne"),
    Target("dain-frostreaver", "Dain Frostreaver IV", "Icewell Keep", "Velious", "Coldain king"),
    Target("lord-yelinak", "Lord Yelinak", "Skyshrine", "Velious", "Dragon king"),
    Target("zlandicar", "Zlandicar", "Dragon Necropolis", "Velious", "Necropolis dragon"),
    Target("vaniki", "Vaniki", "Dragon Necropolis", "Velious", "Chetari raid named"),
    Target("velketor", "Velketor the Sorcerer", "Velketor's Labyrinth", "Velious", "Tower boss"),
    Target("doljon", "Lord Doljonijiarnimorinar", "Velketor's Labyrinth", "Velious", "Efreeti"),
    Target("tserrina", "Tserrina Syl'Tor", "Tower of Frozen Shadow", "Velious", "2-group floor 7"),
    Target("tunare", "Tunare", "Plane of Growth", "Velious", "Goddess"),
    Target("guardian-of-tunare", "Guardian of Tunare", "Plane of Growth", "Velious", "With Tunare"),
    Target("dozekar", "Dozekar the Cursed", "Temple of Veeshan", "Velious", "ToV west"),
    Target("aaryonar", "Aaryonar", "Temple of Veeshan", "Velious", "ToV"),
    Target("lady-nevederia", "Lady Nevederia", "Temple of Veeshan", "Velious", "ToV"),
    Target("lord-vyemm", "Lord Vyemm", "Temple of Veeshan", "Velious", "ToV"),
    Target("dagarn", "Dagarn the Destroyer", "Temple of Veeshan", "Velious", "ToV live spawn"),
    Target("tukaarak", "Tukaarak the Warder", "Sleeper's Tomb", "Velious", "Ice warder"),
    Target("nanzata", "Nanzata the Warder", "Sleeper's Tomb", "Velious", "Fire warder"),
    Target("ventani", "Ventani the Warder", "Sleeper's Tomb", "Velious", "Disease warder"),
    Target("hraashna", "Hraashna the Warder", "Sleeper's Tomb", "Velious", "Magic warder"),
    Target("kildrukaun", "Kildrukaun the Ancient", "Sleeper's Tomb", "Velious", "Black ancient"),
    Target("vyskudra", "Vyskudra the Ancient", "Sleeper's Tomb", "Velious", "Storm ancient"),
    Target("tjudawos", "Tjudawos the Ancient", "Sleeper's Tomb", "Velious", "Gold ancient"),
    Target("zeixshi-kar", "Zeixshi-Kar the Ancient", "Sleeper's Tomb", "Velious", "Silver ancient"),
    Target("master-of-the-guard", "Master of the Guard", "Sleeper's Tomb", "Velious", "ST"),
    Target("final-arbiter", "The Final Arbiter", "Sleeper's Tomb", "Velious", "ST"),
    Target("progenitor", "The Progenitor", "Sleeper's Tomb", "Velious", "ST"),
    Target("the-sleeper", "The Sleeper (Kerafyrm)", "Sleeper's Tomb", "Velious", "Wake event"),
    Target("all-seeing-eye", "All-Seeing Eye", "Plane of Mischief", "Velious", "Huge HP fluff"),
  ]
}

pub fn by_expansion() -> List(#(String, List(Target))) {
  [
    #("Classic", classic()),
    #("Kunark", kunark()),
    #("Velious", velious()),
  ]
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
