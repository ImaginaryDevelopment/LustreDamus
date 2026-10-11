# Plane of Mischief — unique loot

Velious plane (`mischiefplane`). ZEM **1.40×**. Hunt **50+**. Classic **1.0** only (no live revamp). Enter via the mini-castle in **Temple of Veeshan** (CoTH / ToV clear — dragons see invis). Exit tree in the forest → **Cobalt Scar** (~−693, 526, 93). Learn the exit tree first. Most NPCs start non-KOS; traps, invisible bridges, and rat-maze pits are the real danger. Bristlebane's throne room is **empty** on classic — no raid boss.

**IdleQuest** spawn/loot truth: [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) (`mischiefplane`). Almost all wearable gear is a **Deck of Spontaneous Generation** combine (cards → Ferjeneror), not a raw drop. Deck reagents (Squires / Knights / Crowns / Thrones) share a few IdleQuest loot pools below.

**Do** column:
- **KILL** — fine to kill for loot / reagents
- **LEAVE** — quest NPC — do not kill
- **RAID** — huge HP / unused script boss (optional)

## Nameds

Sort by **Mob**. Notes cite IdleQuest loot pools — see **Loot pools** for chances.

| Mob | Do | Class | Chance | Area | Notes |
| --- | --- | --- | ---: | --- | --- |
| #Lithiniath (Black) | KILL | ENC | 0% | B&W room | IdleQuest **0%**. ~64 / **~36k HP**. **Lithiniaths Horn** 100%; Crowns / Jester 1% each; Velious spells. Camp boss when up |
| Lithiniath (White) | KILL | ENC | — | B&W room | Spawn by handing Horn to **a white stallion** (no separate IdleQuest spawn row) |
| a white stallion | LEAVE | WAR | 100% | B&W room white side | ~55 / ~4.3k HP. Horn turn-in. If killed: Throne / Crown / Words of Wealth ~3.5% each (lt 87598) |
| Ferjeneror | LEAVE | WIZ | 100% | Hedge maze center | ~65 / ~29k HP. **Deck** quest — never answer "no". Shares Crown/Jester pool (1%) if killed |
| Peachy D`Vicci | LEAVE | CLR | 100% | Castle entrance ~−341, −363 | ~48 / ~7k HP. 2× Funny Money → Gift Box. Shares **Squire** pool |
| Bob the Painter | LEAVE | ROG | ~25–100% | ~15, −450 | ~49 / ~8k HP. Empty Pot of Gold / Words of Wealth. Shares **Squire** pool |
| Posie the Librarian | LEAVE | ENC | 100% | Library ~197, −1015 | ~55 / ~14k HP. **Library Card** 20% + **Knight** pool. Book of Mischief |
| Dinner | KILL | WAR | ? | Dining table ~243, 76 | Classic L1 ogre for **King Cod Card**. **Not in IdleQuest** spawn/loot tables — script / missing DB |
| Bit | KILL | WIZ | 100% | Dining chandelier ~252, 76 | ~55 / ~14k HP. Perma-rooted KOS nuke. **Knight** pool |
| Mizer | KILL | WIZ | 100% | Dining chandelier ~235, 75 | ~55 / ~14k HP. With Bit. **Knight** pool |
| Chuckles | KILL | WAR | 100% | ~61, −178 | ~55 / ~14k HP. Picture → Hedge Maze. **Knight** pool |
| Chuckles the Great | KILL | WAR | 100% | Theater stage ~557, 151 | ~55 / ~14k HP. **Knight** pool |
| Geb | KILL | WAR | 100% | Puppet audience | ~55 / ~14k HP. Kill ~7AM game time to spawn puppets. **Knight** pool |
| Bozer the Bear | KILL | WAR | 100% | West wing ~126, −25 | ~53 / ~12k HP. **Knight** pool |
| Bristlebane Puppet | KILL | WAR | 100% | Theater ~606, 173 | ~65 / ~13k HP. Indifferent until aggro. **Crown/Jester** pool (not Knights) |
| Erollisi / Innoruuk / Rallos / Solusek / Tunare / Tribunal Puppet | KILL | WAR | 100% | Theater | ~55 / ~6k HP. **Knight** pool. Most KOS once aggro'd |
| Dupple; Plupple; Snitch; Stitch | KILL | ROG | 100% | Castle / halls | ~49 / ~8k HP. Halfling nameds. **Squire** pool |
| Dop Dop | KILL | WAR | 15–100% | Forest mushrooms | ~39 / ~2.5k HP. **Squire** pool |
| a false treasure chest | KILL | WAR | 80–100% | Chest room | ~55–57 / ~14–16k HP. Mimic — aggro floods adds. IdleQuest loot is gems/runes only (no Blam Stick in DB) |
| a phony / bogus treasure chest | KILL | WAR | 25–100% | Chest room | ~57–59 / ~16–20k HP. Fluff / missing item IDs in IdleQuest |
| Treasure Chest | KILL | ENC | 100% | Forest west ~−237, 557 | ~51 / ~10k HP. KOS mimic. IdleQuest loottable **empty** |
| All-Seeing Eye | RAID | WAR | 100% | Plane | ~75 / **~709k HP**. IdleQuest live spawn. Curzon / gem fluff |
| #Bristlebane | RAID | ROG | 0% | Throne (unused) | IdleQuest **0%**. ~75 / **~1.0M HP**. No loottable. Classic throne stays empty |
| #the Mischievous Jester | RAID | WAR | 0% | — | IdleQuest **0%**. ~70 / **~200k HP**. Post-classic loot fluff |

### IdleQuest 0% (script / PH)

Static spawn chance **0%** — hidden when **Hide 0% spawn** is checked. Includes `#Lithiniath`, `#Bristlebane`, `#the Mischievous Jester`, and many `#` theater / sphinx stubs.

