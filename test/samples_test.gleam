import gleam/list
import gleeunit
import gleeunit/should
import samples

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn zone_search_requires_two_letters_test() {
  samples.search_zones("")
  |> should.equal([])

  samples.search_zones("s")
  |> should.equal([])
}

pub fn zone_search_matches_shortname_test() {
  samples.search_zones("guk")
  |> list.map(fn(sample) { sample.id })
  |> should.equal(["upper-guk", "lower-guk"])
}

pub fn zone_search_matches_fullname_test() {
  samples.search_zones("trakanon")
  |> list.map(fn(sample) { sample.id })
  |> should.equal(["trakanons-teeth"])

  samples.search_zones("frozen shadow")
  |> list.map(fn(sample) { sample.id })
  |> should.equal(["tower-of-frozen-shadow"])
}

pub fn zone_search_is_case_insensitive_test() {
  samples.search_zones("SeBi")
  |> list.map(fn(sample) { sample.id })
  |> should.equal(["sebilis"])
}
