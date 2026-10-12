//// Class epic 1.0 checklists (P99 milestones). Done flags in localStorage.

import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub const storage_key: String = "lustredamus.epic-quests.done.v1"

pub type Step {
  Step(id: String, label: String, note: String)
}

pub type ClassQuest {
  ClassQuest(
    id: String,
    class: String,
    final_epic: String,
    wiki_path: String,
    steps: List(Step),
  )
}

/// Stable step ids — changing an id drops that checkbox from saved progress.
pub fn quests() -> List(ClassQuest) {
  [
    warrior(),
    cleric(),
    paladin(),
    ranger(),
    shadow_knight(),
    druid(),
    monk(),
    bard(),
    rogue(),
    shaman(),
    necromancer(),
    wizard(),
    magician(),
    enchanter(),
  ]
}

pub fn class_ids() -> List(String) {
  list.map(quests(), fn(q) { q.id })
}

pub fn find_quest(id: String) -> Result(ClassQuest, Nil) {
  list.find(quests(), fn(q) { q.id == id })
}

pub fn all_step_ids() -> List(String) {
  quests()
  |> list.flat_map(fn(q) { list.map(q.steps, fn(s) { s.id }) })
}

pub fn step_count(quest: ClassQuest) -> Int {
  list.length(quest.steps)
}

pub fn done_count(done: Dict(String, Bool), quest: ClassQuest) -> Int {
  quest.steps
  |> list.filter(fn(s) { is_done(done, s.id) })
  |> list.length
}

pub fn total_step_count() -> Int {
  list.length(all_step_ids())
}

pub fn total_done_count(done: Dict(String, Bool)) -> Int {
  all_step_ids()
  |> list.filter(fn(id) { is_done(done, id) })
  |> list.length
}

pub fn is_done(done: Dict(String, Bool), id: String) -> Bool {
  case dict.get(done, id) {
    Ok(True) -> True
    _ -> False
  }
}

pub fn toggle(done: Dict(String, Bool), id: String, on: Bool) -> Dict(String, Bool) {
  case on {
    True -> dict.insert(done, id, True)
    False -> dict.delete(done, id)
  }
}

pub fn clear_quest(done: Dict(String, Bool), quest: ClassQuest) -> Dict(String, Bool) {
  list.fold(quest.steps, done, fn(acc, step) { dict.delete(acc, step.id) })
}

pub fn encode(done: Dict(String, Bool)) -> String {
  all_step_ids()
  |> list.filter(fn(id) { is_done(done, id) })
  |> string.join(",")
}

pub fn decode(raw: String) -> Dict(String, Bool) {
  let known = all_step_ids()
  raw
  |> string.split(",")
  |> list.map(string.trim)
  |> list.filter(fn(s) { s != "" && list.contains(known, s) })
  |> list.fold(dict.new(), fn(acc, id) { dict.insert(acc, id, True) })
}

fn s(id: String, label: String, note: String) -> Step {
  Step(id:, label:, note:)
}

fn warrior() -> ClassQuest {
  ClassQuest(
    id: "war",
    class: "Warrior",
    final_epic: "Jagged Blade of War",
    wiki_path: "Warrior_Epic_Quest",
    steps: [
      s(
        "war-hilts",
        "Pick up both dragon-head hilts",
        "Unjeweled (Lake Rathe ground) + Severely Damaged (Timorous ground).",
      ),
      s(
        "war-sky-eyes",
        "Farm Plane of Sky dragon eyes",
        "Needed to complete red / blue / green dragon heads.",
      ),
      s(
        "war-dragon-heads",
        "Complete Red, Blue, and Green Dragon Heads",
        "Kunark / VP dragon scales + Sky eyes. RAID pieces.",
      ),
      s(
        "war-kargek",
        "Finish Kargek / Tiny Dagger of War path",
        "Plane of Sky / Timorous NPC chain.",
      ),
      s(
        "war-final",
        "Combine → Jagged Blade of War",
        "Can split into Strategy + Tactics (1HS pair).",
      ),
    ],
  )
}

fn cleric() -> ClassQuest {
  ClassQuest(
    id: "clr",
    class: "Cleric",
    final_epic: "Water Sprinkler of Nem Ankh",
    wiki_path: "Cleric_Epic_Quest",
    steps: [
      s(
        "clr-bergurgle",
        "Lord Bergurgle / Plaguebringer path",
        "Early Freeport / Lake Rathe pearl chain.",
      ),
      s(
        "clr-lucan",
        "Sir Lucan D`Lere encounter",
        "Freeport — expect fight / faction care.",
      ),
      s(
        "clr-plague-shark",
        "Plague Shark bones",
        "Ocean of Tears / related shark camp.",
      ),
      s(
        "clr-zordak",
        "Heart of Zordak Ragefire",
        "Skyfire Mountains — RAID dragon.",
      ),
      s(
        "clr-final",
        "Final turn-in → Water Sprinkler of Nem Ankh",
        "Reviviscence click activates at 50.",
      ),
    ],
  )
}

