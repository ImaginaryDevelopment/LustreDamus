import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import pal_index
import table_format.{type TableFormatter}

/// Markdown samples shipped with the static site.
pub type Sample {
  Sample(
    id: String,
    label: String,
    shortname: String,
    fullname: String,
    folder: String,
    file: String,
    blurb: String,
  )
}

pub type SampleGroup {
  SampleGroup(
    id: String,
    label: String,
    samples: List(Sample),
    buckets: List(SampleGroup),
  )
}

pub fn palworld() -> List(Sample) {
  [
    sheet(
      "mounts",
      "Mounts",
      "palworld",
      "Mounts.md",
      "Rideable Pals by speed, stamina, and saddles.",
    ),
    sheet(
      "mining-pals",
      "Mining Pals",
      "palworld",
      "Mining-Pals.md",
      "Miners plus carry weight and mining-speed helpers.",
    ),
    sheet(
      "breeding-sheet",
      "Breeding Sheet",
      "palworld",
      "Breeding-Sheet.md",
      "Paldex IDs, elements, breed rank, and traits.",
    ),
    sheet(
      "player-damage-conversion",
      "Damage Conversion",
      "palworld",
      "Player-Damage-Conversion.md",
      "Pals that convert your attack element.",
    ),
    sheet(
      "early-game-skill-fruits",
      "Skill Fruits",
      "palworld",
      "Early-Game-Skill-Fruits.md",
      "Early Skill Fruits to chase and where to farm them.",
    ),
  ]
}

pub fn everquest() -> List(Sample) {
  group_samples(everquest_group())
}

