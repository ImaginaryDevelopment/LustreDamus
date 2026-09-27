import gleam/list
import gleam/string
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

pub fn zone_index_includes_levels_xp_and_friendly_star_test() {
  let md = samples.zone_index_markdown()
  should.be_true(string.contains(md, "| High Keep* | highkeep* | 20–40 | 2.00× |"))
  should.be_true(string.contains(md, "| Sebilis | sebilis | 48–60 | 2.50× |"))
  should.be_true(string.contains(md, "| PoGrowth* | growthplane* |"))
}

pub fn zone_has_friendly_caution_test() {
  should.be_true(samples.zone_has_friendly_caution("highpass"))
  should.be_false(samples.zone_has_friendly_caution("sebilis"))
}

pub fn by_class_sample_detection_test() {
  let assert Ok(rogue_face) = samples.find("rogue-face")
  let assert Ok(sebilis) = samples.find("sebilis")
  should.be_true(samples.is_by_class_sample(rogue_face))
  should.be_false(samples.is_by_class_sample(sebilis))
}