fn paladin() -> ClassQuest {
  ClassQuest(
    id: "pal",
    class: "Paladin",
    final_epic: "Fiery Defender",
    wiki_path: "Paladin_Epic_Quest",
    steps: [
      s(
        "pal-soulfire",
        "Obtain SoulFire",
        "Classic sky / Ghoulbane path. Hold as pre-epic.",
      ),
      s(
        "pal-hole-sword",
        "Tainted Darksteel Sword",
        "Keeper of the Tombs — The Hole (2-group).",
      ),
      s(
        "pal-avenger",
        "Complete Fiery Avenger",
        "Intermediate 1HS before the final.",
      ),
      s(
        "pal-final",
        "Final → Fiery Defender",
        "Holy Shock click at 50.",
      ),
    ],
  )
}

fn ranger() -> ClassQuest {
  ClassQuest(
    id: "rng",
    class: "Ranger",
    final_epic: "Swiftwind + Earthcaller",
    wiki_path: "Ranger_Epic_Quest",
    steps: [
      s(
        "rng-hammer",
        "Soulbound Hammer",
        "Jaeil the Insane (The Hole) — spawn with Shiny Tin Bowl.",
      ),
      s(
        "rng-venril",
        "Venril / Karnor pieces",
        "Chardok / Karnor / VS path for the dual 1HS set.",
      ),
      s(
        "rng-swiftwind",
        "Complete Swiftwind",
        "Melee 1HS of the dual set.",
      ),
      s(
        "rng-earthcaller",
        "Complete Earthcaller",
        "Earthcall click at 50; Swift Spirit is worn.",
      ),
    ],
  )
}

fn shadow_knight() -> ClassQuest {
  ClassQuest(
    id: "shd",
    class: "Shadow Knight",
    final_epic: "Innoruuk's Curse",
    wiki_path: "Shadow_Knight_Epic_Quest",
    steps: [
      s(
        "shd-hole-cell",
        "Cell Key → Kyrenna (Heart / Blood)",
        "The Hole jail — Caradon at indifferent; FD-split Kyrenna.",
      ),
      s(
        "shd-glohnor",
        "Head of Glohnor",
        "Fallen erudites → Ghost → Mummy of Glohnor (Hole graveyard).",
      ),
      s(
        "shd-com",
        "City of Mist / Lhranc path",
        "Illegible Scroll off spectral courier; leave Lhranc until ready.",
      ),
      s(
        "shd-greenmist",
        "Greenmist / Kunark combines",
        "See Quest-Gear for Hole + Greenmist components.",
      ),
      s(
        "shd-final",
        "Final → Innoruuk's Curse",
        "Soul Consumption click at 50.",
      ),
    ],
  )
}

fn druid() -> ClassQuest {
  ClassQuest(
    id: "dru",
    class: "Druid",
    final_epic: "Nature Walkers Scimitar",
    wiki_path: "Druid_Epic_Quest",
    steps: [
      s(
        "dru-faelin",
        "Faelin / Scout early path",
        "Lesser Faydark start; collect scout tools.",
      ),
      s(
        "dru-sky",
        "Nature Walker's Sky Emerald",
        "Plane of Sky bear test / gorgalask reagents.",
      ),
      s(
        "dru-growth",
        "Plane of Growth / Tunare pieces",
        "Often 46+ for Growth.",
      ),
      s(
        "dru-final",
        "Final → Nature Walkers Scimitar",
        "Equip gated 46 on P99; Wrath of Nature at 50.",
      ),
    ],
  )
}

fn monk() -> ClassQuest {
  ClassQuest(
    id: "mnk",
    class: "Monk",
    final_epic: "Celestial Fists",
    wiki_path: "Monk_Epic_Quest",
    steps: [
      s(
        "mnk-zanfi",
        "Code of Zan Fi + Purple Headband",
        "Targin the Rock (Sol B) + Brother Qwinn turn-in.",
      ),
      s(
        "mnk-flute",
        "Ancient Thin Flute",
        "Brother Balatin (Dreadlands) — PH plaguebone.",
      ),
      s(
        "mnk-robe",
        "Robe of the Lost Circle",
        "Whistling Fists / Lost Circle path.",
      ),
      s(
        "mnk-trunt",
        "Trunt's Head",
        "Trunt — Mines of Nurga (2-group triggered).",
      ),
      s(
        "mnk-final",
        "Final → Celestial Fists",
        "Hands slot. Equip 46; Celestial Tranquility at 50.",
      ),
    ],
  )
}

fn bard() -> ClassQuest {
  ClassQuest(
    id: "brd",
    class: "Bard",
    final_epic: "Singing Short Sword",
    wiki_path: "Bard_Epic_Quest",
    steps: [
      s(
        "brd-baldric",
        "Start with Baldric Slezaf",
        "Dreadlands — LEAVE until you are on the epic.",
      ),
      s(
        "brd-headbands",
        "Red / Mystical headband chain",
        "Classic + Kunark bard headband path.",
      ),
      s(
        "brd-hate",
        "Maestro / Plane of Hate pieces",
        "RAID Hate — Hand of the Maestro / related.",
      ),
      s(
        "brd-final",
        "Final → Singing Short Sword",
        "Equip + Dance of the Blade both 46.",
      ),
    ],
  )
}

