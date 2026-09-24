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
    samples: [zone_xp_sample(), quest_gear_sample()],
    buckets: [
      SampleGroup(id: "eq-all", label: "All", samples: [], buckets: []),
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

fn zone_xp_sample() -> Sample {
  sheet(
    "zone-xp-modifiers",
    "Zone XP",
    "everquest",
    "Zone-XP-Modifiers.md",
    "Classic zone experience multipliers by shortname.",
  )
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
      "najena",
      "Najena",
      "najena",
      "Najena",
      "Najena.md",
      "Najena unique drops (1.73× XP).",
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
      "Lost Temple of Cazic-Thule unique drops (1.13× XP).",
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
  ]
}

fn kunark_towns() -> List(Sample) {
  []
}

fn kunark_solo() -> List(Sample) {
  [
    zone(
      "trakanons-teeth",
      "Trak",
      "trakanon",
      "Trakanon's Teeth",
      "Trakanons-Teeth.md",
      "Trakanon's Teeth forager, hunter, and trash drops.",
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
  []
}

fn velious_solo() -> List(Sample) {
  [
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
      "everquest",
      "Warrior-Chests.md",
      "Groupable warrior chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "warrior-boots",
      "Boots",
      "everquest",
      "Warrior-Boots.md",
      "Groupable warrior boots (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_cleric() -> List(Sample) {
  [
    sheet(
      "cleric-chests",
      "Chests",
      "everquest",
      "Cleric-Chests.md",
      "Groupable cleric chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_druid() -> List(Sample) {
  [
    sheet(
      "druid-chests",
      "Chests",
      "everquest",
      "Druid-Chests.md",
      "Groupable druid chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_monk() -> List(Sample) {
  [
    sheet(
      "monk-chests",
      "Chests",
      "everquest",
      "Monk-Chests.md",
      "Groupable monk chests (Classic / Kunark / Velious).",
    ),
    sheet(
      "monk-boots",
      "Boots",
      "everquest",
      "Monk-Boots.md",
      "Groupable monk boots (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_shaman() -> List(Sample) {
  [
    sheet(
      "shaman-chests",
      "Chests",
      "everquest",
      "Shaman-Chests.md",
      "Groupable shaman chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_wizard() -> List(Sample) {
  [
    sheet(
      "wizard-chests",
      "Chests",
      "everquest",
      "Wizard-Chests.md",
      "Groupable wizard chests (Classic / Kunark / Velious).",
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
    folder: "everquest",
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

pub fn is_all_nav(group: SampleGroup) -> Bool {
  group.id == "eq-all"
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

/// Per-sample table formatting. Palworld uses breeding-sheet elements for Pal
/// name tooltips when an index is available.
pub fn table_formatter(
  sample: Sample,
  elements: Dict(String, String),
) -> TableFormatter {
  case is_palworld(sample) {
    True ->
      palworld_default()
      |> pal_index.with_pal_element_tooltips(elements)
    False -> table_format.plain()
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
