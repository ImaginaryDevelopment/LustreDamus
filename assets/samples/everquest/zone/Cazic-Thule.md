# Accursed Temple of Cazic-Thule — unique loot

Classic / Luclin temple (`cazicthule`). IdleQuest ZEM **1.28×** (classic Lost Temple sheets often cite **1.13×**). Hunt **50–60+** on IdleQuest — this is the **Accursed Temple** revamp, not the classic 19–45 Ravenscale pyramid. Enter from **The Feerrott**. Tae Ew lizards, shiverbacks, oozes/masses, raptors, piranhas. No AAs: nameds are group; **Avatar of Fear** is **RAID**-tier on paper (~60) but does not spawn (see **IdleQuest 0%**).

**IdleQuest** spawn/loot truth: [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) (`cazicthule`). Mob names match IdleQuest display (`#Avatar_of_Fear` → **Avatar of Fear**, `#a_Tae_Ew_warmaster` → **a Tae Ew warmaster**). Classic P99 **Ravenscale** / Cenobite / Archon / Templar / Diviner / golem tables are **not** what IdleQuest spawns here — those are Lost Temple–era.

Sort **Named spawn** by **Mob**. **Level** is the IdleQuest `npc_types` level. **Chance** is the best static `spawnentry` chance on a point in this zone. Hover a **Loot** or **Item** name for classes, races, and stats. **LEAVE** rows are quest NPCs.

**Hide 0% spawn** hides rows with Chance **0%**. That is **Avatar of Fear** (no spawn point; `#an_unstable_rift` quest lua is empty, so the script that would summon him never runs), **Avatar of Dread / Fright / Terror** (only his script spawns them), and **a Thul Tae Ew High Priest** (one point at ~(590, 1020), sole entry, chance 0). **a toxic jungle hunter** does spawn (**10%**).

## Named spawn

