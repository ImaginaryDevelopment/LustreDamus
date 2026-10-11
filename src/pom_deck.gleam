import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub const storage_key: String = "lustredamus.pom-deck.v1"

pub type Card {
  Card(id: String, label: String, farm: String)
}

pub type Recipe {
  Recipe(name: String, classes: String, needs: List(String))
}

pub type MissingOne {
  MissingOne(recipe: Recipe, missing_id: String, missing_label: String, farm: String)
}

/// 16 playing cards used in Deck of Spontaneous Generation combines.
pub fn cards() -> List(Card) {
  let throne_farm =
    "Throne pool: Brenn / Grenn / TwentyTwo (~3.75%). Stallion also (~3.5%) — LEAVE for horn quest."
  let crown_farm =
    "Crown/Jester pool (~1%): #Lithiniath, Bristlebane Puppet, Clukker, Debbis; Ferjeneror shares table — LEAVE."
  let knight_farm =
    "Knight pool (~1.25%): Bit, Mizer, Chuckles, Geb, Bozer, god puppets, castle nameds, Posie."
  let squire_farm =
    "Squire pool (~1.25%): Dupple, Plupple, Snitch, Stitch, Dop Dop, forest mushrooms; Bob/Peachy share — LEAVE."

  list.flatten([
    color_rank("throne", "Throne", throne_farm),
    color_rank("crown", "Crown", crown_farm),
    color_rank("knight", "Knight", knight_farm),
    color_rank("squire", "Squire", squire_farm),
  ])
}

fn color_rank(rank: String, rank_label: String, farm: String) -> List(Card) {
  [
    Card("black-" <> rank, "Black " <> rank_label, farm),
    Card("blue-" <> rank, "Blue " <> rank_label, farm),
    Card("red-" <> rank, "Red " <> rank_label, farm),
    Card("white-" <> rank, "White " <> rank_label, farm),
  ]
}

pub fn card_by_id(id: String) -> Result(Card, Nil) {
  list.find(cards(), fn(c) { c.id == id })
}

pub fn card_label(id: String) -> String {
  case card_by_id(id) {
    Ok(c) -> c.label
    Error(_) -> id
  }
}

pub fn card_farm(id: String) -> String {
  case card_by_id(id) {
    Ok(c) -> c.farm
    Error(_) -> ""
  }
}

