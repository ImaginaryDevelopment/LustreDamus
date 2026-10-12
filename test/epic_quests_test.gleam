import gleam/dict
import gleam/list
import gleam/string
import gleeunit/should
import epic_quests

pub fn encode_decode_roundtrip_test() {
  let done =
    dict.new()
    |> dict.insert("war-final", True)
    |> dict.insert("rog-book", True)
    |> dict.insert("not-a-step", True)
  let raw = epic_quests.encode(done)
  let again = epic_quests.decode(raw)
  epic_quests.is_done(again, "war-final") |> should.be_true
  epic_quests.is_done(again, "rog-book") |> should.be_true
  epic_quests.is_done(again, "not-a-step") |> should.be_false
  epic_quests.total_done_count(again) |> should.equal(2)
}

pub fn toggle_off_removes_id_test() {
  let done =
    dict.new()
    |> dict.insert("war-final", True)
    |> epic_quests.toggle("war-final", False)
  epic_quests.is_done(done, "war-final") |> should.be_false
  epic_quests.encode(done) |> should.equal("")
}

pub fn decode_ignores_blank_and_unknown_test() {
  let done = epic_quests.decode(" ,war-hilts, not-a-step ,shm-fright,")
  epic_quests.is_done(done, "war-hilts") |> should.be_true
  epic_quests.is_done(done, "shm-fright") |> should.be_true
  epic_quests.total_done_count(done) |> should.equal(2)
}

pub fn clear_quest_keeps_other_classes_test() {
  let assert Ok(war) = epic_quests.find_quest("war")
  let done =
    dict.new()
    |> dict.insert("war-hilts", True)
    |> dict.insert("war-final", True)
    |> dict.insert("rog-book", True)
    |> epic_quests.clear_quest(war)
  epic_quests.is_done(done, "war-hilts") |> should.be_false
  epic_quests.is_done(done, "war-final") |> should.be_false
  epic_quests.is_done(done, "rog-book") |> should.be_true
}

pub fn every_class_has_steps_and_unique_ids_test() {
  let quests = epic_quests.quests()
  list.length(quests) |> should.equal(14)
  let ids = epic_quests.all_step_ids()
  list.length(ids) |> should.equal(list.length(list.unique(ids)))
  case list.find(quests, fn(q) { q.steps == [] || string.contains(q.wiki_path, " ") }) {
    Error(Nil) -> Nil
    Ok(_) -> should.fail()
  }
}

pub fn done_count_per_class_test() {
  let assert Ok(rog) = epic_quests.find_quest("rog")
  let done =
    dict.new()
    |> dict.insert("rog-book", True)
    |> dict.insert("rog-final", True)
  epic_quests.done_count(done, rog) |> should.equal(2)
  epic_quests.step_count(rog) |> should.equal(5)
}