| Mob | Class | Chance | Level | Area | Loot | PH / notes |
| --- | --- | ---: | ---: | --- | --- | --- |
| a blood fin piranha | WAR | 1% | 53 | Water | **Piranha Scale Fistwraps** / **Piranha Scale Wristwrap** | |
| a crystalline mass | WAR | 5% | 59 | Ooze | **Staff of Primordial Summoning** | IdleQuest spelling `crystaline` |
| a disciple of Thule | SHM | 10% | 56 | Temple | **Barbed Rubicite Belt** / **Bone Shield of Cazic-Thule** | |
| a diseased mosquito | WAR | 5% | 58 | Jungle | **Mosquito Leg Earring** / **Mosquito Leg Wand** | |
| a frenzied shiverback | WAR | 2% | 56 | Jungle | **Fetid Shiverback Hide Mantle** / **Silver Shiverback Hide Sash** | |
| a gelatinous mass | WAR | 20% | 55 | Ooze | **Slime Covered Rubicite Coif** / **Tae Ew War Helm** | |
| a gyrating mass | WAR | 5% | 55 | Ooze | **Slime Covered Rubicite Coif** | |
| a poisonstrand hunter | WAR | 10% | 56 | Jungle | **Envenomed Necklace** / **Poison Silk Necklace** | |
| a quivering mass | WAR | 2% | 55 | Ooze | **Ooze Covered Rubicite Mask** / **Oozing Bracer** | |
| a razor fin piranha | WAR | 1% | 53 | Water | **Piranha Scale Sash** | |
| a rotting horror | WAR | 2% | 55 | Jungle | **Rotting Gorilla Hide Helmet** | |
| a rotting shiverback | WAR | 10% | 55 | Jungle | **Fetid Shiverback Hide Bracer** / **Fetid Orb** | |
| a silverflank shiverback | WAR | 2% | 56 | Jungle | **Silverflank Belt** | |
| a swirling black mass | WAR | 5% | 59 | Ooze | **Ooze Covered Rubicite Greaves** / **Prelate's Rubicite Bracer** | |
| a swirling green mass | WAR | 5% | 59 | Ooze | **Heavy Rubicite Girdle** / **Ooze Covered Rubicite Greaves** | |
| a swirling ooze | WAR | 100% | 55 | Ooze | | Common trash, not a PH named |
| a swirling red mass | WAR | 5% | 59 | Ooze | **Boots of Flowing Slime** / **Ring of Flowing Slime** | |
| a Tae Ew aggressor | WAR | 5% | 56 | Temple | **Imbued Froglokhide Shield** | |
| a Tae Ew bloodfiend | NEC | 25% | 56 | Temple | **Tae Ew Bloodletters Sword** / **Sanguine Tome** | |
| a Tae Ew convert | SHM | 10% | 56 | Temple | **Frightforged War Mask** / **Lizard Skin Sash** / **Prelate's Rubicite Helm** | |
| a Tae Ew trapper | ROG | 10% | 56 | Temple | **Barbed Rubicite Bracer** | |
| a Tae Ew warlord | WAR | 10% | 56 | Temple | **Ornate Rubicite Greaves** | |
| a Tae Ew warmaster | WAR | 10% | 58 | Temple | **Heavy Rubicite Breastplate** | Always |
| a Thul Tae Ew adept | WAR | 10% | 60 | Inner | **Lizard Bone Earring** | |
| a Thul Tae Ew crusader | SHD | 10% | 60 | Inner | **Thulian Crusaders Earring** | |
| a Thul Tae Ew despoiler | CLR | 10% | 60 | Inner | **Lizard Bone Earring** / **Spear of the Despoiler** | |
| a Thul Tae Ew ritualist | NEC | 10% | 60 | Inner | **Tae Ew Ritualists Mask** / **Lizard Tooth Earring** | |
| a Thul Tae Ew spiritcaller | SHM | 10% | 60 | Inner | **Barbed Rubicite Pauldrons** / **Tae Ew Tribal Shield** | IdleQuest `spirtcaller` |
| a Thul Tae Ew torturer | ROG | 10% | 60 | Inner | **Tae Ew Spiritcallers Coif** / **Earring of Pain** | |
| a toxic jungle hunter | WAR | 10% | 56 | Jungle | **Spiderfang Earring** / **Jungle Spider Fur Cap** | PH **a jungle hunter** (90%). One point ~(-406, 332) |
| an enraged Amygdalan | WAR | 10% | 56 | Temple | **Amygdalan's Chain Mask** | |
| an enraged disciple | WAR | 10% | 55 | Temple | **Shield of Striding** / **Bowl of Vicious Ooze** / **Bone Shield of Cazic-Thule** | |
| an enraged jungle raptor | WAR | 5% | 56 | Jungle | **Raptor Hide Shield** | |
| an enraged tiger raptor | WAR | 10% | 56 | Jungle | **Striped Raptor Hide Boots** | |
| Dreadfang | WAR | 10% | 58 | Jungle | **Dreadfang Mask** / **Dreadfangs Hide** | |
| Dismay | WAR | 2% | 59 | Named | **Stonebladed Axe of Dismay** | |
| Frightchaser | WAR | 10% | 59 | Jungle | **Frightchaser's Hide** | |
| Gimlik Cogboggle | WAR | 100% | 1 | Temple | | LEAVE. Accursed Temple gnome path |
| Radiant | ROG | 34% | 22 | Classic remnant | **Radiant Gloves** | Classic remnant. Still spawns |
| Silverfang | WAR | 1% | 58 | Named | **Silverfang Club** | |
| Soul Siphon | WAR | 5% | 62 | Named | **Spiked Ringmail Sleeves** / **Sanguine Wand** | |
| Terrorclaw | WAR | 5% | 58 | Jungle | **Terrorclaw's Hide** | |
| Toxiferious | WAR | 10% | 59 | Named | **Toxiferious Axe** | |

### IdleQuest 0% (does not spawn)

Static spawn chance **0%** — hidden when **Hide 0% spawn** is checked.