fn everquest_group() -> SampleGroup {
  SampleGroup(
    id: "everquest",
    label: "EverQuest",
    samples: [quest_gear_sample(), velious_factions_sample()],
    buckets: [
      SampleGroup(id: "eq-all", label: "All", samples: [], buckets: []),
      SampleGroup(
        id: "eq-xp",
        label: "XP",
        samples: [
          zone_xp_sample(),
          raid_xp_sample(),
          party_dps_estimates_sample(),
        ],
        buckets: [],
      ),
      expansion_bucket("eq-classic", "Classic", classic_towns(), classic_solo(), classic_dungeon()),
      expansion_bucket("eq-kunark", "Kunark", kunark_towns(), kunark_solo(), kunark_dungeon()),
      expansion_bucket(
        "eq-velious",
        "Velious",
        velious_towns(),
        velious_solo(),
        velious_dungeon(),
      ),
      SampleGroup(id: "eq-by-class", label: "byClass", samples: [], buckets: [
        SampleGroup(
          id: "eq-warrior",
          label: "Warrior",
          samples: everquest_warrior(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-cleric",
          label: "Cleric",
          samples: everquest_cleric(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-druid",
          label: "Druid",
          samples: everquest_druid(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-monk",
          label: "Monk",
          samples: everquest_monk(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-ranger",
          label: "Ranger",
          samples: everquest_ranger(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-rogue",
          label: "Rogue",
          samples: everquest_rogue(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-shaman",
          label: "Shaman",
          samples: everquest_shaman(),
          buckets: [],
        ),
        SampleGroup(
          id: "eq-wizard",
          label: "Wizard",
          samples: everquest_wizard(),
          buckets: [],
        ),
      ]),
    ],
  )
}

fn expansion_bucket(
  id: String,
  label: String,
  towns: List(Sample),
  solo: List(Sample),
  dungeon: List(Sample),
) -> SampleGroup {
  SampleGroup(id: id, label: label, samples: [], buckets: [
    SampleGroup(id: id <> "-towns", label: "Towns", samples: towns, buckets: []),
    SampleGroup(
      id: id <> "-solo",
      label: "Solo / Small",
      samples: solo,
      buckets: [],
    ),
    SampleGroup(
      id: id <> "-dungeon",
      label: "Dungeon",
      samples: dungeon,
      buckets: [],
    ),
  ])
}

fn quest_gear_sample() -> Sample {
  sheet(
    "quest-gear",
    "Quest Gear",
    "everquest",
    "Quest-Gear.md",
    "Turn-in armor and loot to save for gear (Classic / Kunark / Velious).",
  )
}

fn velious_factions_sample() -> Sample {
  sheet(
    "velious-factions",
    "Velious Factions",
    "everquest",
    "Velious-Factions.md",
    "Coldain, Claws of Veeshan, and Frost Giant faction choices.",
  )
}

fn party_dps_estimates_sample() -> Sample {
  sheet(
    "party-dps-estimates",
    "Party DPS",
    "everquest",
    "Party-DPS-Estimates.md",
    "Party / raid burn estimates: melee, casters, mixed comps, DoT fight length (Classic / Kunark / Velious).",
  )
}

fn raid_xp_sample() -> Sample {
  sheet(
    "raid-xp",
    "Raid XP",
    "everquest",
    "Raid-XP.md",
    "Per-kill XP in a raid vs a party (tiny raid of 6 and raid of 10).",
  )
}

fn zone_xp_sample() -> Sample {
  sheet(
    "zone-xp-modifiers",
    "Zone XP",
    "everquest",
    "Zone-XP-Modifiers.md",
    "Classic zone experience multipliers by shortname.",
  )
}

/// Synthetic sample shown when EverQuest → All is open (no on-disk file).
pub fn zone_index_sample() -> Sample {
  sheet(
    "zone-index",
    "All zones",
    "everquest",
    "Zone-Index.md",
    "All sheeted zones with hunt levels, XP modifier, and friendly-NPC caution (*).",
  )
}

/// Markdown for the All-zones index table (generated from registered zone samples).
pub fn zone_index_markdown() -> String {
  let header =
    "# All zones\n\nHunt levels, XP modifier (`—` if unknown), and `*` when auto-level can hit friendlies / faction NPCs. Hover any `*` cell for the caution note.\n\n## By zone\n\n| Zone | Shortname | Levels | XP |\n| --- | --- | ---: | ---: |\n"
  let rows =
    everquest_zones()
    |> list.sort(fn(a, b) {
      string.compare(string.lowercase(a.label), string.lowercase(b.label))
    })
    |> list.map(zone_index_row)
    |> string.join("")
  header <> rows
}

fn zone_index_row(sample: Sample) -> String {
  let star = case zone_has_friendly_caution(sample.shortname) {
    True -> "*"
    False -> ""
  }
  let levels = case hunt_levels(sample) {
    "" -> "—"
    band -> band
  }
  let xp = case zone_xp_modifier(sample.shortname) {
    "" -> "—"
    mult -> mult
  }
  "| "
  <> sample.label
  <> star
  <> " | "
  <> sample.shortname
  <> star
  <> " | "
  <> levels
  <> " | "
  <> xp
  <> " |\n"
}

/// XP multiplier string like `1.13×`, or empty when unknown.
pub fn zone_xp_modifier(shortname: String) -> String {
  case dict.get(zone_xp_multipliers(), shortname) {
    Ok(xp) -> xp
    Error(_) -> ""
  }
}

pub fn zone_has_friendly_caution(shortname: String) -> Bool {
  list.contains(zone_friendly_shortnames(), shortname)
}

fn classic_towns() -> List(Sample) {
  []
}

fn classic_solo() -> List(Sample) {
  [
    zone(
      "befallen",
      "Befallen",
      "befallen",
      "Befallen",
      "Befallen.md",
      "Befallen unique drops (2.13× XP).",
    ),
    zone(
      "crushbone",
      "Crushbone",
      "crushbone",
      "Crushbone",
      "Crushbone.md",
      "Crushbone unique drops (2.13× XP).",
    ),
    zone(
      "gorge-of-king-xorbb",
      "Xorbb",
      "beholder",
      "Gorge of King Xorbb",
      "Gorge-of-King-Xorbb.md",
      "Gorge of King Xorbb nameds and unique loot (1.00× XP).",
    ),
    zone(
      "upper-guk",
      "Upper Guk",
      "guktop",
      "Upper Guk",
      "Upper-Guk.md",
      "Upper Guk unique drops (2.00× XP).",
    ),
    zone(
      "high-keep",
      "High Keep",
      "highkeep",
      "High Keep",
      "High-Keep.md",
      "High Keep unique drops (2.00× XP).",
    ),
    zone(
      "highpass-hold",
      "Highpass Hold",
      "highpass",
      "Highpass Hold",
      "Highpass-Hold.md",
      "Highpass Hold nameds and Anson McBale spawn (1.06× XP).",
    ),
    zone(
      "lavastorm-mountains",
      "Lavastorm",
      "lavastorm",
      "Lavastorm Mountains",
      "Lavastorm-Mountains.md",
      "Lavastorm Mountains goblin camps and Sol approaches (0.75× XP).",
    ),
    zone(
      "najena",
      "Najena",
      "najena",
      "Najena",
      "Najena.md",
      "Najena unique drops (1.73× XP).",
    ),
    zone(
      "ocean-of-tears",
      "Ocean of Tears",
      "oot",
      "Ocean of Tears",
      "Ocean-of-Tears.md",
      "Ocean of Tears islands, pirates, and Sister Isle faction caution (1.13× XP).",
    ),
    zone(
      "unrest",
      "Unrest",
      "unrest",
      "Estate of Unrest",
      "Unrest.md",
      "Estate of Unrest unique drops (1.73× XP).",
    ),
    zone(
      "blackburrow",
      "Blackburrow",
      "blackburrow",
      "Blackburrow",
      "Blackburrow.md",
      "Blackburrow unique drops (1.33× XP).",
    ),
    zone(
      "runnyeye",
      "Runnyeye",
      "runnyeye",
      "Clan Runnyeye",
      "Runnyeye.md",
      "Clan Runnyeye unique drops (1.33× XP).",
    ),
    zone(
      "cazic-thule",
      "Cazic-Thule",
      "cazicthule",
      "Lost Temple of Cazic-Thule",
      "Cazic-Thule.md",
      "Cazic-Thule nameds, unique loot, and quest NPCs (Accursed Temple / IdleQuest).",
    ),
    zone(
      "splitpaw",
      "Splitpaw",
      "paw",
      "Splitpaw Lair",
      "Splitpaw.md",
      "Splitpaw Lair unique drops (0.90× XP).",
    ),
  ]
}

fn classic_dungeon() -> List(Sample) {
  [
    zone(
      "soluseks-eye",
      "Solusek's Eye",
      "soldunga",
      "Solusek's Eye",
      "Soluseks-Eye.md",
      "Solusek's Eye unique drops (1.73× XP).",
    ),
    zone(
      "the-hole",
      "The Hole",
      "hole",
      "The Hole",
      "The-Hole.md",
      "The Hole unique drops (1.33× XP).",
    ),
    zone(
      "kedge-keep",
      "Kedge Keep",
      "kedge",
      "Kedge Keep",
      "Kedge-Keep.md",
      "Kedge Keep unique drops (1.33× XP).",
    ),
    zone(
      "mistmoore",
      "Mistmoore",
      "mistmoore",
      "Castle Mistmoore",
      "Mistmoore.md",
      "Castle Mistmoore unique drops (1.20× XP).",
    ),
    zone(
      "permafrost",
      "Permafrost",
      "permafrost",
      "Permafrost Keep",
      "Permafrost.md",
      "Permafrost Keep unique drops (1.20× XP).",
    ),
    zone(
      "lower-guk",
      "Lower Guk",
      "gukbottom",
      "Lower Guk",
      "Lower-Guk.md",
      "Lower Guk unique drops (1.06× XP).",
    ),
    zone(
      "nagafens-lair",
      "Nagafen's Lair",
      "soldungb",
      "Nagafen's Lair",
      "Nagafens-Lair.md",
      "Nagafen's Lair unique drops (1.06× XP).",
    ),
    zone(
      "plane-of-fear",
      "Plane of Fear",
      "fearplane",
      "Plane of Fear",
      "Plane-of-Fear.md",
      "Plane of Fear nameds and unique loot (1.13× XP).",
    ),
    zone(
      "plane-of-hate",
      "Plane of Hate",
      "hateplaneb",
      "Plane of Hate",
      "Plane-of-Hate.md",
      "Plane of Hate nameds and unique loot (1.13× XP).",
    ),
    zone(
      "plane-of-sky",
      "Plane of Sky",
      "airplane",
      "Plane of Sky",
      "Plane-of-Sky.md",
      "Plane of Sky islands, keys, and unique loot (1.13× XP).",
    ),
  ]
}

fn kunark_towns() -> List(Sample) {
  []
}

fn kunark_solo() -> List(Sample) {
  [
    zone(
      "burning-woods",
      "Burning Woods",
      "burningwood",
      "The Burning Wood",
      "Burning-Woods.md",
      "Burning Woods nameds, unique loot, and quest NPCs (Kunark).",
    ),
    zone(
      "dreadlands",
      "Dreadlands",
      "dreadlands",
      "Dreadlands",
      "Dreadlands.md",
      "Dreadlands nameds, unique loot, and quest NPCs (Kunark).",
    ),
    zone(
      "emerald-jungle",
      "Emerald Jungle",
      "emeraldjungle",
      "The Emerald Jungle",
      "Emerald-Jungle.md",
      "Emerald Jungle nameds, unique loot, and quest NPCs (Kunark).",
    ),
    zone(
      "field-of-bone",
      "Field of Bone",
      "fieldofbone",
      "The Field of Bone",
      "Field-of-Bone.md",
      "Field of Bone nameds and Cabilis outdoor uniques (1.00× XP).",
    ),
    zone(
      "frontier-mountains",
      "Frontier Mtns",
      "frontiermtns",
      "Frontier Mountains",
      "Frontier-Mountains.md",
      "Frontier Mountains nameds, unique loot, and quest NPCs (Kunark).",
    ),
    zone(
      "lake-of-ill-omen",
      "Lake of Ill Omen",
      "lakeofillomen",
      "Lake of Ill Omen",
      "Lake-of-Ill-Omen.md",
      "Lake of Ill Omen sarnak / goblin / bloodgill camps and outpost caution (1.00× XP).",
    ),
    zone(
      "overthere",
      "Overthere",
      "overthere",
      "The Overthere",
      "Overthere.md",
      "Overthere sarnak / cockatrice / scorpikis camps and dark-elf outpost caution (1.00× XP).",
    ),
    zone(
      "trakanons-teeth",
      "Trak",
      "trakanon",
      "Trakanon's Teeth",
      "Trakanons-Teeth.md",
      "Trakanon's Teeth forager, hunter, and trash drops.",
    ),
    zone(
      "warsliks-woods",
      "Warsliks",
      "warslikswood",
      "Warsliks Woods",
      "Warsliks-Woods.md",
      "Warsliks Woods goblin / forest giant camps (1.00× XP).",
    ),
    zone(
      "kurns-tower",
      "Kurn's Tower",
      "kurn",
      "Kurn's Tower",
      "Kurns-Tower.md",
      "Kurn's Tower unique drops (2.00× XP).",
    ),
    zone(
      "dalnir",
      "Dalnir",
      "dalnir",
      "Crypt of Dalnir",
      "Dalnir.md",
      "Crypt of Dalnir unique drops (1.13× XP).",
    ),
    zone(
      "skyfire",
      "Skyfire",
      "skyfire",
      "Skyfire Mountains",
      "Skyfire.md",
      "Skyfire Mountains unique drops (1.06× XP).",
    ),
    zone(
      "temple-of-droga",
      "Temple of Droga",
      "droga",
      "Temple of Droga",
      "Temple-of-Droga.md",
      "Temple of Droga unique drops (0.95× XP).",
    ),
    zone(
      "mines-of-nurga",
      "Mines of Nurga",
      "nurga",
      "Mines of Nurga",
      "Mines-of-Nurga.md",
      "Mines of Nurga unique drops (0.95× XP).",
    ),
    zone(
      "city-of-mist",
      "City of Mist",
      "citymist",
      "The City of Mist",
      "City-of-Mist.md",
      "City of Mist unique drops (0.85× XP).",
    ),
  ]
}

fn kunark_dungeon() -> List(Sample) {
  [
    zone(
      "sebilis",
      "Sebilis",
      "sebilis",
      "Old Sebilis",
      "Sebilis.md",
      "Old Sebilis unique drops (2.50× XP).",
    ),
    zone(
      "veeshans-peak",
      "Veeshan's Peak",
      "veeshan",
      "Veeshan's Peak",
      "Veeshans-Peak.md",
      "Veeshan's Peak raid unique drops.",
    ),
    zone(
      "chardok",
      "Chardok",
      "chardok",
      "Chardok",
      "Chardok.md",
      "Chardok unique drops (1.50× XP).",
    ),
    zone(
      "kaesora",
      "Kaesora",
      "kaesora",
      "Kaesora",
      "Kaesora.md",
      "Kaesora unique drops (1.46× XP).",
    ),
    zone(
      "karnors-castle",
      "Karnor's Castle",
      "karnor",
      "Karnor's Castle",
      "Karnors-Castle.md",
      "Karnor's Castle unique drops (1.13× XP).",
    ),
    zone(
      "howling-stones",
      "Howling Stones",
      "charasis",
      "Howling Stones",
      "Howling-Stones.md",
      "Howling Stones unique drops (1.13× XP).",
    ),
  ]
}

fn velious_towns() -> List(Sample) {
  [
    zone(
      "icewell-keep",
      "Icewell",
      "thurgadinb",
      "Icewell Keep",
      "Icewell-Keep.md",
      "Icewell Keep nameds, Dain RAID loot, and Coldain faction warnings (Velious).",
    ),
    zone(
      "kael-drakkel",
      "Kael",
      "kael",
      "Kael Drakkel",
      "Kael-Drakkel.md",
      "Kael Drakkel nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "skyshrine",
      "Skyshrine",
      "skyshrine",
      "Skyshrine",
      "Skyshrine.md",
      "Skyshrine nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "thurgadin",
      "Thurgadin",
      "thurgadina",
      "Thurgadin",
      "Thurgadin.md",
      "Thurgadin Coldain hub, armor turn-ins, and faction warnings (Velious).",
    ),
  ]
}

fn velious_solo() -> List(Sample) {
  [
    zone(
      "cobalt-scar",
      "Cobalt Scar",
      "cobaltscar",
      "Cobalt Scar",
      "Cobalt-Scar.md",
      "Cobalt Scar nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "crystal-caverns",
      "Crystal Caverns",
      "crystal",
      "Crystal Caverns",
      "Crystal-Caverns.md",
      "Crystal Caverns unique drops (Velious).",
    ),
    zone(
      "eastern-wastes",
      "Eastern Wastes",
      "eastwastes",
      "Eastern Wastes",
      "Eastern-Wastes.md",
      "Eastern Wastes nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "great-divide",
      "Great Divide",
      "greatdivide",
      "The Great Divide",
      "Great-Divide.md",
      "Great Divide nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "iceclad-ocean",
      "Iceclad Ocean",
      "iceclad",
      "Iceclad Ocean",
      "Iceclad-Ocean.md",
      "Iceclad Ocean nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "wakening-land",
      "Wakening Land",
      "wakening",
      "The Wakening Land",
      "Wakening-Land.md",
      "Wakening Land nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "western-wastes",
      "Western Wastes",
      "westwastes",
      "Western Wastes",
      "Western-Wastes.md",
      "Western Wastes nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "plane-of-growth",
      "PoGrowth",
      "growthplane",
      "Plane of Growth",
      "Plane-of-Growth.md",
      "Plane of Growth nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "plane-of-mischief",
      "PoMischief",
      "mischiefplane",
      "Plane of Mischief",
      "Plane-of-Mischief.md",
      "Plane of Mischief nameds, unique loot, and quest NPCs (Velious).",
    ),
  ]
}

fn velious_dungeon() -> List(Sample) {
  [
    zone(
      "dragon-necropolis",
      "Dragon Necropolis",
      "necropolis",
      "Dragon Necropolis",
      "Dragon-Necropolis.md",
      "Dragon Necropolis nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "sirens-grotto",
      "Siren's Grotto",
      "sirens",
      "Siren's Grotto",
      "Sirens-Grotto.md",
      "Siren's Grotto nameds, unique loot, and quest NPCs (Velious).",
    ),
    zone(
      "temple-of-veeshan",
      "Temple of Veeshan",
      "templeveeshan",
      "The Temple of Veeshan",
      "Temple-of-Veeshan.md",
      "Temple of Veeshan RAID halls, molds, and dragon uniques (Velious).",
    ),
    zone(
      "tower-of-frozen-shadow",
      "Frozen Shadow",
      "frozenshadow",
      "Tower of Frozen Shadow",
      "Tower-of-Frozen-Shadow.md",
      "Tower of Frozen Shadow unique drops (Velious).",
    ),
    zone(
      "velketors-labyrinth",
      "Velketor's",
      "velketor",
      "Velketor's Labyrinth",
      "Velketors-Labyrinth.md",
      "Velketor's Labyrinth unique drops (Velious).",
    ),
  ]
}

fn everquest_warrior() -> List(Sample) {
  [
    sheet(
      "warrior-chests",
      "Chests",
      "everquest/byClass",
      "Warrior-Chests.md",
      "Groupable warrior chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "warrior-boots",
      "Boots",
      "everquest/byClass",
      "Warrior-Boots.md",
      "Groupable warrior boots (Classic / Kunark / Velious).",
    ),
    sheet(
      "warrior-earrings",
      "Earrings",
      "everquest/byClass",
      "Warrior-Earrings.md",
      "Groupable warrior earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_cleric() -> List(Sample) {
  [
    sheet(
      "cleric-chests",
      "Chests",
      "everquest/byClass",
      "Cleric-Chests.md",
      "Groupable cleric chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "cleric-earrings",
      "Earrings",
      "everquest/byClass",
      "Cleric-Earrings.md",
      "Groupable cleric earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_druid() -> List(Sample) {
  [
    sheet(
      "druid-chests",
      "Chests",
      "everquest/byClass",
      "Druid-Chests.md",
      "Groupable druid chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "druid-earrings",
      "Earrings",
      "everquest/byClass",
      "Druid-Earrings.md",
      "Groupable druid earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_monk() -> List(Sample) {
  [
    sheet(
      "monk-chests",
      "Chests",
      "everquest/byClass",
      "Monk-Chests.md",
      "Groupable monk chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "monk-boots",
      "Boots",
      "everquest/byClass",
      "Monk-Boots.md",
      "Groupable monk boots (Classic / Kunark / Velious).",
    ),
    sheet(
      "monk-earrings",
      "Earrings",
      "everquest/byClass",
      "Monk-Earrings.md",
      "Groupable monk earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_ranger() -> List(Sample) {
  [
    sheet(
      "ranger-bows",
      "Bows",
      "everquest/byClass",
      "Ranger-Bows.md",
      "Groupable ranger bows (Classic / Kunark / Velious).",
    ),
    sheet(
      "ranger-earrings",
      "Earrings",
      "everquest/byClass",
      "Ranger-Earrings.md",
      "Groupable ranger earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_rogue() -> List(Sample) {
  [
    sheet(
      "rogue-main-hand",
      "Main Hand",
      "everquest/byClass",
      "Rogue-Main-Hand.md",
      "Groupable rogue piercing main hands (Classic / Kunark / Velious).",
    ),
    sheet(
      "rogue-earrings",
      "Earrings",
      "everquest/byClass",
      "Rogue-Earrings.md",
      "Groupable rogue earrings (Classic / Kunark / Velious).",
    ),
    sheet(
      "rogue-face",
      "Face",
      "everquest/byClass",
      "Rogue-Face.md",
      "Groupable rogue face items (Classic / Kunark / Velious).",
    ),
    sheet(
      "rogue-legs",
      "Legs",
      "everquest/byClass",
      "Rogue-Legs.md",
      "Groupable rogue legs (Classic / Kunark / Velious).",
    ),
    sheet(
      "rogue-feet",
      "Feet",
      "everquest/byClass",
      "Rogue-Feet.md",
      "Groupable rogue feet (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_shaman() -> List(Sample) {
  [
    sheet(
      "shaman-chests",
      "Chests",
      "everquest/byClass",
      "Shaman-Chests.md",
      "Groupable shaman chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "shaman-earrings",
      "Earrings",
      "everquest/byClass",
      "Shaman-Earrings.md",
      "Groupable shaman earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_wizard() -> List(Sample) {
  [
    sheet(
      "wizard-chests",
      "Chests",
      "everquest/byClass",
      "Wizard-Chests.md",
      "Groupable wizard chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "wizard-earrings",
      "Earrings",
      "everquest/byClass",
      "Wizard-Earrings.md",
      "Groupable wizard earrings (Classic / Kunark / Velious).",
    ),
  ]
}

fn zone(
  id: String,
  label: String,
  shortname: String,
  fullname: String,
  file: String,
  blurb: String,
) -> Sample {
  Sample(
    id: id,
    label: label,
    shortname: shortname,
    fullname: fullname,
    folder: "everquest/zone",
    file: file,
    blurb: blurb,
  )
}

fn sheet(
  id: String,
  label: String,
  folder: String,
  file: String,
  blurb: String,
) -> Sample {
  Sample(
    id: id,
    label: label,
    shortname: "",
    fullname: "",
    folder: folder,
    file: file,
    blurb: blurb,
  )
}

pub fn groups() -> List(SampleGroup) {
  [
    everquest_group(),
    SampleGroup(
      id: "palworld",
      label: "Palworld",
      samples: palworld(),
      buckets: [],
    ),
  ]
}

pub fn url(sample: Sample) -> String {
  "./samples/" <> sample.folder <> "/" <> sample.file
}

pub fn breeding_sheet_url() -> String {
  "./samples/palworld/Breeding-Sheet.md"
}

pub fn is_palworld(sample: Sample) -> Bool {
  sample.folder == "palworld"
}

pub fn is_zone(sample: Sample) -> Bool {
  sample.shortname != ""
}

/// Zone XP chart hunt band for this sample's shortname, if listed.
pub fn hunt_levels(sample: Sample) -> String {
  case sample.shortname {
    "" -> ""
    short ->
      case dict.get(zone_xp_hunt_levels(), short) {
        Ok(levels) -> levels
        Error(_) -> ""
      }
  }
}

/// Top-of-page meta line: label, Zone XP hunt band when known, then blurb.
pub fn meta_line(sample: Sample) -> String {
  case hunt_levels(sample) {
    "" -> "Sample: " <> sample.label <> " — " <> sample.blurb
    "hub" ->
      "Sample: " <> sample.label <> " — Quest hub. " <> sample.blurb
    levels ->
      "Sample: "
      <> sample.label
      <> " — Hunt "
      <> levels
      <> ". "
      <> sample.blurb
  }
}

/// Shortname → hunt levels from Zone XP sheets / zone blurbs (asterisks stripped).
fn zone_xp_hunt_levels() -> Dict(String, String) {
  dict.from_list([
    #("airplane", "46–60"),
    #("befallen", "7–25"),
    #("beholder", "6–35"),
    #("blackburrow", "4–15"),
    #("burningwood", "35–50+"),
    #("cazicthule", "19–45"),
    #("charasis", "50–60"),
    #("chardok", "50–60"),
    #("citymist", "40–55"),
    #("cobaltscar", "35–50+"),
    #("crushbone", "5–20"),
    #("crystal", "25–45"),
    #("dalnir", "25–40"),
    #("dreadlands", "25–45+"),
    #("droga", "30–40"),
    #("eastwastes", "30–45"),
    #("emeraldjungle", "30–50+"),
    #("fearplane", "50–60"),
    #("fieldofbone", "1–25"),
    #("frozenshadow", "30–50"),
    #("frontiermtns", "20–40+"),
    #("greatdivide", "30–50"),
    #("growthplane", "55+"),
    #("gukbottom", "30–50"),
    #("guktop", "4–25"),
    #("hateplaneb", "48–60"),
    #("highkeep", "20–40"),
    #("highpass", "9–22"),
    #("hole", "40–60"),
    #("iceclad", "25–40+"),
    #("kael", "40–60+"),
    #("kaesora", "30–45"),
    #("karnor", "40–55"),
    #("kedge", "32–50"),
    #("kurn", "10–25"),
    #("lakeofillomen", "10–40"),
    #("lavastorm", "10–30"),
    #("mischiefplane", "50+"),
    #("mistmoore", "20–45"),
    #("najena", "8–35"),
    #("necropolis", "45–60+"),
    #("nurga", "30–40"),
    #("oot", "9–35"),
    #("overthere", "15–45"),
    #("paw", "20–40"),
    #("permafrost", "15–50"),
    #("runnyeye", "7–30"),
    #("sebilis", "48–60"),
    #("sirens", "45–60+"),
    #("skyfire", "45–60"),
    #("skyshrine", "35–60+"),
    #("soldunga", "20–40"),
    #("soldungb", "35–55"),
    #("templeveeshan", "60+"),
    #("thurgadina", "30–45"),
    #("thurgadinb", "45–60+"),
    #("trakanon", "40–60+"),
    #("unrest", "10–35"),
    #("veeshan", "60+"),
    #("velketor", "40–60"),
    #("wakening", "40–55+"),
    #("warslikswood", "10–35"),
    #("westwastes", "50–60+"),
  ])
}

fn zone_xp_multipliers() -> Dict(String, String) {
  dict.from_list([
    #("airplane", "1.13×"),
    #("befallen", "2.13×"),
    #("beholder", "1.00×"),
    #("blackburrow", "1.33×"),
    #("burningwood", "0.83×"),
    #("cazicthule", "1.13×"),
    #("charasis", "1.13×"),
    #("chardok", "1.50×"),
    #("citymist", "0.85×"),
    #("cobaltscar", "1.00×"),
    #("crushbone", "2.13×"),
    #("crystal", "1.47×"),
    #("dalnir", "1.13×"),
    #("dreadlands", "1.00×"),
    #("droga", "0.95×"),
    #("eastwastes", "1.00×"),
    #("emeraldjungle", "0.83×"),
    #("fearplane", "1.13×"),
    #("fieldofbone", "1.00×"),
    #("frozenshadow", "1.00×"),
    #("frontiermtns", "1.00×"),
    #("greatdivide", "1.00×"),
    #("growthplane", "1.20×"),
    #("gukbottom", "1.06×"),
    #("guktop", "2.00×"),
    #("hateplaneb", "1.13×"),
    #("highkeep", "2.00×"),
    #("highpass", "1.06×"),
    #("hole", "1.33×"),
    #("iceclad", "1.00×"),
    #("kael", "1.13×"),
    #("kaesora", "1.46×"),
    #("karnor", "1.13×"),
    #("kedge", "1.33×"),
    #("kurn", "2.00×"),
    #("lakeofillomen", "1.00×"),
    #("lavastorm", "0.75×"),
    #("mischiefplane", "1.40×"),
    #("mistmoore", "1.20×"),
    #("najena", "1.73×"),
    #("necropolis", "1.50×"),
    #("nurga", "0.95×"),
    #("oot", "1.13×"),
    #("overthere", "1.00×"),
    #("paw", "0.90×"),
    #("permafrost", "1.20×"),
    #("runnyeye", "1.33×"),
    #("sebilis", "2.50×"),
    #("sirens", "0.85×"),
    #("skyfire", "1.06×"),
    #("skyshrine", "1.13×"),
    #("soldunga", "1.73×"),
    #("soldungb", "1.06×"),
    #("templeveeshan", "1.00×"),
    #("trakanon", "1.00×"),
    #("unrest", "1.73×"),
    #("veeshan", "1.00×"),
    #("velketor", "1.00×"),
    #("wakening", "1.00×"),
    #("warslikswood", "1.00×"),
    #("westwastes", "1.06×"),
  ])
}

/// Shortnames where auto-level can hit friendlies / faction NPCs (Zone XP `*`).
fn zone_friendly_shortnames() -> List(String) {
  [
    "airplane", "cobaltscar", "crushbone", "crystal", "droga", "growthplane",
    "highkeep", "highpass", "kerraridge", "lakeofillomen", "najena", "nurga",
    "oot", "overthere", "soldunga", "soltemple", "thurgadina", "thurgadinb",
  ]
}

pub fn is_everquest_nav(group: SampleGroup) -> Bool {
  group.id == "everquest"
}

pub fn is_all_nav(group: SampleGroup) -> Bool {
  group.id == "eq-all"
}

pub fn is_by_class_nav(group: SampleGroup) -> Bool {
  group.id == "eq-by-class"
}

/// True when the sample lives under EverQuest → byClass (class gear sheets).
pub fn is_by_class_sample(sample: Sample) -> Bool {
  case list.find(everquest_group().buckets, is_by_class_nav) {
    Ok(by_class) -> group_contains(by_class, sample)
    Error(_) -> False
  }
}

/// EverQuest hunt / town zone samples (excludes Zone XP, quest gear, byClass).
pub fn everquest_zones() -> List(Sample) {
  group_samples(everquest_group())
  |> list.filter(is_zone)
}

/// Case-insensitive substring match on shortname or fullname. Needs 2+ chars.
pub fn matches_zone_query(sample: Sample, query: String) -> Bool {
  let needle = string.lowercase(string.trim(query))
  case string.length(needle) < 2 || !is_zone(sample) {
    True -> False
    False ->
      string.contains(string.lowercase(sample.shortname), needle)
      || string.contains(string.lowercase(sample.fullname), needle)
      || string.contains(string.lowercase(sample.label), needle)
  }
}

pub fn search_zones(query: String) -> List(Sample) {
  list.filter(everquest_zones(), fn(sample) { matches_zone_query(sample, query) })
}

pub fn group_contains(group: SampleGroup, sample: Sample) -> Bool {
  list.any(group_samples(group), fn(member) { member.id == sample.id })
}

pub fn group_samples(group: SampleGroup) -> List(Sample) {
  list.append(
    group.samples,
    list.flatten(list.map(group.buckets, group_samples)),
  )
}

pub fn find(id: String) -> Result(Sample, Nil) {
  find_loop(list.flatten(list.map(groups(), group_samples)), id)
}

/// Zone XP `*` = auto-level / auto-attack can hit friendlies in that zone.
const zone_xp_asterisk_note: String = "Auto-level systems that attack anything near your level can hit friendly NPCs here: city merchants, guards, and trainers; quest givers (Plane of Sky islands, Najena captives, Solusek Ro temple); mixed outdoor camps (Highpass Hold, High Keep, Kerra Isle, Ocean of Tears Sister Isle, Lake of Ill Omen outpost, Overthere dark-elf outpost, Cobalt Scar Othmir, Plane of Growth Tunareans, Crystal Caverns Froststone); Thurgadin / Icewell Coldain; gnome miners in Solusek's Eye; or faction slaves in Crushbone, Droga, and Nurga."

/// Per-sample table formatting. Palworld uses breeding-sheet elements for Pal
/// name tooltips when an index is available. Zone XP marks `*` cells with a
/// friendly-NPC caution tooltip (prose footnotes are not rendered — only tables).
pub fn table_formatter(
  sample: Sample,
  elements: Dict(String, String),
) -> TableFormatter {
  case is_palworld(sample) {
    True ->
      palworld_default()
      |> pal_index.with_pal_element_tooltips(elements)
    False ->
      case sample.id {
        "zone-xp-modifiers" | "zone-index" ->
          table_format.plain()
          |> table_format.with_trailing_asterisk_tooltip(zone_xp_asterisk_note)
        _ -> table_format.plain()
      }
  }
}

fn palworld_default() -> TableFormatter {
  table_format.plain()
  |> table_format.decorate_all([
    table_format.style_empty_cells,
    table_format.style_approximate_numbers,
  ])
}

fn find_loop(samples: List(Sample), id: String) -> Result(Sample, Nil) {
  case samples {
    [] -> Error(Nil)
    [sample, ..] if sample.id == id -> Ok(sample)
    [_, ..rest] -> find_loop(rest, id)
  }
}
