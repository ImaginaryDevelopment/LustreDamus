import gleeunit/should
import router

pub fn encode_paste_test() {
  router.encode(router.Paste) |> should.equal("/")
  router.href(router.Paste) |> should.equal("#/")
}

pub fn encode_sample_test() {
  router.encode(router.Sample("raid-targets"))
  |> should.equal("/s/raid-targets")
  router.href(router.Sample("raid-targets"))
  |> should.equal("#/s/raid-targets")
}

pub fn decode_empty_and_root_test() {
  router.decode("") |> should.equal(router.Paste)
  router.decode("#") |> should.equal(router.Paste)
  router.decode("#/") |> should.equal(router.Paste)
  router.decode("/") |> should.equal(router.Paste)
}

pub fn decode_known_sample_test() {
  router.decode("#/s/raid-targets")
  |> should.equal(router.Sample("raid-targets"))
  router.decode("/s/trakanons-teeth")
  |> should.equal(router.Sample("trakanons-teeth"))
  router.decode("s/character-tracker")
  |> should.equal(router.Sample("character-tracker"))
}

pub fn decode_zone_index_test() {
  router.decode("#/s/zone-index")
  |> should.equal(router.Sample("zone-index"))
}

pub fn decode_unknown_falls_back_to_paste_test() {
  router.decode("#/s/not-a-real-sample")
  |> should.equal(router.Paste)
  router.decode("#/other")
  |> should.equal(router.Paste)
  router.decode("#/s/")
  |> should.equal(router.Paste)
}

pub fn encode_decode_roundtrip_test() {
  let route = router.Sample("epic-quests")
  router.decode(router.href(route)) |> should.equal(route)
  router.decode(router.href(router.Paste)) |> should.equal(router.Paste)
}