| Mob | Class | Chance | Level | Area | Loot | PH / notes |
| --- | --- | ---: | ---: | --- | --- | --- |
| Avatar of Fear | WAR | 0% | 60 | Sanctum | **Fearsome Girdle** / **Bladed Thulian Eviscerator** / **Feartouched Greatsword** / **Trinket of Ancient Fears** / **Slime Crusted Shoes** | IdleQuest **0%**. **RAID.** No spawnentry. Rift script that would summon him is empty |
| Avatar of Dread | WAR | 0% | 60 | Sanctum | **Dread Coronet** / **Ring of Dreadful Dreams** / **Pearl of Dread** / **Scalecracker** | IdleQuest **0%**. Only Avatar of Fear's script would spawn him |
| Avatar of Fright | WAR | 0% | 60 | Sanctum | **Frightful Shroud** / **Mantle of Paralyzing Fright** / **Talisman of Fright** / **Fright Imbued Battlestaff** | IdleQuest **0%**. Only Avatar of Fear's script would spawn him |
| Avatar of Terror | WAR | 0% | 60 | Sanctum | **Terror Forged Short Sword** / **Terror Woven Wraps** / **Boots of Hidden Terror** | IdleQuest **0%**. Only Avatar of Fear's script would spawn him |
| a Thul Tae Ew High Priest | WAR | 0% | 60 | Inner | **Bloodstained Journal, Vol 1** | IdleQuest **0%**. Point ~(590, 1020) is his alone at chance 0, so it never pops. Live journal copies are on a Tae Ew defender and an enraged Tae Ew fanatic |

## Unique loot

Notable Accursed Temple uniques — skip common spells / crushed gems. All **NO DROP** unless noted. Hover **Item** for the class / race mask.

### Avatar of Fear (RAID)

Does not spawn. Each row is IdleQuest **0%**.

| Item | Mob | Mob levels | Notes |
| --- | --- | ---: | --- |
| Fearsome Girdle (Waist) | Avatar of Fear | 60 | IdleQuest **0%** spawn. ALL, AC 20 STA/AGI/DEX +8 Haste 41% |
| Bladed Thulian Eviscerator (1H Slashing) | Avatar of Fear | 60 | IdleQuest **0%** spawn. WAR PAL RNG SHD BRD ROG, 13/18 (0.72), STR +15 HP +100 |
| Feartouched Greatsword (2H Slashing) | Avatar of Fear | 60 | IdleQuest **0%** spawn. WAR PAL RNG SHD, 46/40 (1.15), AC 5 STR/STA +10 AGI +20 INT +10 |
| Trinket of Ancient Fears | Avatar of Fear | 60 | IdleQuest **0%** spawn. ALL, AC 10 STA/WIS +15 AGI/CHA +10 HP +50 |
| Slime Crusted Shoes (Feet) | Avatar of Fear | 60 | IdleQuest **0%** spawn. CLR DRU SHM NEC WIZ MAG ENC, AC 15 HP +40 Mana +70 |

### Rubicite / Thulian / Tae Ew

