import gleam/dict.{type Dict}
import gleam/list
import pal_index
import table_format.{type TableFormatter}

/// Markdown samples shipped with the static site.
pub type Sample {
  Sample(id: String, label: String, folder: String, file: String, blurb: String)
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
    Sample(
      id: "mounts",
      label: "Mounts",
      folder: "palworld",
      file: "Mounts.md",
      blurb: "Rideable Pals by speed, stamina, and saddles.",
    ),
    Sample(
      id: "mining-pals",
      label: "Mining Pals",
      folder: "palworld",
      file: "Mining-Pals.md",
      blurb: "Miners plus carry weight and mining-speed helpers.",
    ),
    Sample(
      id: "breeding-sheet",
      label: "Breeding Sheet",
      folder: "palworld",
      file: "Breeding-Sheet.md",
      blurb: "Paldex IDs, elements, breed rank, and traits.",
    ),
    Sample(
      id: "player-damage-conversion",
      label: "Damage Conversion",
      folder: "palworld",
      file: "Player-Damage-Conversion.md",
      blurb: "Pals that convert your attack element.",
    ),
    Sample(
      id: "early-game-skill-fruits",
      label: "Skill Fruits",
      folder: "palworld",
      file: "Early-Game-Skill-Fruits.md",
      blurb: "Early Skill Fruits to chase and where to farm them.",
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
      SampleGroup(
        id: "eq-classic",
        label: "Classic",
        samples: everquest_classic(),
        buckets: [],
      ),
      SampleGroup(
        id: "eq-kunark",
        label: "Kunark",
        samples: everquest_kunark(),
        buckets: [],
      ),
      SampleGroup(
        id: "eq-velious",
        label: "Velious",
        samples: everquest_velious(),
        buckets: [],
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

fn quest_gear_sample() -> Sample {
  Sample(
    id: "quest-gear",
    label: "Quest Gear",
    folder: "everquest",
    file: "Quest-Gear.md",
    blurb: "Turn-in armor and loot to save for gear (Classic / Kunark / Velious).",
  )
}

fn zone_xp_sample() -> Sample {
  Sample(
    id: "zone-xp-modifiers",
    label: "Zone XP",
    folder: "everquest",
    file: "Zone-XP-Modifiers.md",
    blurb: "Classic zone experience multipliers by shortname.",
  )
}

fn everquest_classic() -> List(Sample) {
  [
    Sample(
      id: "befallen",
      label: "Befallen",
      folder: "everquest",
      file: "Befallen.md",
      blurb: "Befallen unique drops (2.13× XP).",
    ),
    Sample(
      id: "crushbone",
      label: "Crushbone",
      folder: "everquest",
      file: "Crushbone.md",
      blurb: "Crushbone unique drops (2.13× XP).",
    ),
    Sample(
      id: "upper-guk",
      label: "Upper Guk",
      folder: "everquest",
      file: "Upper-Guk.md",
      blurb: "Upper Guk unique drops (2.00× XP).",
    ),
    Sample(
      id: "high-keep",
      label: "High Keep",
      folder: "everquest",
      file: "High-Keep.md",
      blurb: "High Keep unique drops (2.00× XP).",
    ),
    Sample(
      id: "najena",
      label: "Najena",
      folder: "everquest",
      file: "Najena.md",
      blurb: "Najena unique drops (1.73× XP).",
    ),
    Sample(
      id: "soluseks-eye",
      label: "Solusek's Eye",
      folder: "everquest",
      file: "Soluseks-Eye.md",
      blurb: "Solusek's Eye unique drops (1.73× XP).",
    ),
    Sample(
      id: "unrest",
      label: "Unrest",
      folder: "everquest",
      file: "Unrest.md",
      blurb: "Estate of Unrest unique drops (1.73× XP).",
    ),
    Sample(
      id: "blackburrow",
      label: "Blackburrow",
      folder: "everquest",
      file: "Blackburrow.md",
      blurb: "Blackburrow unique drops (1.33× XP).",
    ),
    Sample(
      id: "the-hole",
      label: "The Hole",
      folder: "everquest",
      file: "The-Hole.md",
      blurb: "The Hole unique drops (1.33× XP).",
    ),
    Sample(
      id: "kedge-keep",
      label: "Kedge Keep",
      folder: "everquest",
      file: "Kedge-Keep.md",
      blurb: "Kedge Keep unique drops (1.33× XP).",
    ),
    Sample(
      id: "runnyeye",
      label: "Runnyeye",
      folder: "everquest",
      file: "Runnyeye.md",
      blurb: "Clan Runnyeye unique drops (1.33× XP).",
    ),
    Sample(
      id: "mistmoore",
      label: "Mistmoore",
      folder: "everquest",
      file: "Mistmoore.md",
      blurb: "Castle Mistmoore unique drops (1.20× XP).",
    ),
    Sample(
      id: "permafrost",
      label: "Permafrost",
      folder: "everquest",
      file: "Permafrost.md",
      blurb: "Permafrost Keep unique drops (1.20× XP).",
    ),
    Sample(
      id: "cazic-thule",
      label: "Cazic-Thule",
      folder: "everquest",
      file: "Cazic-Thule.md",
      blurb: "Lost Temple of Cazic-Thule unique drops (1.13× XP).",
    ),
    Sample(
      id: "lower-guk",
      label: "Lower Guk",
      folder: "everquest",
      file: "Lower-Guk.md",
      blurb: "Lower Guk unique drops (1.06× XP).",
    ),
    Sample(
      id: "nagafens-lair",
      label: "Nagafen's Lair",
      folder: "everquest",
      file: "Nagafens-Lair.md",
      blurb: "Nagafen's Lair unique drops (1.06× XP).",
    ),
    Sample(
      id: "splitpaw",
      label: "Splitpaw",
      folder: "everquest",
      file: "Splitpaw.md",
      blurb: "Splitpaw Lair unique drops (0.90× XP).",
    ),
  ]
}

fn everquest_kunark() -> List(Sample) {
  [
    Sample(
      id: "sebilis",
      label: "Sebilis",
      folder: "everquest",
      file: "Sebilis.md",
      blurb: "Old Sebilis unique drops (2.50× XP).",
    ),
    Sample(
      id: "veeshans-peak",
      label: "Veeshan's Peak",
      folder: "everquest",
      file: "Veeshans-Peak.md",
      blurb: "Veeshan's Peak raid unique drops.",
    ),
    Sample(
      id: "trakanons-teeth",
      label: "Trak",
      folder: "everquest",
      file: "Trakanons-Teeth.md",
      blurb: "Trakanon's Teeth forager, hunter, and trash drops.",
    ),
    Sample(
      id: "kurns-tower",
      label: "Kurn's Tower",
      folder: "everquest",
      file: "Kurns-Tower.md",
      blurb: "Kurn's Tower unique drops (2.00× XP).",
    ),
    Sample(
      id: "chardok",
      label: "Chardok",
      folder: "everquest",
      file: "Chardok.md",
      blurb: "Chardok unique drops (1.50× XP).",
    ),
    Sample(
      id: "kaesora",
      label: "Kaesora",
      folder: "everquest",
      file: "Kaesora.md",
      blurb: "Kaesora unique drops (1.46× XP).",
    ),
    Sample(
      id: "karnors-castle",
      label: "Karnor's Castle",
      folder: "everquest",
      file: "Karnors-Castle.md",
      blurb: "Karnor's Castle unique drops (1.13× XP).",
    ),
    Sample(
      id: "howling-stones",
      label: "Howling Stones",
      folder: "everquest",
      file: "Howling-Stones.md",
      blurb: "Howling Stones unique drops (1.13× XP).",
    ),
    Sample(
      id: "dalnir",
      label: "Dalnir",
      folder: "everquest",
      file: "Dalnir.md",
      blurb: "Crypt of Dalnir unique drops (1.13× XP).",
    ),
    Sample(
      id: "skyfire",
      label: "Skyfire",
      folder: "everquest",
      file: "Skyfire.md",
      blurb: "Skyfire Mountains unique drops (1.06× XP).",
    ),
    Sample(
      id: "temple-of-droga",
      label: "Temple of Droga",
      folder: "everquest",
      file: "Temple-of-Droga.md",
      blurb: "Temple of Droga unique drops (0.95× XP).",
    ),
    Sample(
      id: "mines-of-nurga",
      label: "Mines of Nurga",
      folder: "everquest",
      file: "Mines-of-Nurga.md",
      blurb: "Mines of Nurga unique drops (0.95× XP).",
    ),
    Sample(
      id: "city-of-mist",
      label: "City of Mist",
      folder: "everquest",
      file: "City-of-Mist.md",
      blurb: "City of Mist unique drops (0.85× XP).",
    ),
  ]
}

fn everquest_velious() -> List(Sample) {
  [
    Sample(
      id: "tower-of-frozen-shadow",
      label: "Frozen Shadow",
      folder: "everquest",
      file: "Tower-of-Frozen-Shadow.md",
      blurb: "Tower of Frozen Shadow unique drops (Velious).",
    ),
    Sample(
      id: "crystal-caverns",
      label: "Crystal Caverns",
      folder: "everquest",
      file: "Crystal-Caverns.md",
      blurb: "Crystal Caverns unique drops (Velious).",
    ),
    Sample(
      id: "velketors-labyrinth",
      label: "Velketor's",
      folder: "everquest",
      file: "Velketors-Labyrinth.md",
      blurb: "Velketor's Labyrinth unique drops (Velious).",
    ),
    Sample(
      id: "plane-of-growth",
      label: "PoGrowth",
      folder: "everquest",
      file: "Plane-of-Growth.md",
      blurb: "Plane of Growth nameds, unique loot, and quest NPCs (Velious).",
    ),
    Sample(
      id: "plane-of-mischief",
      label: "PoMischief",
      folder: "everquest",
      file: "Plane-of-Mischief.md",
      blurb: "Plane of Mischief nameds, unique loot, and quest NPCs (Velious).",
    ),
  ]
}

fn everquest_warrior() -> List(Sample) {
  [
    Sample(
      id: "warrior-chests",
      label: "Chests",
      folder: "everquest",
      file: "Warrior-Chests.md",
      blurb: "Groupable warrior chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_cleric() -> List(Sample) {
  [
    Sample(
      id: "cleric-chests",
      label: "Chests",
      folder: "everquest",
      file: "Cleric-Chests.md",
      blurb: "Groupable cleric chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_druid() -> List(Sample) {
  [
    Sample(
      id: "druid-chests",
      label: "Chests",
      folder: "everquest",
      file: "Druid-Chests.md",
      blurb: "Groupable druid chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_monk() -> List(Sample) {
  [
    Sample(
      id: "monk-chests",
      label: "Chests",
      folder: "everquest",
      file: "Monk-Chests.md",
      blurb: "Groupable monk chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_shaman() -> List(Sample) {
  [
    Sample(
      id: "shaman-chests",
      label: "Chests",
      folder: "everquest",
      file: "Shaman-Chests.md",
      blurb: "Groupable shaman chests (Classic / Kunark / Velious).",
    ),
  ]
}

fn everquest_wizard() -> List(Sample) {
  [
    Sample(
      id: "wizard-chests",
      label: "Chests",
      folder: "everquest",
      file: "Wizard-Chests.md",
      blurb: "Groupable wizard chests (Classic / Kunark / Velious).",
    ),
  ]
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
