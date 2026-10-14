# Tower of Frozen Shadow — unique loot

Velious dungeon (`frozenshadow`). ZEM **1.00×**. Hunt **26–51**. Seven floors; each floor key *should* drop from a named. No AAs: **Tserrina** is **2-group** on live EQ (charm / mez) — on IdleQuest she **does not spawn** (see below).

**IdleQuest** spawn/loot truth: [brynnb/idlequest-content](https://github.com/brynnb/idlequest-content) (`frozenshadow`).

**Broken / missing spawns:** `#Tserrina_Syl\`Tor` (and Fabled) have **no `spawnentry`**, and the quest stub named `111154` is **empty** — not a static chance and not a working trigger. Same “NPC exists, never placed” pattern for **Cara Omica**, **VhalSera**, **Angry Librarian**, **Large Undead Gnoll**, **Enraged Shadowbeast** (floor key nameds). Loot tables still exist on the NPC rows.

Sort **Nameds** by **Mob**. **Do** column:
- **KILL** — fine to kill for loot / keys
- **RAID** — formed raid / 2-group when the spawn works (Tserrina does not on IdleQuest)

## Nameds

| Mob | Do | Class | Chance | Area | Notes |
| --- | --- | --- | ---: | --- | --- |
| an angry chef | KILL | WAR | 0% | Mid floors | IdleQuest **0%** on seven tables. ~34. **Crystallized Shadow Tunic** |
| Angry Librarian | KILL | WAR | — | 3rd floor | **No spawnentry.** ~34. Three Toothed Key on table — unavailable |
| Cara Omica | KILL | WAR | — | 5th floor | **No spawnentry.** ~42. Magnetic Dirk / Small rusty key on table — unavailable |
| Enraged Shadowbeast | KILL | WAR | — | 4th floor | **No spawnentry.** Frosty key on table — unavailable |
| Incoherent Spirit | KILL | WAR | 50% | Upper | ~42 / **50%** (`incoherent_spirit`). Hash `#Incoherent_spirit` is **0%**. Abram's Axe |
| Large Undead Gnoll | KILL | WAR | — | 2nd floor | **No spawnentry.** Crystal Key on table — unavailable |
| Librarian | KILL | WAR | 100% | Mid | ~33. Static `Librarian` / assistant — not the Angry Librarian key named |
| Nosja | KILL | WAR | 100% | Mid floors | ~32. **Ceremonial Wedding Sword** |
| Tserrina Syl'Tor | RAID | NEC | — | 7th / mirror | ~51 / **~15.7k HP**. **No spawnentry** + empty quest stub — **does not spawn** on IdleQuest. Robe / Staff / Key still on loot table |
| Vhal'Sera | KILL | ENC | — | 7th floor | **No spawnentry** (`#VhalSera`). Talisman / Large metal key on table — unavailable |

### IdleQuest 0% (script / PH)

Static spawn chance **0%** — hidden when **Hide 0% spawn** is checked.

| Mob | Do | Class | Chance | Area | Notes |
| --- | --- | --- | ---: | --- | --- |
| #a ghostly student | KILL | WIZ | 0% | — | ~26. IdleQuest **0%** (script / PH) |
| #a shadow beast cook | KILL | WAR | 0% | — | ~34. IdleQuest **0%** (script / PH) |
| #a shadow beast guard | KILL | WAR | 0% | — | ~37. IdleQuest **0%** (script / PH) |
| #a shadowbone | KILL | WAR | 0% | — | ~28. IdleQuest **0%** (script / PH) |
| #a shrouded bat | KILL | WAR | 0% | — | ~41. IdleQuest **0%** (script / PH) |
| #a skeleton sleeper | KILL | MNK | 0% | — | ~32. IdleQuest **0%** (script / PH) |
| #Advisor Svartmane | KILL | WAR | 0% | — | ~63. IdleQuest **0%** (script / PH) |
| #Amontehepna | KILL | CLR | 0% | — | ~42. IdleQuest **0%** (script / PH) |
| #an ice shade | KILL | NEC | 0% | — | ~36. IdleQuest **0%** (script / PH) |
| #an undead usher | KILL | MNK | 0% | — | ~33. IdleQuest **0%** (script / PH) |
| #Eugie | KILL | ROG | 0% | — | ~30. IdleQuest **0%** (script / PH) |
| #maggot infested flesh | KILL | WAR | 0% | — | ~38. IdleQuest **0%** (script / PH) |
| #Narmak Berreka | KILL | SHD | 0% | — | ~36. IdleQuest **0%** (script / PH) |
| #The Head Usher | KILL | SHD | 0% | — | ~39. IdleQuest **0%** (script / PH) |
| #Voknya | KILL | ROG | 0% | — | ~30. IdleQuest **0%** (script / PH) |
| #Xalgoti | KILL | MNK | 0% | — | ~30. IdleQuest **0%** (script / PH) |
| #Zorglim the Dead | KILL | WAR | 0% | — | ~35. IdleQuest **0%** (script / PH) |

## Unique loot

| Item | Dropper | Classes | Stats / notes |
| --- | --- | --- | --- |
| Tserrina's Robe (Chest) | Tserrina Syl'Tor | NEC WIZ MAG ENC | **2-group** when she exists. AC 8 CHA +3 INT +6 HP +10 Mana +50 SV COLD +5 SV MAGIC +10. NO DROP. IdleQuest: **spawn broken** |
| Tserrina's Staff (2H Blunt) | Tserrina Syl'Tor | NEC WIZ MAG ENC | **2-group** when she exists. 12/52 (0.23), DEX +5 CHA +6 INT +10 HP +15 Mana +55, Specter Lifetap. NO DROP. IdleQuest: **spawn broken** |
| Tserrina's Key | Tserrina Syl'Tor | — | 1st-floor mirror → 7th-floor mirror room. NO DROP. IdleQuest: **spawn broken** (always on her table with Harnessed soul gem) |
| Abram's Axe of the Stoic (2H Slashing) | Incoherent Spirit | WAR PAL RNG SHD | 30/48 (0.62), AC 5 STA +15, Invigor. HUM BAR DWF TRL OGR HFL GNM |
| Talisman of Vhal Sera (Neck) | Vhal'Sera | BRD SHM NEC WIZ MAG ENC | AC 2 CHA +4 WIS/INT +3. No BAR DWF TRL OGR HFL. NO DROP |
| Large metal key | Vhal'Sera | — | 7th-floor key; also unlocks mirror-room exit. NO DROP |
| Magnetic Dirk of Distraction (Piercing) | Cara Omica | WAR RNG BRD ROG | 8/23 (0.35), STR +4 DEX +10 SV MAGIC +5, Distraction proc. NO DROP |
| Sorcerous Bowl (1H Blunt) | Cara Omica | NEC WIZ MAG ENC | 1/25 (0.04), CHA −5 WIS/INT +7 HP +50 Mana +10 |
| Small rusty key | Cara Omica | — | 5th-floor key. Always. NO DROP |
| Crystallized Shadow Tunic (Chest) | an angry chef | WAR CLR PAL SHD DRU MNK BRD ROG SHM | AC 18 STR +3 STA/CHA +2 WIS +3 HP +10 Mana +5. NO DROP |
| Ceremonial Wedding Sword (Primary) | Nosja | WAR PAL RNG SHD BRD ROG | STR +5 DEX/STA/AGI +3 SV MAGIC +6 |
| Three Toothed Key | Angry Librarian | — | 3rd-floor key. NO DROP |
| Crystal Key | Large Undead Gnoll | — | 2nd-floor key. NO DROP |
| Frosty key | Enraged Shadowbeast | — | 4th-floor key. NO DROP |
