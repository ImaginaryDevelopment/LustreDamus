# Plane of Mischief — unique loot

Velious plane (`mischiefplane`). ZEM **1.40×**. Hunt **50+**. Classic **1.0** only (no live revamp). Enter via the mini-castle in **Temple of Veeshan** (CoTH / ToV clear — dragons see invis). Exit tree in the forest → **Cobalt Scar** (~−693, 526, 93). Learn the exit tree first. Most NPCs start non-KOS; traps, invisible bridges, and rat-maze pits are the real danger. Bristlebane's throne room is **empty** on classic — no raid boss.

**IdleQuest** spawn/loot truth: [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) (`mischiefplane`). Almost all wearable gear is a **Deck of Spontaneous Generation** combine (cards → Ferjeneror), not a raw drop. Deck reagents (Squires / Knights / Crowns / Thrones) share a few IdleQuest loot pools below.

**In-app tracker:** opening this sample shows a **Deck combo tracker** above the tables — check cards you own (saved in browser localStorage); it lists completes and missing-1 farms.

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

Combine in the Deck (from **Ferjeneror**). Classic / P99 recipes — four cards each. Not raw drops.

#### Armor of Distraction

| Item | Classes | Cards |
| --- | --- | --- |
| Boots of Distraction | WAR CLR PAL SHD BRD | White Throne, Blue Throne, White Crown, White Knight |
| Breastplate of Distraction | WAR CLR PAL SHD BRD | Red Throne, Black Throne, Black Crown, Black Knight |
| Crown of Distraction | WAR CLR PAL SHD BRD | Red Throne, Blue Throne, Red Crown, Blue Crown |
| Gloves of Distraction | WAR CLR PAL SHD BRD | White Throne, Red Throne, White Crown, White Knight |
| Greaves of Distraction | WAR CLR PAL SHD BRD | Blue Throne, Black Throne, Black Crown, Black Knight |
| Robe of Distraction | NEC WIZ MAG ENC | Black Throne, Red Throne, Black Crown, Red Crown |
| Vambraces of Distraction | WAR CLR PAL SHD BRD | White Throne, Black Crown, Black Knight, Black Squire |
| Wristguard of Distraction | WAR CLR PAL SHD BRD | White Throne, Black Throne, White Crown, White Knight |

#### Wrist / other

| Item | Classes | Cards |
| --- | --- | --- |
| Bracelet of the Twisted Mind | NEC WIZ MAG ENC | White Throne, Blue Throne, Blue Crown, Blue Knight |
| Green Wristguard | RNG DRU | White Throne, Red Throne, Red Crown, Red Knight |
| Mushroom Bracelet | MNK (HUM IKS) | Black Throne, Blue Throne, Blue Crown, Blue Knight |
| Onyx Wristbands | SHD | Blue Throne, Red Throne, Red Crown, Red Knight |
| Shimmering Wristguard | CLR PAL | Red Throne, Blue Throne, Blue Crown, Blue Knight |
| Silver Wristguards | PAL | Black Throne, Red Throne, Red Crown, Red Knight |
| Buckler of Doom | ALL | Black Throne, Black Crown, Black Knight, Black Squire |
| Cloak of Confusion | ALL | Blue Throne, Blue Crown, Blue Knight, Blue Squire |
| Mask of Melodies | BRD | Red Throne, Red Crown, Red Knight, Red Squire |
| Belt of Inconsistency | ALL | White Throne, Blue Throne, White Crown, Blue Crown |
| Globe of Darkness | ALL | Black Throne, Blue Throne, Black Crown, Blue Crown |
| Idiot Savant's Cap | ALL | Red Throne, White Throne, Red Crown, White Crown |
| Very Rusty Dagger | SHD ROG | Black Throne, White Throne, Black Crown, White Crown |

#### Flowers of Functionality

| Item | Resist | Cards |
| --- | --- | --- |
| Black Flower | Disease | All four Squires |
| Blue Flower | Magic | All four Thrones |
| Green Flower | Poison (stacks) | All four Knights |
| White Flower | Cold (stacks) | All four Crowns |
| Red Flower | Fire | White Throne, White Crown, White Knight, White Squire |

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
