import character_tracker
import gleam/list
import gleeunit/should

pub fn encode_decode_roundtrip_test() {
  let chars = [
    character_tracker.Character(
      id: "a1",
      name: "Blimpy",
      class: "Wizard",
      level: 51,
      race: "Erudite",
      religion: "Solusek Ro",
      has_epic: True,
    ),
    character_tracker.Character(
      id: "b2",
      name: "Tanky",
      class: "Warrior",
      level: 60,
      race: "",
      religion: "",
      has_epic: False,
    ),
  ]
  character_tracker.encode(chars)
  |> character_tracker.decode
  |> should.equal(chars)
}

pub fn validate_requires_name_class_level_test() {
  let form =
    character_tracker.Form(
      name: "",
      class: "Warrior",
      level: "10",
      race: "",
      religion: "",
      has_epic: False,
    )
  character_tracker.validate(form)
  |> should.be_error

  let ok_form =
    character_tracker.Form(
      name: "Ada",
      class: "Cleric",
      level: "45",
      race: "",
      religion: "Rodcet Nife",
      has_epic: False,
    )
  case character_tracker.validate(ok_form) {
    Ok(#(name, class, level, race, religion, epic)) -> {
      name |> should.equal("Ada")
      class |> should.equal("Cleric")
      level |> should.equal(45)
      race |> should.equal("")
      religion |> should.equal("Rodcet Nife")
      epic |> should.be_false
    }
    Error(_) -> should.fail()
  }
}

pub fn upsert_and_remove_test() {
  let added =
    character_tracker.upsert(
      [],
      "",
      "id1",
      "One",
      "Monk",
      40,
      "Human",
      "",
      False,
    )
  list.length(added) |> should.equal(1)

  let edited =
    character_tracker.upsert(
      added,
      "id1",
      "id1",
      "One",
      "Monk",
      50,
      "Human",
      "Quellious",
      True,
    )
  let assert [only] = edited
  only.level |> should.equal(50)
  only.has_epic |> should.be_true

  character_tracker.remove(edited, "id1")
  |> list.length
  |> should.equal(0)
}