| Item | Mob | Mob levels | Notes |
| --- | --- | ---: | --- |
| Heavy Rubicite Breastplate (Chest) | a Tae Ew warmaster | 58 | Always. WAR, AC 46 STR/STA +6 DEX +4 HP +85 |
| Ornate Rubicite Greaves (Legs) | a Tae Ew warlord | 56 | PAL SHD, AC 33 STA/WIS/INT +3 HP +50 Mana +15 |
| Heavy Rubicite Girdle (Waist) | a swirling green mass | 59 | WAR, AC 25 STR/STA +4 CHA +2 HP +85 |
| Ooze Covered Rubicite Greaves (Legs) | swirling black / green mass | 59 | WAR SHD, AC 28 STR/WIS/INT +5 |
| Slime Covered Rubicite Coif (Head) | gelatinous / gyrating mass | 55 | RNG ROG SHM, AC 16 AGI +6 HP +65 |
| Ooze Covered Rubicite Mask (Face) | a quivering mass | 55 | PAL RNG SHD BRD, AC 8 STA/WIS/INT +5 HP +35 Mana +30 |
| Prelate's Rubicite Bracer (Wrist) | a swirling black mass | 59 | CLR, AC 17 STR/WIS +4 HP +55 Mana +30 |
| Prelate's Rubicite Helm (Head) | a Tae Ew convert | 56 | CLR, AC 20 STA/WIS +3 Mana +35 |
| Barbed Rubicite Belt (Waist) | a disciple of Thule | 56 | RNG ROG SHM, AC 12 STA/AGI/DEX/WIS/INT +3 HP +40 Mana +25 |
| Barbed Rubicite Bracer (Wrist) | a Tae Ew trapper | 56 | RNG ROG SHM, AC 13 WIS/INT +5 HP +35 |
| Barbed Rubicite Pauldrons (Shoulders) | a Thul Tae Ew spiritcaller | 60 | Non-INT casters (+MNK), AC 15 STR +5 STA/AGI/DEX +10–15 WIS/INT −10 HP/Mana +55 |
| Bone Shield of Cazic-Thule (Secondary) | disciple of Thule; enraged disciple | 55–56 | WAR CLR PAL RNG SHD DRU SHM, AC 25 |
| Thulian Crusaders Earring (Ear) | a Thul Tae Ew crusader | 60 | PAL SHD, AC 10 WIS/INT +7 HP +50 Mana +35 |
| Lizard Bone Earring (Ear) | Thul adept / despoiler | 60 | ALL, AC 2 STA +10 AGI/DEX +6 CHA +5 HP +70 Mana +35 |
| Lizard Tooth Earring (Ear) | a Thul Tae Ew ritualist | 60 | ALL, AC 5 STR +6 STA +8 AGI +6 HP +75 |
| Tae Ew Ritualists Mask (Face) | a Thul Tae Ew ritualist | 60 | RNG DRU SHM WIZ MAG ENC, AC 6 WIS/INT/CHA +7 HP +40 Mana +45 |
| Tae Ew Spiritcallers Coif (Head) | a Thul Tae Ew torturer | 60 | SHM, AC 15 STR/DEX +4 WIS +7 HP +45 Mana +40 |
| Tae Ew War Helm (Head) | a gelatinous mass | 55 | WAR CLR PAL SHD BRD, AC 24 AGI/DEX +4 HP +25 Mana +40 |
| Tae Ew Tribal Shield (Secondary) | a Thul Tae Ew spiritcaller | 60 | WAR CLR PAL RNG SHD DRU SHM, AC 25 |
| Frightforged War Mask (Face) | a Tae Ew convert | 56 | WAR CLR PAL SHD BRD, AC 12 HP +35 |
| Lizard Skin Sash (Waist) | a Tae Ew convert | 56 | NEC WIZ MAG ENC, AC 2 AGI/DEX +5 HP +10 Mana +25 |
| Imbued Froglokhide Shield (Secondary) | a Tae Ew aggressor | 56 | PAL SHD, AC 25 STA +3 WIS/INT +4 HP/Mana +30 |
| Oozing Bracer (Wrist) | a quivering mass | 55 | RNG ROG, AC 13 STA/DEX/WIS +5 HP +30 Mana +35 |
| Boots of Flowing Slime (Feet) | a swirling red mass | 59 | ALL except WAR MNK ROG, AC 7 HP +20 Mana +65 |
| Spear of the Despoiler (Primary) | a Thul Tae Ew despoiler | 60 | SHM, 15/22 (0.68), HP +35 Mana +40 |

### Jungle / wildlife nameds

