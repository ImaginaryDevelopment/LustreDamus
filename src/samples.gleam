import gleam/dict.{type Dict}
import pal_index
import table_format.{type TableFormatter}

/// Palworld Markdown samples shipped with the static site.
pub type Sample {
  Sample(id: String, label: String, file: String, blurb: String)
}

pub fn all() -> List(Sample) {
  [
    Sample(
      id: "mounts",
      label: "Mounts",
      file: "Mounts.md",
      blurb: "Rideable Pals by speed, stamina, and saddles.",
    ),
    Sample(
      id: "mining-pals",
      label: "Mining Pals",
      file: "Mining-Pals.md",
      blurb: "Miners plus carry weight and mining-speed helpers.",
    ),
    Sample(
      id: "breeding-sheet",
      label: "Breeding Sheet",
      file: "Breeding-Sheet.md",
      blurb: "Paldex IDs, elements, breed rank, and traits.",
    ),
    Sample(
      id: "player-damage-conversion",
      label: "Damage Conversion",
      file: "Player-Damage-Conversion.md",
      blurb: "Pals that convert your attack element.",
    ),
    Sample(
      id: "early-game-skill-fruits",
      label: "Skill Fruits",
      file: "Early-Game-Skill-Fruits.md",
      blurb: "Early Skill Fruits to chase and where to farm them.",
    ),
  ]
}

pub fn url(sample: Sample) -> String {
  "./samples/palworld/" <> sample.file
}

pub fn breeding_sheet_url() -> String {
  "./samples/palworld/Breeding-Sheet.md"
}

pub fn find(id: String) -> Result(Sample, Nil) {
  find_loop(all(), id)
}

/// Per-sample table formatting. Uses breeding-sheet elements for Pal name tooltips
/// when an index is available.
pub fn table_formatter(
  sample: Sample,
  elements: Dict(String, String),
) -> TableFormatter {
  let _ = sample
  palworld_default()
  |> pal_index.with_pal_element_tooltips(elements)
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
