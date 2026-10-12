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
        "war-jeweled-hilt",
        "Jeweled Dragon Head Hilt",
        "Unjeweled hilt (Lake Rathe ground) + Diamond + Jacinth + Black Sapphire → Wenden (EFP).",
      ),
      s(
        "war-monocle-ore",
        "Giant Sized Monocle → Rejesiam Ore",
        "Dreadlands patriarch monocle → Mentrax Mountainbone (Frontier Mtns).",
      ),
      s(
        "war-finely-hilt",
        "Finely Crafted Dragon Head Hilt",
        "Severely Damaged hilt (Timorous chessboard) + Rejesiam Ore + Ball of Everliving Golem (Fear goons) → Wenden.",
      ),
      s(
        "war-ancient-sword-blade",
        "Ancient Sword Blade",
        "Block of Permafrost + Keg of Vox Tail Ale + 2× Rebreather → Denken Strongpick (OoT).",
      ),
      s(
        "war-ancient-blade",
        "Ancient Blade",
        "Queen Velazul Di`zok — Chardok (RAID / royals).",
      ),
      s(
        "war-kargek-lute",
        "Kargek note → Tiny Lute → Redblade's Legacy",
        "EFP Kargek → Oknoggin (Feerrott) → back to Kargek → book.",
      ),
      s(
        "war-tenal-frost",
        "Tenal: Frozen War Totem + Heart of Frost",
        "East Karana. Heart from Permafrost goblin wizards.",
      ),
      s(
        "war-dragon-scales",
        "Red + Green Dragon Scales → Totem of Fiery War path",
        "Red: Nagafen / Talendor / Nortlav. Green: Severilous. → Tenal.",
      ),
      s(
        "war-maestro-hand",
        "Hand of the Maestro + Mark of the Sword",
        "Plane of Hate Maestro — rare hand. → Tenal for note to Kargek.",
      ),
      s(
        "war-scabbard",
        "Spiroc Wingblade → Red Scabbard",
        "Spiroc Lord (Plane of Sky) + Tenal's note → Kargek.",
      ),
      s(
        "war-final",
        "Combine both hilts + both blades in Red Scabbard",
        "→ Jagged Blade of War. Split/recombine for Strategy + Tactics.",
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
        "Lord Bergurgle's Crown",
        "Lake Rathe underwater tower — middle goblin PH.",
      ),
      s(
        "clr-natasha-shell",
        "Ornate Sea Shell (Natasha / Shmendrik path)",
        "Crown → Shmendrik; kill spirit of flame; Damaged Crown → Natasha.",
      ),
      s(
        "clr-omat-statue",
        "Coral Statue of Tarew",
        "Ornate Sea Shell → Omat Vastsea (Timorous oasis).",
      ),
      s(
        "clr-plasmatic",
        "Blood Soaked Plasmatic Priest Robe",
        "Coral Statue → seeker (Solusek Ro temple) → kill plasmatic priest.",
      ),
      s(
        "clr-gimblox",
        "Lord Gimblox's Signet Ring",
        "Solusek's Eye (Sol A) goblin area.",
      ),
      s(
        "clr-frozen-orb",
        "Orb of Frozen Water",
        "Robe → Omat. Signet → Natasha for second Ornate Sea Shell.",
      ),
      s(
        "clr-ixiblat",
        "Sceptre of Ixiblat Fer + Message to Natasha",
        "Ornate Sea Shell → Naxot Deepwater (Burning Woods); kill Ixiblat.",
      ),
      s(
        "clr-singed",
        "Singed Scroll",
        "Overking Bathezid — Chardok royals.",
      ),
      s(
        "clr-clear-orb",
        "Orb of Clear Water + Shimmering Pearl",
        "Sceptre + Singed Scroll → Omat; Message → Natasha.",
      ),
      s(
        "clr-zordak-box",
        "Zordak's Box + Swirling Pearl (Sol B)",
        "Shimmering Pearl → Zordak Ragefire in Nagafen's Lair.",
      ),
      s(
        "clr-zordak-heart",
        "Zordak Ragefire's Heart (Skyfire)",
        "4× Pearlescent Fragment → Warder Cecilia → kill dragon form; combine seal + pearl.",
      ),
      s(
        "clr-final",
        "Three orbs → Orb of the Triumvirate → Avatar of Water",
        "Heart → Omat (Orb of Vapor); Jhassad → Avatar → Water Sprinkler.",
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
        "pal-ghoulbane",
        "Obtain Ghoulbane",
        "froglok shin lord (Upper Guk) or Joren Nobleheart (Felwithe).",
      ),
      s(
        "pal-soulfire",
        "Complete SoulFire",
        "Classic pre-epic 1HS — Plane of Sky / related path. Hold while progressing.",
      ),
      s(
        "pal-hole-sword",
        "Tainted Darksteel Sword",
        "Keeper of the Tombs — The Hole (2-group).",
      ),
      s(
        "pal-cleanse",
        "Cleanse the tainted sword path",
        "Follow P99 Fiery Avenger steps (temple / planar cleanses).",
      ),
      s(
        "pal-avenger",
        "Complete Fiery Avenger",
        "Intermediate 1HS before the final Defender.",
      ),
      s(
        "pal-defender-pieces",
        "Gather Fiery Defender components",
        "SoulFire + Ghoulbane + Fiery Avenger lines converge — see wiki Part 4.",
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
        "rng-telin-faelin",
        "Telin → Faelin → Dark Metal Coin",
        "Burning Woods Worn Note → Gfay Faelin → Kithicor Giz X`Tin → Worn coin.",
      ),
      s(
        "rng-east-karana",
        "East Karana gathering (Fleshbound Tome)",
        "Althele / Sionae / Nuien / Teloa chain → Earth Stained Note.",
      ),
      s(
        "rng-bowl-forage",
        "Shiny Tin Bowl + Hardened Mixture",
        "Ella Foodcrafter; forage Everfrost / Gfay / Innothule / Misty roots.",
      ),
      s(
        "rng-keepers",
        "Keepers of the Art + Ancient Pattern",
        "Batwing faction → Alrik Farsight / Felwithe grocery path.",
      ),
      s(
        "rng-clay-bowl",
        "Runecrested Bowl + Softly Glowing Stone",
        "Rose of Firiona path → Jade Reaver → Enchanted Clay → pottery combine.",
      ),
      s(
        "rng-venril",
        "Pulsing Green Stone (triggered VS)",
        "Karnor remains + Firefly Globe + Rez scroll → triggered Venril.",
      ),
      s(
        "rng-ancient-sword",
        "Warmly Glowing Stone → Ancient Longsword",
        "Foloal (FV) then Telin Darkforest.",
      ),
      s(
        "rng-hammer",
        "Soulbound Hammer (Jaeil)",
        "Shiny Tin Bowl → Jaeil the Wretched / Insane — The Hole.",
      ),
      s(
        "rng-sky-sphere",
        "Swirling Sphere of Color",
        "Plane of Sky island 4 essence tamer.",
      ),
      s(
        "rng-mithril",
        "Hammer of the Ancients → Refined blades",
        "Erudin Mairee → Kinlo / Usbak (Kaladim).",
      ),
      s(
        "rng-swiftwind",
        "Swiftwind",
        "Refined Ancient Sword → Telin → Faelin.",
      ),
      s(
        "rng-earthcaller",
        "Earthcaller",
        "Shattered Emerald of Corruption (Hate) + Refined Mithril Blade → Xanuusus.",
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
        "shd-darkforge",
        "Darkforge Helm / Greaves / Breastplate",
        "Feerrott Tae Ew + Freeport / Sol A / Enchanted Platinum → Solusek undead knights.",
      ),
      s(
        "shd-kurron",
        "Kurron Ni → Letter to Duriek",
        "Overthere — armor + 900pp; kill him for the letter.",
      ),
      s(
        "shd-duriek-faction",
        "Duriek Bloodpool faction chain",
        "Letter; Cough Elixir (Smaka 1000pp); Dusty Tome (Hole ratman).",
      ),
      s(
        "shd-weapons",
        "Blade of Abrogation + Ghoulbane + Soul Leech",
        "Sky trash; Upper Guk / Joren; Fear goons or Cazic.",
      ),
      s(
        "shd-sheath",
        "Decrepit Sheath",
        "Drake Spine (Rharzar) + Decrepit Hide (Hate) + Enchanted Platinum → Teydar.",
      ),
      s(
        "shd-corrupted-ghoulbane",
        "Corrupted Ghoulbane",
        "Four weapons/sheath → Duriek.",
      ),
      s(
        "shd-soulcase",
        "Soulcase + Seal of Kastane path",
        "Knarthenne / Marl (Toxxulia); Gerot note loop.",
      ),
      s(
        "shd-hole-cell",
        "Cell Key → Kyrenna (Heart / Blood)",
        "Hole jail — Caradon; FD-split Kyrenna.",
      ),
      s(
        "shd-glohnor",
        "Head of Glohnor + Wrappings",
        "Dark Shroud → Ghost of Glohnor → Mummy.",
      ),
      s(
        "shd-will",
        "Head of the Valiant + Will of Innoruuk",
        "Gerot (head); Marl (wrappings).",
      ),
      s(
        "shd-lhranc",
        "Lhranc fight (City of Mist)",
        "Corrupted Ghoulbane + Heart of the Innocent + Head of the Valiant + Will → Lhranc. RAID-grade.",
      ),
      s(
        "shd-final",
        "Final → Innoruuk's Curse",
        "Marl Kastane after Lhranc. Soul Consumption at 50.",
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
        "dru-telin-faelin",
        "Telin → Faelin → Dark Metal Coin",
        "Same early path as Ranger (Burning Woods / Gfay / Kithicor).",
      ),
      s(
        "dru-east-karana",
        "East Karana gathering → Earth Stained Note",
        "Althele chain + Fleshbound Tome.",
      ),
      s(
        "dru-bowl-forage",
        "Shiny Tin Bowl + Hardened Mixture",
        "Ella; forage four zone roots.",
      ),
      s(
        "dru-keepers-pattern",
        "Ancient Pattern + Runecrested Bowl",
        "Keepers faction → Alrik / Felwithe / Firiona Rose / Jade Reaver clay.",
      ),
      s(
        "dru-soft-stone",
        "Softly Glowing Stone",
        "Hardened Mixture + Runecrested Bowl → Ella.",
      ),
      s(
        "dru-venril",
        "Pulsing Green Stone (triggered VS)",
        "Same Karnor remains / Firefly / Rez method as Ranger.",
      ),
      s(
        "dru-elaborate",
        "Warmly Glowing Stone → Elaborate Scimitar",
        "Foloal then Ella Foodcrafter.",
      ),
      s(
        "dru-antonica",
        "Cleansed Spirit of Antonica",
        "Corrupted Lake Rathe / Rathe HG / Everfrost mammoth → withered treant → Yeka.",
      ),
      s(
        "dru-faydwer",
        "Cleansed Spirit of Faydwer",
        "Corrupted OoT cyclops / Kedge seahorse / Lfay brownie → unicorn → Silox.",
      ),
      s(
        "dru-kunark",
        "Cleansed Spirit of Kunark",
        "Emerald gorilla / LoIO barracuda / Ulump / Faydedar → Nekexin.",
      ),
      s(
        "dru-final",
        "Three cleansed spirits + Elaborate Scimitar → Xanuusus",
        "North Karana. Equip gated 46 on P99.",
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
        "mnk-lost-circle",
        "Robe of the Lost Circle",
        "Camp Brother Zephyl / Qwinn, or Code of Zan Fi + Purple Headband / Idol + Red Sash path.",
      ),
      s(
        "mnk-pipes",
        "Metal Pipe (Zan) + Metal Pipe (Fi)",
        "Karnor pawbuster; Chardok iksar betrayer.",
      ),
      s(
        "mnk-whistling",
        "Robe of the Whistling Fists",
        "Lost Circle + both pipes → Brother Balatin (Dreadlands; FD trade).",
      ),
      s(
        "mnk-eejag",
        "Charred Scale (Eejag)",
        "Lavastorm — say challenge to fire sprite.",
      ),
      s(
        "mnk-gwan",
        "Breath of Gwan",
        "Plane of Sky island 1.5 — Charred Scale → a presence.",
      ),
      s(
        "mnk-trunt",
        "Trunt's Head",
        "Breath of Gwan → sleeping ogre (Nurga) → Trunt.",
      ),
      s(
        "mnk-kaiaren-eye",
        "Eye of Kaiaren",
        "Trunt's Head → Astral Projection (Overthere).",
      ),
      s(
        "mnk-demon-fangs",
        "Demon Fangs (Xenevorash)",
        "Eye → LoIO lake Astral Projection; kill Vorash/Deep → Xenevorash.",
      ),
      s(
        "mnk-immortals",
        "Immortals → Danl's Reference",
        "Skyfire named → Tomekeeper Danl (Erudin).",
      ),
      s(
        "mnk-celestial-book",
        "Celestial Fists (book)",
        "Danl's Reference + Whistling Fists robe → Lheao (Timorous).",
      ),
      s(
        "mnk-final",
        "Crazy / sane Kaiaren → Celestial Fists",
        "Trakanon's Teeth: book alone then Book of Celestial Fists + Demon Fangs. Equip 46.",
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
        "brd-page24-top",
        "Maestro's Symphony Page 24 Top",
        "Konia torch relay: Misty → SRo → Lake Rathe → Proof of Speed.",
      ),
      s(
        "brd-page24-bottom",
        "Maestro's Symphony Page 24 Bottom",
        "Baenar doll / Sol A / Unrest Serra / Maligar head → Mahlin's Bongos → Konia.",
      ),
      s(
        "brd-page25",
        "Maestro's Symphony Page 25",
        "Onyx / Red Wurm / Chromodrac guts → Kelkim Menkia.",
      ),
      s(
        "brd-lute-head",
        "Mystical Lute Head",
        "Alluring Horn → Vedico → Forpar; Kedge Backbone + Amygdalan Tendril + Werewolf Skull.",
      ),
      s(
        "brd-lute-body",
        "Mystical Lute Body",
        "White + Red Dragon Scales + Metal Bits → Forpar.",
      ),
      s(
        "brd-strings",
        "Undead Dragongut Strings",
        "Trakanon (or Undead Bard trigger path).",
      ),
      s(
        "brd-lute",
        "Mystical Lute",
        "Head + Body + Strings → Forpar.",
      ),
      s(
        "brd-final",
        "Baldric Slezaf final turn-in",
        "Both page 24s + page 25 + Mystical Lute (Dreadlands). Equip + effect 46.",
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
        "rog-parchment-top",
        "Stained Parchment Top",
        "Pickpocket Founy Jestands — North Kaladim (do not kill).",
      ),
      s(
        "rog-parchment-bottom",
        "Stained Parchment Bottom",
        "Pickpocket Tani N`Mar — Neriak Third Gate.",
      ),
      s(
        "rog-book",
        "Book of Souls",
        "Classic Plane of Hate ground spawn (IdleQuest-enabled).",
      ),
      s(
        "rog-stanos-combine",
        "Combined Parchment (Stanos)",
        "Anson → Stanos (Highpass); both stained parchments.",
      ),
      s(
        "rog-eldreth",
        "Scribbled Parchment (Eldreth)",
        "Lake Rathe — Combined Parchment + 2× Milk + 100pp.",
      ),
      s(
        "rog-yendar",
        "Yendar → Renux → Translated Parchment",
        "Scribbled → Yendar; Book of Souls + Tattered → kill Renux.",
      ),
      s(
        "rog-sealed-box",
        "Sealed Box from Stanos",
        "Translated Parchment → Stanos.",
      ),
      s(
        "rog-vghera",
        "General V`ghera → General's Pouch",
        "Sealed Box → Kithicor dark elves (night); RAID / multi-group.",
      ),
      s(
        "rog-robes",
        "Four robes → Cazic Quill",
        "Kedge / Ishva / Shining Metallic / Oracle → Vilnius (West Karana).",
      ),
      s(
        "rog-dagger",
        "Jagged Diamond Dagger",
        "Fleshripper + Painbringer + Gigantic Zweihander + Mithril 2HS → Vilnius.",
      ),
      s(
        "rog-final",
        "Stanos final → Ragebringer",
        "Cazic Quill + General's Pouch + Jagged Diamond Dagger. Equip 46.",
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
        "shm-tiny-gem",
        "Tiny Gem from a lesser spirit",
        "Captain Surestout (OoT) or Peg Leg / manslayer / Blinde paths.",
      ),
      s(
        "shm-bondl",
        "Bondl → Opaque Gem → walk the path",
        "West Freeport Jade Tiger basement greater spirit.",
      ),
      s(
        "shm-eruds",
        "Erud's Crossing spirit event → Small Gem",
        "Ooglyn follow; Srafen / Dillon / Froham / Abe dialogue.",
      ),
      s(
        "shm-rathe",
        "Marr's Promise + Envy + Woe",
        "Tabien the Goodly / Glaron the Wicked — Rathe Mountains.",
      ),
      s(
        "shm-sparkling",
        "Sparkling Gem (wandering spirit)",
        "West Karana — Small Gem then Marr/Envy/Woe.",
      ),
      s(
        "shm-sentinel1",
        "Emerald Jungle Spirit Sentinel + Black Dire",
        "Sparkling Gem; kill Black Dire (Mistmoore) → pelt turn-in → Ancient Journal.",
      ),
      s(
        "shm-com-report",
        "City of Mist six pages → Completed Report",
        "Combine in Ancient Journal → EJ Spirit Sentinel.",
      ),
      s(
        "shm-ghiosk",
        "Lord Ghiosk three books",
        "City of Mist — Crusades / Housekeeper / Historic Article.",
      ),
      s(
        "shm-icon",
        "Icon of the High Scale (ground)",
        "City of Mist north temple ground spawn.",
      ),
      s(
        "shm-sentinel2",
        "Lake Spirit Sentinel (three books)",
        "Emerald Jungle underwater sentinel.",
      ),
      s(
        "shm-kirn",
        "Engraved Ring (High Scale Kirn)",
        "Icon → Kirn (The Hole); kill for Promise Ring.",
      ),
      s(
        "shm-neh",
        "Neh`Ashiir's Diary",
        "Ring → quest-spawned Neh`Ashiir (CoM) → diary → lake sentinel.",
      ),
      s(
        "shm-fright",
        "Child's Tear (Fear broodling)",
        "Kill Dread/Fright/Terror → Iksar broodling.",
      ),
      s(
        "shm-final",
        "Lord Rak`Ashiir → Iksar Scale → Spear of Fate",
        "Tear → Rak`Ashiir (CoM elevator); scale → lake sentinel. Equip 46.",
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
        "nec-edwin",
        "Head of Sir Edwin Motte → Symbol of the Apprentice",
        "Rathe Mountains inn cycle → Kazen (Lake Rathe).",
      ),
      s(
        "nec-black-robe",
        "Flowing Black Robe → Rolling Stone Moss",
        "Najena or Overthere casters → Venenzi (Nektulos).",
      ),
      s(
        "nec-serpent",
        "Symbol of the Serpent",
        "Twisted Symbol + Rolling Stone Moss → Emkel.",
      ),
      s(
        "nec-manisi",
        "Manisi Herb → Refined Manisi Herb",
        "Grand Herbalist Mak`ha (Chardok) → Ssessthrass (Swamp of No Hope).",
      ),
      s(
        "nec-testing",
        "Symbol of Testing fight → Symbol of Insanity",
        "Emkel → Kazen spawns; loot from tortured soul.",
      ),
      s(
        "nec-spiroc-cloak",
        "Cloak of Spiroc Feathers",
        "Plane of Sky quest room — Black Silk Cape + Silver Disc + Spiroc Feathers.",
      ),
      s(
        "nec-fear-hate",
        "Slime Blood of Cazic-Thule + Eye of Innoruuk",
        "Fear (CT or goons); Hate named.",
      ),
      s(
        "nec-prepared",
        "Prepared Reagent Box (Drendico)",
        "Timorous — Symbol of Insanity + three reagents.",
      ),
      s(
        "nec-tome",
        "Tome of Instruction",
        "Prepared Reagent Box → Kazen.",
      ),
      s(
        "nec-gkzzallk",
        "Gkzzallk in a Box",
        "Thunder spirit princess 1pp → Gkzzallk (Sky island 3).",
      ),
      s(
        "nec-final",
        "Gkzzallk in a Box → Kazen → Scythe",
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
        "wiz-solomen",
        "Note to Camin (Solomen)",
        "Temple of Solusek Ro — say agree.",
      ),
      s(
        "wiz-ros-breath",
        "Ro's Breath path (Halas / Erudin)",
        "Buy Ro's Breath; Note + 1000pp + Ro's Breath → Camin; return to Dargon.",
      ),
      s(
        "wiz-arantir",
        "Arantir's Ring → Note from Arantir",
        "Challice (Felwithe) loop; say gnome to Arantir.",
      ),
      s(
        "wiz-sprocket",
        "Gnome Sprocket (Kandin)",
        "Butcherblock — Note from Arantir; say oil.",
      ),
      s(
        "wiz-green-oil",
        "Green Oil from enraged golem",
        "Gnome Sprocket → a broken golem (Plane of Fear).",
      ),
      s(
        "wiz-gabstik",
        "Staff of Gabstik + Note to Arantir",
        "Green Oil → Kandin Firepot.",
      ),
      s(
        "wiz-blue-staff",
        "Blue Crystal Staff",
        "Phinigel Autropos — Kedge Keep.",
      ),
      s(
        "wiz-gnarled",
        "Gnarled Staff",
        "Venril Sathir — Karnor's Castle.",
      ),
      s(
        "wiz-sealed-bag",
        "Magically Sealed Bag",
        "Staff of Gabstik + Blue Crystal + Gnarled → Arantir (Everfrost).",
      ),
      s(
        "wiz-final",
        "Magically Sealed Bag → Solomen → Staff of the Four",
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
        "mag-power-elements",
        "Power of the Elements",
        "Wind (Mistmoore) / Fire (Sol A) / Earth (Lfay) / Water (Kaesora) → Walnan.",
      ),
      s(
        "mag-words-mastery",
        "Words of Mastery",
        "Four Torn Pages of Mastery (Najena) → Akkstaff.",
      ),
      s(
        "mag-magikot",
        "Words of Magi'Kot",
        "Three Magi'kot pages (Kithicor / Unrest / Lower Guk) → Jahsohn.",
      ),
      s(
        "mag-orb-power",
        "Power of the Orb",
        "Elements + Mastery + Magi'Kot → Rykas (Lake Rathe).",
      ),
      s(
        "mag-element-fire",
        "Element of Fire",
        "Burning Embers + Blazing Wand + Torch of the Elements + Power of the Orb → Jennus (Skyfire).",
      ),
      s(
        "mag-element-wind",
        "Element of Wind",
        "Crown of Elemental Mastery + Pegasus Feather Cloak + Elemental Binder → Kihun (Sky).",
      ),
      s(
        "mag-element-earth",
        "Element of Earth",
        "Staff:Earth (Hate) + Dirt of Underfoot (Slixin / Burning Woods) + Shovel of Ponz + Broom of Trilon → Tiblner.",
      ),
      s(
        "mag-element-water",
        "Element of Water",
        "Rain of Karana + Staff:Water (Phinigel) + Tears of Erollisi → Jinalis.",
      ),
      s(
        "mag-final",
        "Four Elements → Master of Elements → Summon Orb",
        "Plane of Sky quest island. Manifest Elements at 46.",
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
        "enc-jeb-seal",
        "Jeb's Seal",
        "Ink vial / ghoul scribe / SMR / Mechanical Pen / White Paper → Stofo → sarnak imitator (Burning Woods).",
      ),
      s(
        "enc-staff1",
        "1st Piece of Staff (Modani)",
        "Xolion Rod + Innoruuk's Word + Chalice of Kings + Snow Blossoms → Overthere.",
      ),
      s(
        "enc-staff2",
        "2nd Piece of Staff (Clockwork VIIX)",
        "Spoon + The One Key + Lost Scroll + Charm and Sacrifice → Ak'Anon.",
      ),
      s(
        "enc-staff3",
        "3rd Piece of Staff (Nadia)",
        "Charm-enchant dull gems (Kaesora / Skyfire / Overthere / CoM) → Firiona.",
      ),
      s(
        "enc-kindle",
        "Essence of a Ghost (Kindle)",
        "Ghost of Kindle — The Hole.",
      ),
      s(
        "enc-staff4",
        "4th Piece of Staff (Polzin)",
        "Serpent Head (Fear) + Vampire Essence (Hate) + Sands (Tangrin) + Ghost Essence → Polzin.",
      ),
      s(
        "enc-bundle",
        "Bundle of Staves",
        "Combine all four pieces in Enchanter's Sack.",
      ),
      s(
        "enc-final",
        "Bundle → sarnak imitator → Staff of the Serpent",
        "Burning Woods. Speed of the Shissar at 50.",
      ),
    ],
  )
}
