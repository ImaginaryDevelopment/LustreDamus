import gleam/dict.{type Dict}
import gleam/list
import pal_index
import table_format.{type TableFormatter}

/// Markdown samples shipped with the static site.
pub type Sample {
  Sample(
    id: String,
    label: String,
    folder: String,
    file: String,
    blurb: String,
  )
}

pub type SampleGroup {
  SampleGroup(id: String, label: String, samples: List(Sample))
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
  [
    Sample(
      id: "zone-xp-modifiers",
      label: "Zone XP",
      folder: "everquest",
      file: "Zone-XP-Modifiers.md",
      blurb: "Classic zone experience multipliers by shortname.",
    ),
    Sample(
      id: "sebilis",
      label: "Sebilis",
      folder: "everquest",
      file: "Sebilis.md",
      blurb: "Old Sebilis unique drops (2.50× XP).",
    ),
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
      id: "kurns-tower",
      label: "Kurn's Tower",
      folder: "everquest",
      file: "Kurns-Tower.md",
      blurb: "Kurn's Tower unique drops (2.00× XP).",
    ),
  ]
}

pub fn groups() -> List(SampleGroup) {
  [
    SampleGroup(id: "everquest", label: "EverQuest", samples: everquest()),
    SampleGroup(id: "palworld", label: "Palworld", samples: palworld()),
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
  list.any(group.samples, fn(member) { member.id == sample.id })
}

pub fn find(id: String) -> Result(Sample, Nil) {
  find_loop(list.flatten(list.map(groups(), fn(group) { group.samples })), id)
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
    [sample, .._rest] if sample.id == id -> Ok(sample)
    [_, ..rest] -> find_loop(rest, id)
  }
}
