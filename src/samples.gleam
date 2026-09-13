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

pub fn find(id: String) -> Result(Sample, Nil) {
  find_loop(list.append(palworld(), everquest()), id)
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
