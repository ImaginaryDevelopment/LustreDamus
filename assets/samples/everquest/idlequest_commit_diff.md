# Diff new IdleQuest commits against our sheets

Use this when Brynn publishes new commits in [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) and we need to know whether LustreDamus gear or zone charts are stale.

Local clone: `d:\projects\idlequest-content` (branch `main`). Loot and spawn truth is the `data/*.ndjson` tables, not the P99 wiki scrape. Quest Lua under `effective/` and `maintained/` only matters when a sheet describes a spawn script or a hand-in.

**Last reviewed:** `b717b8a5` (2026-10-20, “Refresh quest and world content within existing public scope”). Next run starts at this SHA.

---

## 1. See what is new

```powershell
git -C d:\projects\idlequest-content fetch origin
git -C d:\projects\idlequest-content log --oneline LAST_REVIEWED..origin/main
git -C d:\projects\idlequest-content diff --stat LAST_REVIEWED..origin/main -- data/items data/lootdrop_entries data/loottable_entries data/npc_types data/spawn2 data/spawnentry data/zone
```

`LAST_REVIEWED` is the SHA in the line above. If that log is empty, the sheets are already caught up. Stop.

Pull only after the log looks right: `git -C d:\projects\idlequest-content pull --ff-only`.

Ignore for chart work unless a sheet already names the thing: `quests`, `effective/quests`, `maintained/lua`, `spells_new`, `tradeskill_recipe`, `reference/p99-wiki`, `manifest.json`. Those commits are often huge and do not change drop tables.

## 2. What counts as a chart change

Join path, same as `idlequest_data_layout.md`:

```
spawn2.zone → spawnentry.npcID → npc_types.loottable_id
  → loottable_entries.lootdrop_id → lootdrop_entries.item_id → items
```

Sheeted zones are the `zone(` shortnames in `src/samples.gleam`. Gear charts are `assets/samples/everquest/byClass/*.md`, `All-Earrings.md`, and the unique-loot tables on zone sheets.

Flag a row only when the diff changes something a sheet states or should state:

- A sheeted-zone NPC gained or lost a notable drop (AC, damage, HP, mana, or a named unique). Skip coin, gems, cloth, and binding powder.
- Spawn chance, respawn, or zone of a named we list changed. `chance == 0` stays the `IdleQuest **0%**` marker.
- An item we already list changed stats, classes, or which NPC drops it.
- `data/zone` experience multiplier changed for a shortname on `Zone-XP-Modifiers.md`.

Do not add a gear row just because a quest script was converted from Perl to Lua.

## 3. How to read the ndjson diff

`git diff -U0 LAST..HEAD -- data/<table>` is one JSON object per added or removed line. A changed row is a `-` line and a `+` line with the same `id` (or the same `lootdrop_id` + `item_id`).

Resolve names from the **new** tree, not the deleted line. Player coords are **y, x**.

Write the result as three lists before editing sheets:

1. Sheet updates required (file, what changed, IdleQuest id).
2. Checked and already correct.
3. Ignored (quests, spells, tradeskills, unsheeted zones).

## 4. Edit, then move the marker

Patch the sheet the same way the last audit did: zone unique-loot table first, then `byClass` / `All-Earrings` only when that item is missing there too. Do not restyle unrelated tables.

When the pass is done, replace **Last reviewed** at the top of this file with the new `origin/main` SHA, date, and subject. The Discord note is a short version of the three lists, not a dump of the diff.
