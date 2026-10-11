import gleam/dict
import gleam/list
import gleeunit/should
import pom_deck

pub fn craftable_needs_all_cards_test() {
  let owned =
    list_owned([
      "white-throne",
      "blue-throne",
      "white-crown",
      "white-knight",
    ])

  pom_deck.craftable(owned)
  |> names
  |> should.equal(["Boots of Distraction"])
}

pub fn missing_one_points_at_farm_card_test() {
  let owned = list_owned(["white-throne", "blue-throne", "white-crown"])
  let rows = pom_deck.missing_one(owned)
  list.length(rows) |> should.not_equal(0)
  let assert [first, ..] = rows
  first.recipe.name |> should.equal("Boots of Distraction")
  first.missing_id |> should.equal("white-knight")
  first.missing_label |> should.equal("White Knight")
}

pub fn combine_spends_exact_recipe_cards_test() {
  let boots = ["white-throne", "blue-throne", "white-crown", "white-knight"]
  let owned = list_owned(["red-squire", ..boots])
  let after = pom_deck.combine(owned, boots)
  pom_deck.has_card(after, "white-throne") |> should.be_false
  pom_deck.has_card(after, "blue-throne") |> should.be_false
  pom_deck.has_card(after, "white-crown") |> should.be_false
  pom_deck.has_card(after, "white-knight") |> should.be_false
  pom_deck.has_card(after, "red-squire") |> should.be_true
  pom_deck.craftable(after) |> names |> should.equal([])
}

pub fn combine_noops_when_recipe_incomplete_test() {
  let owned = list_owned(["white-throne", "blue-throne", "white-crown"])
  let boots = ["white-throne", "blue-throne", "white-crown", "white-knight"]
  let after = pom_deck.combine(owned, boots)
  pom_deck.has_card(after, "white-throne") |> should.be_true
  pom_deck.encode_owned(after) |> should.equal(pom_deck.encode_owned(owned))
}

pub fn recipe_key_is_card_combination_not_name_test() {
  let assert [boots, ..] = pom_deck.craftable(list_owned([
    "white-throne",
    "blue-throne",
    "white-crown",
    "white-knight",
  ]))
  pom_deck.recipe_key(boots)
  |> should.equal("white-throne|blue-throne|white-crown|white-knight")
}

fn list_owned(ids: List(String)) -> dict.Dict(String, Bool) {
  list.fold(ids, dict.new(), fn(acc, id) { dict.insert(acc, id, True) })
}

fn names(recipes: List(pom_deck.Recipe)) -> List(String) {
  list.map(recipes, fn(r) { r.name })
}
