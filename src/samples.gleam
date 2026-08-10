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

pub fn find(id: String) -> Result(Sample, Nil) {
  find_loop(all(), id)
}

fn find_loop(samples: List(Sample), id: String) -> Result(Sample, Nil) {
  case samples {
    [] -> Error(Nil)
    [sample, .._rest] if sample.id == id -> Ok(sample)
    [_, ..rest] -> find_loop(rest, id)
  }
}