## Loot pools (IdleQuest)

These are the raw-drop tables that feed Deck combines. Wearable Distraction / class armor is **not** on these tables — see Deck section.

| Pool | IdleQuest chance | Droppers (examples) | Items |
| --- | ---: | --- | --- |
| **Squire** | 1.25% each color | Dupple, Plupple, Snitch, Stitch, Dop Dop, Bob, Peachy, forest halflings / mushrooms | Black / Blue / Red / White **Squire** |
| **Knight** | 1.25% each color | Bit, Mizer, Chuckles, Geb, Bozer, god puppets (not Bristlebane Puppet), Posie, many castle nameds | Black / Blue / Red / White **Knight** |
| **Crown / Jester** | 1% each | #Lithiniath; Ferjeneror; Bristlebane Puppet; Clukker the Crazy; Debbis the Fish; Donk / EightySix | Black / Blue / Red / White **Crown**; **Jester** |
| **Throne** | 3.75% each | Brenn; Grenn; TwentyTwo (~61 / ~100k HP) | Black / Blue / Red / White **Throne** |
| **Stallion mix** | 3.5% each | a white stallion (LEAVE unless you intentionally kill) | Thrones + Crowns + Words of Wealth pages |
| **Library Card** | 20% | Posie the Librarian | Library Card → Book of Mischief |
| **Lithiniath** | Horn 100%; Crowns/Jester 1% | #Lithiniath | Lithiniaths Horn; Crowns; Jester; Velious spells |

### Not in IdleQuest loot tables

| Item | Classic source (wiki / play) | IdleQuest note |
| --- | --- | --- |
| **Blam Stick** (1H Blunt, 30/40) | Chest-room halflings while mimic is up | Item exists; **no lootdrop rows** in IdleQuest |
| **Funny Money** | Various PoM → Peachy | Item exists; **no lootdrop rows** |
| **King Cod Card** / colored Cod Cards | Dinner / moat fishing → Ferjeneror | Cards exist; **Dinner NPC missing**; no lootdrop rows |

## Unique loot

### Direct drops (IdleQuest)

| Item | Mob | Notes |
| --- | --- | --- |
| Lithiniaths Horn | #Lithiniath | Always. Turn in to white stallion → white Lithiniath |
| Black / Blue / Red / White Crown | #Lithiniath; Crown pool; stallion | Deck reagents. Ultra rare (~1–3.5%) |
| Jester | #Lithiniath; Crown pool | Deck reagent (~1%) |
| Black / Blue / Red / White Squire | Squire pool | Deck / armor combines |
| Black / Blue / Red / White Knight | Knight pool | Deck combines |
| Black / Blue / Red / White Throne | Throne pool; stallion | Deck combines (most Distraction pieces need two thrones) |
| Library Card | Posie | → Book of Mischief |
| Words of Wealth (pages) | a white stallion (~3.5%) | Bob's Pot of Gold path |

### Blam Stick (classic; missing IdleQuest drops)

| Item | Classes | Stats / notes |
| --- | --- | --- |
| Blam Stick (1H Blunt) | WAR CLR PAL RNG SHD DRU MNK BRD ROG SHM BST | 30/40 (0.75), wt 0. Fireball animation proc. Farm: aggro chest, FD/blur, leave chest up — **confirm on your emu** |

### Deck of Spontaneous Generation rewards