/// Classic / P99 Deck combines (Velious 1.0).
pub fn recipes() -> List(Recipe) {
  [
    Recipe(
      "Boots of Distraction",
      "WAR CLR PAL SHD BRD",
      ["white-throne", "blue-throne", "white-crown", "white-knight"],
    ),
    Recipe(
      "Breastplate of Distraction",
      "WAR CLR PAL SHD BRD",
      ["red-throne", "black-throne", "black-crown", "black-knight"],
    ),
    Recipe(
      "Crown of Distraction",
      "WAR CLR PAL SHD BRD",
      ["red-throne", "blue-throne", "red-crown", "blue-crown"],
    ),
    Recipe(
      "Gloves of Distraction",
      "WAR CLR PAL SHD BRD",
      ["white-throne", "red-throne", "white-crown", "white-knight"],
    ),
    Recipe(
      "Greaves of Distraction",
      "WAR CLR PAL SHD BRD",
      ["blue-throne", "black-throne", "black-crown", "black-knight"],
    ),
    Recipe(
      "Robe of Distraction",
      "NEC WIZ MAG ENC",
      ["black-throne", "red-throne", "black-crown", "red-crown"],
    ),
    Recipe(
      "Vambraces of Distraction",
      "WAR CLR PAL SHD BRD",
      ["white-throne", "black-crown", "black-knight", "black-squire"],
    ),
    Recipe(
      "Wristguard of Distraction",
      "WAR CLR PAL SHD BRD",
      ["white-throne", "black-throne", "white-crown", "white-knight"],
    ),
    Recipe(
      "Bracelet of the Twisted Mind",
      "NEC WIZ MAG ENC",
      ["white-throne", "blue-throne", "blue-crown", "blue-knight"],
    ),
    Recipe(
      "Green Wristguard",
      "RNG DRU",
      ["white-throne", "red-throne", "red-crown", "red-knight"],
    ),
    Recipe(
      "Mushroom Bracelet",
      "MNK (HUM IKS)",
      ["black-throne", "blue-throne", "blue-crown", "blue-knight"],
    ),
    Recipe(
      "Onyx Wristbands",
      "SHD",
      ["blue-throne", "red-throne", "red-crown", "red-knight"],
    ),
    Recipe(
      "Shimmering Wristguard",
      "CLR PAL",
      ["red-throne", "blue-throne", "blue-crown", "blue-knight"],
    ),
    Recipe(
      "Silver Wristguards",
      "PAL",
      ["black-throne", "red-throne", "red-crown", "red-knight"],
    ),
    Recipe(
      "Black Flower of Functionality",
      "ALL (disease)",
      ["black-squire", "white-squire", "red-squire", "blue-squire"],
    ),
    Recipe(
      "Blue Flower of Functionality",
      "ALL (magic)",
      ["black-throne", "white-throne", "red-throne", "blue-throne"],
    ),
    Recipe(
      "Green Flower of Functionality",
      "ALL (poison)",
      ["black-knight", "white-knight", "red-knight", "blue-knight"],
    ),
    Recipe(
      "White Flower of Functionality",
      "ALL (cold)",
      ["black-crown", "white-crown", "red-crown", "blue-crown"],
    ),
    Recipe(
      "Red Flower of Functionality",
      "ALL (fire)",
      ["white-throne", "white-crown", "white-knight", "white-squire"],
    ),
    Recipe(
      "Buckler of Doom",
      "ALL",
      ["black-throne", "black-crown", "black-knight", "black-squire"],
    ),
    Recipe(
      "Cloak of Confusion",
      "ALL",
      ["blue-throne", "blue-crown", "blue-knight", "blue-squire"],
    ),
    Recipe(
      "Mask of Melodies",
      "BRD",
      ["red-throne", "red-crown", "red-knight", "red-squire"],
    ),
    Recipe(
      "Belt of Inconsistency",
      "ALL",
      ["white-throne", "blue-throne", "white-crown", "blue-crown"],
    ),
    Recipe(
      "Globe of Darkness",
      "ALL",
      ["black-throne", "blue-throne", "black-crown", "blue-crown"],
    ),
    Recipe(
      "Idiot Savant's Cap",
      "ALL",
      ["red-throne", "white-throne", "red-crown", "white-crown"],
    ),
    Recipe(
      "Very Rusty Dagger",
      "SHD ROG",
      ["black-throne", "white-throne", "black-crown", "white-crown"],
    ),
  ]
}

pub fn has_card(owned: Dict(String, Bool), id: String) -> Bool {
  case dict.get(owned, id) {
    Ok(True) -> True
    _ -> False
  }
}

pub fn craftable(owned: Dict(String, Bool)) -> List(Recipe) {
  list.filter(recipes(), fn(r) {
    list.all(r.needs, fn(id) { has_card(owned, id) })
  })
}

pub fn missing_one(owned: Dict(String, Bool)) -> List(MissingOne) {
  recipes()
  |> list.filter_map(fn(r) {
    let missing =
      list.filter(r.needs, fn(id) { !has_card(owned, id) })
    case missing {
      [only] ->
        Ok(MissingOne(
          recipe: r,
          missing_id: only,
          missing_label: card_label(only),
          farm: card_farm(only),
        ))
      _ -> Error(Nil)
    }
  })
}

pub fn encode_owned(owned: Dict(String, Bool)) -> String {
  cards()
  |> list.filter(fn(c) { has_card(owned, c.id) })
  |> list.map(fn(c) { c.id })
  |> string.join(",")
}

pub fn decode_owned(raw: String) -> Dict(String, Bool) {
  let ids =
    raw
    |> string.split(",")
    |> list.map(string.trim)
    |> list.filter(fn(s) { s != "" })
  list.fold(ids, dict.new(), fn(acc, id) { dict.insert(acc, id, True) })
}

pub fn toggle(owned: Dict(String, Bool), id: String, on: Bool) -> Dict(String, Bool) {
  case on {
    True -> dict.insert(owned, id, True)
    False -> dict.delete(owned, id)
  }
}

pub fn ranks() -> List(#(String, String)) {
  [
    #("throne", "Throne"),
    #("crown", "Crown"),
    #("knight", "Knight"),
    #("squire", "Squire"),
  ]
}

pub fn colors() -> List(#(String, String)) {
  [
    #("black", "Black"),
    #("blue", "Blue"),
    #("red", "Red"),
    #("white", "White"),
  ]
}

pub fn needs_labels(needs: List(String)) -> String {
  needs
  |> list.map(card_label)
  |> string.join(", ")
}
