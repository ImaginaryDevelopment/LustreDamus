import gleam/int
import gleam/list
import gleam/string

pub const storage_key: String = "lustredamus.characters.v1"

pub type Character {
  Character(
    id: String,
    name: String,
    class: String,
    level: Int,
    race: String,
    religion: String,
    has_epic: Bool,
  )
}

pub type Form {
  Form(
    name: String,
    class: String,
    level: String,
    race: String,
    religion: String,
    has_epic: Bool,
  )
}

pub fn empty_form() -> Form {
  Form(
    name: "",
    class: "Warrior",
    level: "",
    race: "",
    religion: "",
    has_epic: False,
  )
}

pub fn form_from_character(c: Character) -> Form {
  Form(
    name: c.name,
    class: c.class,
    level: int.to_string(c.level),
    race: c.race,
    religion: c.religion,
    has_epic: c.has_epic,
  )
}

pub fn set_name(form: Form, name: String) -> Form {
  Form(..form, name:)
}

pub fn set_class(form: Form, class: String) -> Form {
  Form(..form, class:)
}

pub fn set_level(form: Form, level: String) -> Form {
  Form(..form, level:)
}

pub fn set_race(form: Form, race: String) -> Form {
  Form(..form, race:)
}

pub fn set_religion(form: Form, religion: String) -> Form {
  Form(..form, religion:)
}

pub fn set_has_epic(form: Form, has_epic: Bool) -> Form {
  Form(..form, has_epic:)
}

pub fn classes() -> List(String) {
  [
    "Warrior",
    "Cleric",
    "Paladin",
    "Ranger",
    "Shadow Knight",
    "Druid",
    "Monk",
    "Bard",
    "Rogue",
    "Shaman",
    "Necromancer",
    "Wizard",
    "Magician",
    "Enchanter",
  ]
}

pub fn races() -> List(String) {
  [
    "Barbarian",
    "Dark Elf",
    "Dwarf",
    "Erudite",
    "Gnome",
    "Half Elf",
    "Halfling",
    "High Elf",
    "Human",
    "Iksar",
    "Ogre",
    "Troll",
    "Wood Elf",
  ]
}

pub fn religions() -> List(String) {
  [
    "Agnostic",
    "Bertoxxulous",
    "Brell Serilis",
    "Bristlebane",
    "Cazic-Thule",
    "Erollisi Marr",
    "Innoruuk",
    "Karana",
    "Mithaniel Marr",
    "Prexus",
    "Quellious",
    "Rallos Zek",
    "Rodcet Nife",
    "Solusek Ro",
    "The Tribunal",
    "Tunare",
    "Veeshan",
  ]
}

pub fn encode(characters: List(Character)) -> String {
  characters
  |> list.map(encode_one)
  |> string.join("\n")
  |> fn(body) { "v1\n" <> body }
}

fn encode_one(c: Character) -> String {
  string.join(
    [
      scrub(c.id),
      scrub(c.name),
      scrub(c.class),
      int.to_string(c.level),
      scrub(c.race),
      scrub(c.religion),
      case c.has_epic {
        True -> "1"
        False -> "0"
      },
    ],
    "\t",
  )
}

fn scrub(value: String) -> String {
  value
  |> string.replace("\t", " ")
  |> string.replace("\n", " ")
  |> string.replace("\r", " ")
  |> string.trim
}

pub fn decode(raw: String) -> List(Character) {
  let lines =
    raw
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.filter(fn(line) { line != "" })
  case lines {
    ["v1", ..rest] -> list.filter_map(rest, decode_one)
    _ -> list.filter_map(lines, decode_one)
  }
}

fn decode_one(line: String) -> Result(Character, Nil) {
  case string.split(line, "\t") {
    [id, name, class, level_s, race, religion, epic_s] ->
      case int.parse(level_s) {
        Ok(level) ->
          Ok(Character(
            id:,
            name:,
            class:,
            level:,
            race:,
            religion:,
            has_epic: epic_s == "1" || string.lowercase(epic_s) == "true",
          ))
        Error(_) -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

pub fn validate(form: Form) -> Result(#(String, String, Int, String, String, Bool), String) {
  let name = string.trim(form.name)
  let class = string.trim(form.class)
  let race = string.trim(form.race)
  let religion = string.trim(form.religion)
  let level_s = string.trim(form.level)
  case name == "" {
    True -> Error("Name is required.")
    False ->
      case class == "" {
        True -> Error("Class is required.")
        False ->
          case int.parse(level_s) {
            Error(_) -> Error("Level must be a number.")
            Ok(level) ->
              case level < 1 || level > 100 {
                True -> Error("Level must be between 1 and 100.")
                False -> Ok(#(name, class, level, race, religion, form.has_epic))
              }
          }
      }
  }
}

pub fn upsert(
  characters: List(Character),
  editing_id: String,
  id: String,
  name: String,
  class: String,
  level: Int,
  race: String,
  religion: String,
  has_epic: Bool,
) -> List(Character) {
  let next =
    Character(id:, name:, class:, level:, race:, religion:, has_epic:)
  case editing_id == "" {
    True -> list.append(characters, [next])
    False ->
      list.map(characters, fn(c) {
        case c.id == editing_id {
          True -> next
          False -> c
        }
      })
  }
}

pub fn remove(characters: List(Character), id: String) -> List(Character) {
  list.filter(characters, fn(c) { c.id != id })
}

pub fn find(characters: List(Character), id: String) -> Result(Character, Nil) {
  list.find(characters, fn(c) { c.id == id })
}
