# IdleQuest data layout — tying zones, mobs, and items

How to look up spawn and loot truth in [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) when writing or checking LustreDamus EverQuest sheets under `assets/samples/everquest/`.

**Prefer this repo over the P99 wiki alone** for “who drops what” and “where does it spawn” on IdleQuest. Wiki is still useful for lore, classic intent, and quest text. When IdleQuest and wiki disagree, **document the IdleQuest row** (and note the wiki divergence in the zone intro or Notes cell).

This snapshot is a **content export**, not a live claim about production. Treat it as the best public joinable tables we have for the browser game.

---

## 1. Get a working copy (sparse clone)

Full clone is huge. Sparse-checkout only the tables you need:

```powershell
$tmp = Join-Path $env:TEMP "idlequest-content-lookup"
if (-not (Test-Path $tmp)) {
  git clone --depth 1 --filter=blob:none --sparse https://github.com/brynnb/idlequest-content.git $tmp
  Set-Location $tmp
  git sparse-checkout set `
    data/npc_types data/items `
    data/spawn2 data/spawnentry data/spawngroup `
    data/loottable data/loottable_entries `
    data/lootdrop data/lootdrop_entries `
    data/zone
} else {
  Set-Location $tmp
  git pull --ff-only
}
```

Reuse `$tmp` across sessions. Do **not** commit IdleQuest dumps into LustreDamus; keep lookups in `%TEMP%`. Zone sheets already say `tmp_*.txt` is gitignored if you redirect greps to a file.

---

## 2. What the files look like

| Path | Role |
| --- | --- |
| `data/zone/*.ndjson` | Zone metadata (`short_name`, `long_name`, …) |
| `data/spawn2/*.ndjson` | Static spawn points in a zone (`zone`, `spawngroupID`, `y`/`x`/`z`, respawn) |
| `data/spawngroup/*.ndjson` | Spawn group meta (name, roam, …) |
| `data/spawnentry/*.ndjson` | Which NPCs can appear in a group (`spawngroupID`, `npcID`, **`chance`**) |
| `data/npc_types/*.ndjson` | NPC definition (`id`, `name`, `level`, `class`, `hp`, **`loottable_id`**) |
| `data/loottable/*.ndjson` | Loot table header |
| `data/loottable_entries/*.ndjson` | Loot table → loot drops (`loottable_id`, `lootdrop_id`, probability) |
| `data/lootdrop/*.ndjson` | Loot drop header |
| `data/lootdrop_entries/*.ndjson` | Drop → items (`lootdrop_id`, **`item_id`**, **`chance`**) |
| `data/items/*.ndjson` | Item stats (`id`, `Name`, `ac`, `classes`, damage/delay, …) |

Each `*.ndjson` file is **one JSON object per line**. Files are **hex-sharded** (many small files under each folder). Always search with a glob:

```powershell
Select-String -Path (Join-Path $tmp "data\items\*.ndjson") -Pattern '"Name":"Mask of Obtenebration"'
```

### Naming conventions

- Internal names use underscores: `Skeletal_Procurator`, `a_crypt_wurm`.
- Display on sheets: replace `_` with spaces → **Skeletal Procurator**, **a crypt wurm**.
- A leading `#` often marks a “named” / special row (`#Skeletal_Procurator`). `#` variants can be **different NPC ids** from the non-hash name.
- Names are **not** unique IDs. Always key joins on numeric `id` / `npcID` / `item_id`.

---

## 3. The join graph (zone ↔ mob ↔ item)

From the IdleQuest README, the core links are:

```
zone.short_name
  → spawn2.zone
      → spawn2.spawngroupID
          → spawnentry.spawngroupID
              → spawnentry.npcID
                  → npc_types.id
                      → npc_types.loottable_id
                          → loottable_entries.loottable_id
                              → loottable_entries.lootdrop_id
                                  → lootdrop_entries.lootdrop_id
                                      → lootdrop_entries.item_id
                                          → items.id
```

`spawngroup` sits beside `spawn2` / `spawnentry` if you need group names or roam settings. Quests use a separate `quests.(zone, name)` path — not covered in depth here; sheet quest NPCs are usually tagged **LEAVE** by hand.

**Coords:** EQ players usually list **y, x** (and sometimes z). IdleQuest `spawn2` stores `y`, `x`, `z` fields — when writing “~−90, 675”, that is typically **y, x**.

---

## 4. Recipe A — start from a zone (list nameds + loot)

Use when building or auditing a zone sheet (`assets/samples/everquest/zone/…`).

1. **Resolve shortname**  
   Search `data/zone` for the long name, or use the shortname already on the sheet (`charasis` = Howling Stones, `crystal` = Crystal Caverns, `sebilis`, `templeveeshan`, …). Sheet intros cite the shortname in parentheses on the IdleQuest link line.

2. **Collect spawn groups in that zone**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\spawn2\*.ndjson") -Pattern '"zone":"charasis"'
   ```

   Note every `spawngroupID`.

3. **Collect NPC ids + spawn chance**  
   For each `spawngroupID`, find `spawnentry` rows. Keep `npcID` and `chance` (0–100).  
   **`chance == 0`** often means script / PH / disabled on the static table — the NPC may still have a full loot table; camp the PH listed on other entries in the same group. On Nameds Notes, write the marker `IdleQuest **0%**` (must include the literal `**0%**` substring). The site shows a **Hide 0% spawn** checkbox that filters any table row containing that marker.

4. **Load NPC rows**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\npc_types\*.ndjson") -Pattern '"id":12345,'
   ```

   Read `name`, `level`, `class`, `hp`, `loottable_id`. Skip joke / trigger / empty placeholder names when writing sheets.

5. **Expand loot**  
   `loottable_id` → `loottable_entries` → each `lootdrop_id` → `lootdrop_entries` → each `item_id` → `items`.  
   Prefer notable uniques for sheets; skip gem/velium spam unless quest-tied.

6. **Write the sheet**  
   Nameds table: Mob / Do / (optional Class) / Area / Notes (level, %, PH, highlights).  
   Loot table: Item / Dropper / Classes / Stats — pull classes + stats from the item row (see §6).

---

## 5. Recipe B — start from an item (who drops it, where)

Use when confirming a drop attribution or filling Classes / Stats.

1. **Find the item**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\items\*.ndjson") -Pattern '"Name":"Mask of Obtenebration"'
   ```

   Note `id` and stats fields.

2. **Who can drop it**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\lootdrop_entries\*.ndjson") -Pattern '"item_id":12345,'
   ```

   Note `lootdrop_id` and entry `chance`.

3. **Which loot tables use that drop**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\loottable_entries\*.ndjson") -Pattern '"lootdrop_id":678,'
   ```

   Note `loottable_id`.

4. **Which NPCs use those loot tables**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\npc_types\*.ndjson") -Pattern '"loottable_id":999,'
   ```

   Note `id`, `name`, `level`.

5. **Where those NPCs spawn**

   ```powershell
   Select-String -Path (Join-Path $tmp "data\spawnentry\*.ndjson") -Pattern '"npcID":111,'
   ```

   Then open matching `spawn2` rows for those `spawngroupID`s and filter by `zone` if needed.

Worked IdleQuest confirmations we already rely on in sheets:

| Item | IdleQuest dropper / note |
| --- | --- |
| Mask of Obtenebration | `#Skeletal_Procurator`, Howling Stones west last room (~−90, 675) |
| Mask of Wurms | `a_crypt_wurm`, north camps with Bile Sentinel |
| Enshrouded Veil | **Not** Embalming Fluid on IdleQuest — tiny % on several HS trash loottables; Embalming Fluid has Fingerbone Hoop / Hand of the Reaper instead |

---

## 6. Useful item / NPC fields for sheets

### Item classes bitmask → sheet “Classes” column

`items.classes` is a bitfield (classic EQ). Bits commonly used on Classic–Velious sheets:

| Bit | Class |
| ---: | --- |
| 1 | WAR |
| 2 | CLR |
| 4 | PAL |
| 8 | RNG |
| 16 | SHD |
| 32 | DRU |
| 64 | MNK |
| 128 | BRD |
| 256 | ROG |
| 512 | SHM |
| 1024 | NEC |
| 2048 | WIZ |
| 4096 | MAG |
| 8192 | ENC |

`65535` (or all classic bits) → **ALL**. Later bits (BST / BER) exist in the export; zone sheets usually omit them unless the item is post-Velious.

Other sheet-friendly fields: `ac`, `astr`/`asta`/`aagi`/`adex`/`awis`/`aint`/`acha`, `hp`, `mana`, `damage`/`delay`, resists (`fr`/`cr`/`mr`/`dr`/`pr`), `haste`, `nodrop`.

### NPC class

`npc_types.class` is a small integer class id (1=WAR, 2=CLR, …) — used for the optional **Class** column on Nameds (UI toggles that column off by default).

### Spawn chance

`spawnentry.chance` is the weight/percent among entries in that spawn group. Sheet language:

- **100%** / always — sole or guaranteed entry  
- **~25%** — PH camp  
- **0%** — still list if loot matters; put `IdleQuest **0%**` in Notes (Hide checkbox), plus PH / script note  
 

---

## 7. Agent / human checklist for a zone pass

1. Sparse-clone or update `$tmp` (§1).  
2. Confirm zone shortname in `data/zone` or existing sheet intro.  
3. Recipe A: nameds with Do (**KILL** / **LEAVE** / **FACTION** / **RAID**), levels, %, PH.  
4. Recipe B (or loot expand from A): every unique on the page has **Classes** + **Stats** from `items`.  
5. Skip Fabled / joke / pure trigger NPCs unless the sheet needs them.  
6. If wiki story differs, keep IdleQuest on the loot row and add a one-line IdleQuest note.

---

## 8. Gotchas

- **Script-only NPCs** may have loot + npc_types rows but **no** `spawn2` / `spawnentry` line. Retain them; say “script / event / PH” on the sheet.  
- **`#Name` vs `Name`** can be different records with different loot.  
- **Multiple loottable_entries** per NPC — uniques may sit on a rare nested drop; don’t stop at the first junk drop.  
- **Shortname traps:** Howling Stones = `charasis`; Hate sheets may mention both `hateplane` and `hateplaneb`.  
- **Do not** dump entire zone ndjson into the LustreDamus repo. Summarize into markdown tables only.

---

## 9. Where this shows up in LustreDamus

- Zone sheets: `assets/samples/everquest/zone/*.md` — intro line links IdleQuest and cites the shortname.  
- Class gear: `assets/samples/everquest/byClass/*.md` — same item lookup for Classes / Stats when needed.  
- Cursor rule (agent-oriented): `.cursor/rules/idlequest-content-lookup.mdc` — same join path; this file is the human-readable copy for the samples folder.
