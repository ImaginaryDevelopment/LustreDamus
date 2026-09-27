# Highpass Hold — unique loot

ZEM **1.06×**. Hunt range **9–22** (bandits / orcs / gnolls); a few higher nameds sit on the pass. Outdoor hold linking **High Keep**, **Kithicor**, and the Qeynos / Freeport roads. Marked `*` on Zone XP — auto-level is unsafe around **Highpass Guards**, merchants, and McCabe faction.

**IdleQuest** spawn/loot truth: [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) (`highpass` / `highpasshold`).

**Do not trust `highpasshold` respawn times.** Nearly every spawn there is bulk-set to **215s** (150/153 rows) — including smugglers and Anson. That is a zone default, not a measured timer. Use the classic **`highpass`** row for this camp: **640s (~10m 40s)**. P99 wiki still lists ~**22m** for Anson.

Sort **Named spawn** by **Mob**. **LEAVE** = guards, merchants, Stanos-path rogues you need alive.

## Anson McBale

Rogue epic / Stanos path. IdleQuest puts him in **Highpass Hold** (smuggler tunnels), not High Keep. Same point as his PH smugglers (~x 325–330 / y 5–32 / z 45).

| Source | Chance | Respawn | Notes |
| --- | ---: | ---: | --- |
| **highpass** (credible IdleQuest timer) | **25%** | **640s (~10m 40s)** | PH smugglers 37% / 38%. NPC 5037. Matches Lazarus / Miragul |
| highpasshold (IdleQuest ids) | **50%** | 215s listed — **ignore** | PH `a_smuggler` 50%. NPC 407060. 215s is the zone-wide junk default (smuggler statics too) |
| P99 wiki | PH smuggler | ~**22m** | Live-feel reference; longer than emu DB |

Smuggler static camps on `highpasshold` are the same **215s bulk** — if they feel much longer in-game, believe your stopwatch; the DB row is not authoritative. Expected Anson wait on a 50% roll is roughly **2×** the real point timer.

Loot table is cash + equipped **Dagger** only — no unique gear row. Treat as **LEAVE / QUEST** unless you mean to kill him.

## Named spawn

Timers below use classic **`highpass` ~640s** unless noted. `highpasshold` chance may differ; its **215s** column is not trusted.

| Mob | Class | Area | PH / notes |
| --- | --- | --- | --- |
| Anson McBale | ROG | Smuggler camp | ~61. **25%** / **~10m 40s** (`highpass`); hold row is 50% but **215s timer is junk**. LEAVE / QUEST |
| Cyrla Shadowstepper | ROG | Smuggler camp | ~61 / **34%** / **640s** on `highpass` (hold 50% / fake 215s). LEAVE / QUEST |
| Vranol Blackguard | NEC | Hold | ~50 / 100% / **7200s** (2h) — one of the few non-215 hold timers |
| Alhareen the Just | SHM | Hold | ~61 / 100% |
| Beef | WAR | Hold | ~40 / 100% |
| Bryan McGee | ROG | Hold | ~40 / 100% |
| Crenn Salbet | ROG | Hold | ~38 / 100% |
| Wres Corber | ROG | Hold | ~34 / 100% |
| Kaden Gron | ROG | Hold | ~31 / 100% |
| Captain Orben | WAR | Hold | ~29 / 100% |
| Captain Ashlan | WAR | Hold | ~27 / 100%. Orc ear turn-ins |
| Prak | ROG | Hold | ~27 / 100% |
| Cytodl Krish | SHD | Hold | ~25 / 100% |
| Falyn Farreach | WAR | Hold | ~25 / 100% |
| Breck Damison | ROG | Hold | ~22 / 100% |
| Barn Bloodstone | ROG | Hold | ~20 / 100% (`highpass` 50%) |
| Grenix Mucktail | WAR | Gnolls | ~20 / ~9–10% |
| Vexven Mucktail | SHM | Gnolls | ~20 / ~5% |
| Hagnis / Recfek / Vopuk Shralok | mixed | Orcs | ~21 / ~5–10% |
| Swiftfingers | ROG | Bandits | ~17 |
| Commander Tehafer | WAR | Hold | ~37. LEAVE. Highpass command |
| Shumpi Wimahnn | CLR | Hold | ~65. LEAVE |
| Merchants / bartenders / Greenbane / Tarburner / Greyeagle / Rossook / Whistlewood | MER | Pass shops | ~45. LEAVE. Highpass merchant faction |
| Volunteer Delharn / Renlor | WAR | Soft | ~4–5. LEAVE / fluff |

## Unique loot

Notable uniques only — most hold camps are faction / quest / vendor gear, not big unique tables. Skip generic vendor steel.

| Item | Mob | Mob levels | Notes |
| --- | --- | ---: | --- |
| (none unique) | Anson McBale | 61 | IdleQuest lootdrop = equipped Dagger + coin |
| Orc scalps / ears | Shralok orcs; Captains | 21–29 | Ashlan / Orben turn-ins |
| Gnoll fangs / pelts | Mucktail gnolls | 20 | Camp trash / faction |

## Leave alone

**Highpass Guards**, captains/commanders you need for faction, all pass merchants, and **Anson / Cyrla** if you still need the Stanos / Renux rogue path. Killing citizens tanks **Highpass Guards**, **Merchants of Highpass**, and **Carson McCabe** (same story as High Keep).