Combine cards / thrones / crowns / knights / squires in the Deck (from **Ferjeneror**). Not raw drops.

| Item | Notes |
| --- | --- |
| Boots of Distraction (Feet) | WAR CLR PAL SHD BRD, AC 24 WIS/INT +10 HP/Mana +20. White+Blue Throne |
| Breastplate of Distraction (Chest) | WAR CLR PAL SHD BRD, AC 36 DEX/STA +10 HP +50 Mana +30. Red+Black Throne |
| Crown of Distraction (Head) | WAR CLR PAL SHD BRD, AC 18 all stats +3 all resists +3. Red+Blue Throne |
| Gloves of Distraction (Hands) | WAR CLR PAL SHD BRD, AC 20 all resists +5. White+Red Throne |
| Greaves of Distraction (Legs) | WAR CLR PAL SHD BRD, AC 30 STR/CHA +12. Blue+Black Throne |
| Vambraces of Distraction (Arms) | WAR CLR PAL SHD BRD, AC 27 WIS +5 AGI +8. One White Throne only |
| Wristguard of Distraction (Wrist) | WAR CLR PAL SHD BRD, AC 19 STR/WIS/INT +3 HP/Mana +35. White+Black Throne |
| Robe of Distraction (Chest) | NEC WIZ MAG ENC, AC 20 STA/INT +10 Mana +90. Black+Red Throne |
| Cloak of Confusion (Back) | ALL, AC 14 STR +10 STA/CHA +15 HP +45, mixed resists. Weightless |
| Buckler of Doom (Secondary) | ALL, AC 10 STR +15 HP +45 Mana +40. Weightless |
| Bracelet of the Twisted Mind (Wrist) | NEC WIZ MAG ENC, AC 10 STA/INT +5 HP/Mana +35. Weightless |
| Mask of Melodies (Face) | BRD, AC 14 CHA +15 HP +50. Weightless |
| Mushroom Bracelet (Wrist) | MNK, AC 18 STR/AGI +6 all resists +3. HUM IKS |
| Green Wristguard (Wrist) | RNG DRU, AC 20 STR/WIS +5 Mana +35 |
| Shimmering Wristguard (Wrist) | CLR PAL, AC 22 WIS +8 HP/Mana +20 |
| Silver Wristguards (Wrist) | PAL, AC 23 STR/WIS +7 all resists +2 |
| Onyx Wristbands (Wrist) | SHD, AC 23 STR/INT +7 HP/Mana +25 all resists +2 |
| Black / Blue / Green / Red / White Flower of Functionality (Head) | ALL, AC 10. Colored petal resist clicks (+50). Green stacks with cast PR; White with cast CR |
| Globe of Darkness (Range) | ALL, STA +7 SV DISEASE +15 |

## Quest items

| Item | Source | Quest |
| --- | --- | --- |
| King Cod Card; colored Cod Cards | Dinner (classic); moat fishing | Hand to **Ferjeneror** → Deck |
| Funny Money ×2 | Classic various (not in IdleQuest drops) | **Peachy D`Vicci** → random Gift Box → doll |
| Words of Wealth | Stallion pages / Bob path | **Bob the Painter** → Empty Pot of Gold (2-slot) |
| Distraction piece + class doll | Deck; Gift Box | Combine in Empty Pot of Gold → class PoM armor |
| Library Card | Posie (20%) | Book of Mischief |
| Lithiniaths Horn | #Lithiniath | White stallion → white Lithiniath |

## Quest NPCs

| NPC | Do | Notes |
| --- | --- | --- |
| Ferjeneror | LEAVE | Deck of Spontaneous Generation. Hedge maze. Never say "no" |
| Peachy D`Vicci | LEAVE | Gift Box / dolls. Castle entrance |
| Bob the Painter | LEAVE | Empty Pot of Gold / class armor combines |
| Posie the Librarian | LEAVE | Library Card → Book of Mischief |
| a white stallion | LEAVE | Horn turn-in for white Lithiniath |
| Dinner | KILL | Classic King Cod Card — missing from IdleQuest DB |

### Class armor sets (combine only)

Distraction piece + matching doll in Bob's Pot of Gold.

| Set | Class | Notes |
| --- | --- | --- |
| Crazy Cleric Armor | CLR | Distraction + Cleric doll |
| Twisted Nature Armor | DRU | |
| Mischievous Dazzler Armor | ENC | |
| Sly Summoners Armor | MAG | |
| Monkey Hide Armor | MNK | |
| Maleficent Armor | NEC | |
| Shamanistic Shenannigan Armor | SHM | Boots stand out (very high AC) |
| Wily Warlock Armor | WIZ | |