fn rogue() -> ClassQuest {
  ClassQuest(
    id: "rog",
    class: "Rogue",
    final_epic: "Ragebringer",
    wiki_path: "Rogue_Epic_Quest",
    steps: [
      s(
        "rog-book",
        "Book of Souls",
        "Classic Plane of Hate ground spawn (IdleQuest-enabled).",
      ),
      s(
        "rog-stanos",
        "Stanos / Highpass path",
        "Jagged Diamond Dagger and Stanos turn-ins.",
      ),
      s(
        "rog-yendar",
        "Yendar Starpyre / Founy",
        "Steamfont / related combine path.",
      ),
      s(
        "rog-vghera",
        "General V`ghera",
        "Karnor's Castle — RAID / 2-group grade.",
      ),
      s(
        "rog-final",
        "Final → Ragebringer",
        "Equip 46. Worn haste (~40%).",
      ),
    ],
  )
}

fn shaman() -> ClassQuest {
  ClassQuest(
    id: "shm",
    class: "Shaman",
    final_epic: "Spear of Fate",
    wiki_path: "Shaman_Epic_Quest",
    steps: [
      s(
        "shm-icon",
        "Icon of the High Scale + diary path",
        "City of Mist ground Icon; Neh`Ashiir diary (quest-spawn).",
      ),
      s(
        "shm-kirn",
        "Engraved Ring (Promise Ring)",
        "High Scale Kirn — The Hole (2-group).",
      ),
      s(
        "shm-fright",
        "Eye of Fright",
        "a boogeyman — Plane of Fear.",
      ),
      s(
        "shm-final",
        "Final → Spear of Fate",
        "P99: equip gated 46 even if MQ’d. Curse of the Spirits at 50.",
      ),
    ],
  )
}

fn necromancer() -> ClassQuest {
  ClassQuest(
    id: "nec",
    class: "Necromancer",
    final_epic: "Scythe of the Shadowed Soul",
    wiki_path: "Necromancer_Epic_Quest",
    steps: [
      s(
        "nec-symbol",
        "Symbol of the Apprentice path",
        "Early necromancer epic symbol chain.",
      ),
      s(
        "nec-burning",
        "Burning Dead / Kunark pieces",
        "Kunark nec camps and combines.",
      ),
      s(
        "nec-hate",
        "Innoruuk / Plane of Hate pieces",
        "RAID Hate reagents for the finale.",
      ),
      s(
        "nec-final",
        "Final → Scythe of the Shadowed Soul",
        "Torment of Shadows click at 50.",
      ),
    ],
  )
}

fn wizard() -> ClassQuest {
  ClassQuest(
    id: "wiz",
    class: "Wizard",
    final_epic: "Staff of the Four",
    wiki_path: "Wizard_Epic_Quest",
    steps: [
      s(
        "wiz-blue-staff",
        "Blue Crystal Staff path",
        "Solusek Ro / Temple of Solusek Ro chain.",
      ),
      s(
        "wiz-ore",
        "Fusible Igneous Ore",
        "Skyfire ground — check IdleQuest enable list (often disabled).",
      ),
      s(
        "wiz-genni",
        "Genni / Solusek temple turn-ins",
        "Complete the staff piece combines.",
      ),
      s(
        "wiz-final",
        "Final → Staff of the Four",
        "Barrier of Force click at 50.",
      ),
    ],
  )
}

fn magician() -> ClassQuest {
  ClassQuest(
    id: "mag",
    class: "Magician",
    final_epic: "Orb of Mastery",
    wiki_path: "Magician_Epic_Quest",
    steps: [
      s(
        "mag-dirt",
        "Dirt of Underfoot",
        "Slixin Klex — The Hole (not Soil of Underfoot).",
      ),
      s(
        "mag-irak",
        "Irak Altil / Power of the Elements",
        "Plane of Fear — LEAVE Irak until on the epic.",
      ),
      s(
        "mag-sky",
        "Plane of Sky elemental powers",
        "Collect the elemental mastery pieces.",
      ),
      s(
        "mag-final",
        "Final → Orb of Mastery",
        "Manifest Elements at 46; resummon when spent.",
      ),
    ],
  )
}

fn enchanter() -> ClassQuest {
  ClassQuest(
    id: "enc",
    class: "Enchanter",
    final_epic: "Staff of the Serpent",
    wiki_path: "Enchanter_Epic_Quest",
    steps: [
      s(
        "enc-kindle",
        "Essence of a Ghost",
        "Ghost of Kindle — The Hole (indifferent; kill anyway).",
      ),
      s(
        "enc-polzin",
        "4th Piece of Staff (Polzin Mrid)",
        "Combine essences in Enchanter's Sack first — Hole.",
      ),
      s(
        "enc-jeb",
        "Jeb's Seal / Staff of the Serpent path",
        "Remaining Kunark / classic combines.",
      ),
      s(
        "enc-final",
        "Final → Staff of the Serpent",
        "Speed of the Shissar click at 50.",
      ),
    ],
  )
}
