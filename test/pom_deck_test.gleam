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

fn list_owned(ids: List(String)) -> dict.Dict(String, Bool) {
  list.fold(ids, dict.new(), fn(acc, id) { dict.insert(acc, id, True) })
}

fn names(recipes: List(pom_deck.Recipe)) -> List(String) {
  list.map(recipes, fn(r) { r.name })
}
