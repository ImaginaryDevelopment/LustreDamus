import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/string
import gleeunit/should
import raid_targets
import table_sort

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

pub fn targets_sorted_expansion_then_hp_test() {
  let ids = list.map(raid_targets.targets(), fn(t) { t.id })
  let naggy = list_index(ids, "lord-nagafen")
  let trak = list_index(ids, "trakanon")
  let sleeper = list_index(ids, "the-sleeper")
  let xygoz = list_index(ids, "xygoz")
  let hoshkar = list_index(ids, "hoshkar")
  { naggy < trak } |> should.be_true
  { trak < sleeper } |> should.be_true
  { hoshkar < xygoz } |> should.be_true
}

pub fn default_sorts_expansion_then_hp_test() {
  let assert Ok(sort) =
    dict.get(raid_targets.default_sorts(), raid_targets.table_title)
  sort.primary.column |> should.equal(0)
  sort.primary.kind |> should.equal(table_sort.SortText)
  let assert Some(secondary) = sort.secondary
  secondary.column |> should.equal(3)
  secondary.kind |> should.equal(table_sort.SortNumeric)
}

pub fn status_encode_decode_skips_unknown_test() {
  let statuses =
    dict.new()
    |> raid_targets.set_status("trakanon", raid_targets.NeedForEpic)
    |> raid_targets.set_status("king-tormax", raid_targets.Blah)
    |> raid_targets.set_status("lady-vox", raid_targets.Unknown)
  let raw = raid_targets.encode_status(statuses)
  string.contains(raw, "trakanon:needForEpic") |> should.be_true
  string.contains(raw, "king-tormax:blah") |> should.be_true
  string.contains(raw, "lady-vox") |> should.be_false
  let again = raid_targets.decode_status(raw)
  raid_targets.get_status(again, "trakanon")
  |> should.equal(raid_targets.NeedForEpic)
  raid_targets.get_status(again, "king-tormax")
  |> should.equal(raid_targets.Blah)
  raid_targets.get_status(again, "lady-vox")
  |> should.equal(raid_targets.Unknown)
}

pub fn kill_mode_encode_decode_skips_unknown_test() {
  let modes =
    dict.new()
    |> raid_targets.set_kill_mode("trakanon", raid_targets.Group)
    |> raid_targets.set_kill_mode("king-tormax", raid_targets.Raid)
    |> raid_targets.set_kill_mode("lady-vox", raid_targets.KillUnknown)
  let raw = raid_targets.encode_kill_mode(modes)
  string.contains(raw, "trakanon:group") |> should.be_true
  string.contains(raw, "king-tormax:raid") |> should.be_true
  string.contains(raw, "lady-vox") |> should.be_false
  let again = raid_targets.decode_kill_mode(raw)
  raid_targets.get_kill_mode(again, "trakanon")
  |> should.equal(raid_targets.Group)
  raid_targets.get_kill_mode(again, "king-tormax")
  |> should.equal(raid_targets.Raid)
  raid_targets.get_kill_mode(again, "lady-vox")
  |> should.equal(raid_targets.KillUnknown)
}

fn list_index(items: List(String), needle: String) -> Int {
  list_index_loop(items, needle, 0)
}

fn list_index_loop(items: List(String), needle: String, i: Int) -> Int {
  case items {
    [head, ..] if head == needle -> i
    [_, ..rest] -> list_index_loop(rest, needle, i + 1)
    [] -> -1
  }
}