| Item | Mob | Mob levels | Notes |
| --- | --- | ---: | --- |
| Fetid Shiverback Hide Mantle (Shoulders) | a frenzied shiverback | 56 | RNG DRU, AC 10 STA/DEX +5 WIS +4 HP +35 Mana +30 |
| Silver Shiverback Hide Sash (Waist) | a frenzied shiverback | 56 | MNK, AC 5 HP +35 Mana +30 Haste 31% |
| Fetid Shiverback Hide Bracer (Wrist) | a rotting shiverback | 55 | DRU, AC 10 WIS +10 Mana +35 |
| Silverflank Belt (Waist) | a silverflank shiverback | 56 | NEC MAG BST, AGI/DEX/INT +5 HP +40 Mana +25 |
| Rotting Gorilla Hide Helmet (Head) | a rotting horror | 55 | DRU MNK, AC 9 STA +4 AGI/WIS +3 HP +35 |
| Piranha Scale Fistwraps (Hands) | a blood fin piranha | 53 | MNK, AC 12 STR +2 STA/AGI/DEX +4 HP +45 Mana +20 |
| Piranha Scale Wristwrap (Wrist) | a blood fin piranha | 53 | WIZ MAG, AC 5 Mana +65 |
| Piranha Scale Sash (Waist) | a razor fin piranha | 53 | DRU MNK, AC 8 CHA +10 Mana +35 |
| Amygdalan's Chain Mask (Face) | an enraged Amygdalan | 56 | WAR PAL RNG SHD BRD ROG, AC 8 STA/AGI/DEX/WIS +5 HP +85 |
| Spiderfang Earring (Ear) | a toxic jungle hunter | 56 | WAR MNK ROG, AC 7 AGI/DEX +7 HP +35. Hunter spawns at 10% |
| Jungle Spider Fur Cap (Head) | a toxic jungle hunter | 56 | WIZ, AC 8 Mana +65. 70% on the hunter table |
| Raptor Hide Shield (Secondary) | an enraged jungle raptor | 56 | PAL RNG SHD, AC 25 WIS/INT +5 HP +25 Mana +40 |
| Striped Raptor Hide Boots (Feet) | an enraged tiger raptor | 56 | MNK, AC 10 STA +4 HP +45 Mana +20 |
| Dreadfang Mask (Face) | Dreadfang | 58 | ALL, AC 6 CHA +4 HP/Mana +50 |
| Dreadfangs Hide (Legs) | Dreadfang | 58 | NEC WIZ MAG ENC, AC 12 AGI/WIS/INT/CHA +3 HP +40 Mana +45 |
| Frightchaser's Hide (Chest) | Frightchaser | 59 | CLR DRU MNK SHM, AC 20 STR/STA/DEX/WIS +5 HP +45 Mana +40 |
| Terrorclaw's Hide (Shoulders) | Terrorclaw | 58 | NEC, AC 9 STA/INT +7 HP +55 Mana +30 |
| Shield of Striding (Secondary) | an enraged disciple | 55 | CLR DRU SHM, AC 35 STA +5 AGI +3 WIS +5 HP +30 Mana +55 |
| Bowl of Vicious Ooze (Primary) | an enraged disciple | 55 | ALL except WAR MNK BRD ROG, STR/STA/WIS +9 HP +35 Mana +40 |
| Spiked Ringmail Sleeves (Arms) | Soul Siphon | 62 | WAR PAL RNG SHD BRD ROG, AC 21 STR +10 STA +13 |
| Sanguine Wand | Soul Siphon | 62 | NEC WIZ MAG ENC, HP +35 Mana +40 AGI/DEX/INT/CHA +9 |
| Stonebladed Axe of Dismay (2H Slashing) | Dismay | 59 | WAR, 44/44 (1.00), HP +75 |
| Silverfang Club (1H Blunt) | Silverfang | 58 | WAR RNG MNK BRD ROG, 10/17 (0.59), HP +75 |
| Toxiferious Axe (1H Slashing) | Toxiferious | 59 | RNG, 10/17 (0.59), HP +35 Mana +40 STA/WIS +5 |
| Staff of Primordial Summoning (2H Blunt) | a crystalline mass | 59 | NEC WIZ MAG ENC, 32/32 (1.00), HP/Mana +35–40 |
| Radiant Gloves (Hands) | Radiant | 22 | ENC, AC 4. Races HUM ERU HIE DEF GNM DRA. Classic remnant. Tradeable |

## Quest items

| Item | Mob | Quest |
| --- | --- | --- |
| Bloodstained Journal, Vol 1 | a Tae Ew defender; an enraged Tae Ew fanatic | Accursed Temple lore / journal chain. High Priest's copy is on a 0% spawn and never comes up |
| Tae Ew Blood Vial; Small Stone Totem | many Tae Ew / Thul nameds | Accursed Temple combines / faction path |
| Fetid Orb | a rotting shiverback | Utility / combine reagent |
| Classic Ravenscale / Rubicite / Lizard Blood Potion | — | **Not on IdleQuest CT** — Lost Temple P99 tables only |

## Quest NPCs

| Item | Mob | Notes |
| --- | --- | --- |
| Accursed Temple gnome path | Gimlik Cogboggle | LEAVE. Temple gnome quest NPC. Spawns (100%, level 1) |
| — | — | No other LEAVE hubs in-zone; most content is kill-for-loot Accursed nameds |
