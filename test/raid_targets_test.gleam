import gleam/dict
import gleam/list
import gleeunit/should
import raid_targets

pub fn encode_decode_roundtrip_test() {
  let beaten =
    dict.new()
    |> dict.insert("trakanon", True)
    |> dict.insert("king-tormax", True)
    |> dict.insert("unknown-junk", True)
  let raw = raid_targets.encode(beaten)
  let again = raid_targets.decode(raw)
  raid_targets.has_beaten(again, "trakanon") |> should.be_true
  raid_targets.has_beaten(again, "king-tormax") |> should.be_true
  raid_targets.has_beaten(again, "unknown-junk") |> should.be_false
  raid_targets.beaten_count(again) |> should.equal(2)
}

pub fn toggle_off_removes_id_test() {
  let beaten =
    dict.new()
    |> dict.insert("trakanon", True)
    |> raid_targets.toggle("trakanon", False)
  raid_targets.has_beaten(beaten, "trakanon") |> should.be_false
  raid_targets.encode(beaten) |> should.equal("")
}

pub fn decode_ignores_blank_and_unknown_test() {
  let beaten = raid_targets.decode(" ,trakanon, not-a-boss ,lady-vox,")
  raid_targets.has_beaten(beaten, "trakanon") |> should.be_true
  raid_targets.has_beaten(beaten, "lady-vox") |> should.be_true
  raid_targets.beaten_count(beaten) |> should.equal(2)
}

pub fn by_expansion_covers_all_targets_test() {
  let listed =
    raid_targets.by_expansion()
    |> list.flat_map(fn(group) {
      let #(_, targets) = group
      targets
    })
    |> list.length
  listed |> should.equal(list.length(raid_targets.targets()))
}
