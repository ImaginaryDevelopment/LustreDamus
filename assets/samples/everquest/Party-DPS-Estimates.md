# Party DPS estimates

Rough Classic / Kunark / Velious kill-speed guesses for named camps (Sebilis juggs, city nameds, etc.). Not a parser — just stacking assumptions.

A normal **party** caps at **6**. **ENC + BRD + 6 DPS** needs a **/raid** (8+ boxes). Raid buffs (Celerity, Clarity, songs, Tash / slow) still land on the other raid groups — that is the point of the bigger pack.

## Assumptions

- Same gear band on the DPS boxes (groupable Kunark / early Velious).
- **Two kinds of tables:**
  - **Burn packs** — no dedicated tank/cler. Fine when the mob dies fast, you FD / mez cheese, or a pet holds. Peak knife/nuke count.
  - **Camp parties** — assume a real **WAR (or SK) + CLR** unless noted. That is what most dungeon named camps actually run. Those two seats cost DPS; the rankings below treat them as fixed.
- **Haste** means spell / song haste on melee (Celerity, bard haste songs), not only worn. ENC + BRD together push melee toward the haste cap better than either alone.
- **Mana** for casters means Clarity (ENC) and/or bard mana song — potions exist but are not the plan.
- No charm pet DPS counted (mage / necro / enc pets are free DPS when they are up, but charm uptime is ignored). Mage / necro **own** pets count as part of that class’s burn.
- No AE train math — single-target burn.
- Adds / pulls / mez matter for *uptime*; pure burn rankings ignore that unless noted.
- Raid XP split is **worse** than a party — see [Raid XP](Raid-XP.md). This sheet ranks **burn / camp speed**, not XP/hour.

**Party math with tank + cler:** 6 seats − WAR − CLR = **4** left. Those four are where ENC / BRD / SHM / DPS compete. You do **not** get BRD + ENC + SHM + 3 ROG in a party unless you dropped the tank and cler.

### Fight length and DoTs

Nuke / backstab damage that lands after the mob is dead is wasted the same as leftover DoT ticks — but **DoTs are worse on short fights**. If the named dies in ~15–20s, a necro / shaman has often spent mana on spells that only got a fraction of their duration. On fat nameds / slow camps (minute+ burns), DoTs pay out and overkill risk drops.

Rule of thumb used below:

| Fight length | Favors |
| --- | --- |
| Short (trash / soft named) | Rogue / monk / wizard burst |
| Medium | Mage (pet + nukes), mixed SHM+melee |
| Long (fat named, high HP) | Necro / shaman DoTs + pets catch up or win sustained |

## Melee DPS seats (relative burn under haste)

Same Celerity / song stack; single target; groupable gear.

| Class | Burn | Notes |
| --- | --- | --- |
| **ROG** | **Best** | Backstab + dual wield. Biggest gain from attack-rate haste. Positioning matters |
| **MNK** | Strong | Fists / kick under haste; no BS ceiling, but excellent sustained. FD / Mend help camps |
| **RNG** | Good | Melee + bow + some spells. Behind ROG/MNK on pure burn; SoW / snare / track / pull utility |

Stacking: more of the **same** melee class under ENC+BRD still scales well. Mixing melee seats usually loses a little burn vs all-rogue, but monks are close enough that **ENC + BRD + mix of ROG/MNK** is nearly the all-rogue pack. Rangers dilute burn more; bring them for utility, not knife count.

## Rogue / monk / ranger packs (party of ≤6)

Burn-only seat math — **no WAR/CLR**. For real camps see **Camp parties** below.

| Comp | Burn speed | Sustained camp | Notes |
| --- | --- | --- | --- |
| ENC + 5 ROG | Strong | Good | Most knives a party can field under Celerity. No bard songs |
| ENC + 5 MNK | Strong | **Strong** | Slightly less peak than 5 ROG; better self-sustain / FD |
| ENC + 3 ROG | Strong | Good | Room for tank / heal |
| ENC + 3 MNK | Strong | Strong | Same idea; monks forgive bad pulls |
| BRD + 3 ROG | Strong | Strong | Song haste + pulls |
| BRD + 3 MNK | Strong | Strong | Same; less “need the rear” than rogues |
| BRD + ENC + 4 ROG | Good | **Best (party melee)** | Full song + Celerity; four knives |
| BRD + ENC + 4 MNK | Good | **Best (party monk)** | Nearly the rogue table; smoother camps |
| BRD + ENC + 2 ROG + 2 MNK | Good | Strong | Almost all-rogue burn; monks plug gaps |
| BRD + ENC + 3 ROG + 1 RNG | Good | Strong | One ranger for snare / SoW / bow; small burn loss |
| BRD + ENC + 4 RNG | Modest | Good | Utility party, not a burn race |
| 4 ROG (or 4 MNK) | Weakest | Weak | Fourth DPS rarely pays for missing real haste |

## Melee packs (raid — buff sharing)

| Comp | Burn speed | Sustained camp | Notes |
| --- | --- | --- | --- |
| BRD + ENC + 6 ROG (+ tank/heal → 10) | **Best overall melee** | Strong | Raid required. Six knives at stacked haste |
| BRD + ENC + 6 MNK (+ tank/heal → 10) | **Best overall monk** | **Strong** | Same seats; slightly less peak, better survival |
| BRD + ENC + 4 ROG + 2 MNK | Near-best | Strong | Fine hybrid; still needs raid for six melee + both supports |
| BRD + ENC + 6 ROG (8 total) | **Best overall** | Good | Same burn if the named dies before tank/heal matters |

**Why the 10-raid pack wins burns:** a party cannot hold ENC + BRD + six melee. Max party under both supports is **four** DPS seats. The raid adds **two more fully buffed** melee and keeps Celerity + songs on everyone in range.

**XP caveat:** each kill pays ~**half** a full party-of-6 share in a 10-raid (see Raid XP). You need roughly **2×** the kills/hour to match that party’s XP/hour. Six stacked melee often get there on **named / slow spawns**; on easy trash, two separate parties usually XP better.

## Caster DPS seats (relative burn with Clarity / Tash)

| Class | Short fights | Long fights | Notes |
| --- | --- | --- | --- |
| **WIZ** | **Best** | Strong | Biggest nukes. Mana hungry; Clarity / mana song matter |
| **MAG** | Strong | Strong | Nukes + pet. Pet keeps hitting when you’re drink / cast-locked; less “all or nothing” than wiz |
| **NEC** | Modest | **Best / near-best** | DoTs + pet + taps. Short fights waste DoT duration; fat nameds favor necro hard |

Tash (ENC) helps all three. Slow (SHM / ENC) helps pets and lengthens the window where DoTs finish safely without the mob enraging the tank as fast.

## Wizard / mage / necro packs (party of ≤6)

Burn-only — **no WAR/CLR**. Real camps: **Camp parties**.

| Comp | Burn speed | Sustained camp | Notes |
| --- | --- | --- | --- |
| ENC + 5 WIZ | Strong (short) | Good | Clarity + Tash on five nukers. No mana song |
| ENC + 5 MAG | Strong | **Strong** | Pets eat downtime; slightly softer burst than wiz |
| ENC + 5 NEC | Modest→Strong | **Best DoT camp** | Shines as fights get longer; FD / fear / root tools |
| ENC + 3 WIZ | Strong | Strong | Best small pure-nuke party |
| ENC + 3 MAG | Strong | Strong | Pet cushion |
| ENC + 3 NEC | Good→Strong | Strong | Better when nameds are chunky |
| BRD + ENC + 4 WIZ | Good | **Best (party nuke)** | Clarity + mana song + Tash |
| BRD + ENC + 4 MAG | Good | **Best (party pet-caster)** | Mana song + pets; great sustained |
| BRD + ENC + 4 NEC | Good (long) | **Best (party DoT)** | Short trash: overkill / wasted ticks; nameds: excellent |
| BRD + ENC + 2 WIZ + 2 MAG | Good | Strong | Burst + pet floor |
| BRD + ENC + 2 WIZ + 2 NEC | Good | Strong | Nukes open; DoTs finish — **best of both** on medium/long |
| 4 WIZ (or MAG/NEC) | Burst only | Weak | No Clarity → dry fast; no Tash → resists / weak hits |

## Caster packs (raid — buff sharing)

| Comp | Burn speed | Sustained camp | Notes |
| --- | --- | --- | --- |
| BRD + ENC + 6 WIZ (+ tank/heal → 10) | **Best short/medium** | Strong | Six Tashed / Clarity’d nukers + mana song |
| BRD + ENC + 6 MAG | Strong | **Strong** | Six pets + nukes; less spike than wiz, fewer dry spells |
| BRD + ENC + 6 NEC | Modest→**Best long** | **Best long** | DoT carpet on a fat named; weak if everything dies in seconds |
| BRD + ENC + 3 WIZ + 3 NEC | Strong | Strong | Nukes + DoTs; covers short and long camps |

Same XP caveat as melee: **faster burns**, **worse XP per kill**. Worth it for named loot camps; split parties for grind XP.

## Camp parties (WAR + CLR locked in)

Real dungeon camps (Sebilis juggs, city nameds, etc.) usually need a **tank and a cleric**. Party of 6 → only **four** free seats after WAR + CLR.

### Where the four seats go

| Priority | Seat | Why |
| --- | --- | --- |
| 1 | **ENC** | Celerity / mez / Tash — biggest single multiplier for melee or casters |
| 2a | **BRD** *or* **SHM** | Bard: haste songs, mana song, pulls. Shaman: **slow**, canbuff, emergency heal / DoT |
| 2b | The other of BRD/SHM if you can spare it | Full kit — but that leaves only **one** pure DPS seat |
| Rest | ROG / MNK / WIZ / MAG / NEC | Burn seats |

You pick **haste stack** (ENC+BRD), **slow** (ENC+SHM), or **both supports + one knife** (ENC+BRD+SHM+1 DPS). You cannot have ENC+BRD+SHM+3 ROG **and** WAR+CLR in one party.

### Party of 6 — WAR + CLR + …

| Comp (after WAR+CLR) | Burn | Camp feel | Notes |
| --- | --- | --- | --- |
| ENC + 3 ROG | Strong | Good | Max knives under Celerity. No bard songs, no shaman slow |
| ENC + BRD + 2 ROG | Good | **Best haste camp** | Songs + Celerity on two knives; bard pulls. Usual “we need tank+cler” melee race |
| ENC + SHM + 2 ROG | Good | **Best slow camp** | Slow + Celerity; safer tank, longer fights friendlier to SHM DoTs |
| ENC + BRD + SHM + 1 ROG | Modest | **Safest / smoothest** | Full support kit; one knife. Wins ugly camps, loses burn races |
| ENC + BRD + 2 MNK | Good | Strong | Same as 2 ROG haste camp; monks slightly less peak |
| ENC + SHM + ROG + NEC | Medium→Good | Strong | Short: rogue. Long: necro + shaman DoTs pay out |
| ENC + BRD + 2 WIZ | Good (short) | Good | Nuke camp with tank/cler; Clarity + songs |
| ENC + SHM + 2 NEC | Modest→Strong | Strong | Long nameds; soft trash wastes DoTs |
| ENC + 3 WIZ | Strong (short) | OK | No mana song; cler drinks too |

**Default call for most camps:** `WAR + CLR + ENC + BRD + 2 ROG` (or 2 MNK). Swap BRD→SHM when the named hits hard enough that **slow** matters more than a second song/haste layer or pull songs. Only drop to `ENC + BRD + SHM + 1 DPS` when survivability / control is the bottleneck.

### Burn-only mixed (no WAR/CLR) — for comparison

These match the pure burn tables earlier. Fine for soft targets, FD/mez cheese, or outdoor. **Not** the usual dungeon named setup.

| Comp | Notes |
| --- | --- |
| BRD + ENC + SHM + 3 ROG | Max mixed supports + knives — **no tank, no cler**. Patch-heal off SHM / mez off ENC only |
| ENC + SHM + 4 ROG | Same problem: four knives, zero WAR/CLR |
| ENC + SHM + 2 ROG + 2 NEC | Knives + DoTs, still no dedicated tank/cler |

**Why SHM + ROG + ENC still matters (inside the four free seats):** haste multiplies the rogue; **slow** multiplies how long the WAR holds and how little the CLR spends. Shaman DoTs are bonus on fat nameds and mostly wasted on 10s trash — you brought SHM for slow / backup heal, not for DoT DPS.

### Raid note

A **/raid** is how you keep WAR + CLR **and** ENC + BRD + SHM **and** several DPS: put tank/cler in one group, supports+DPS in others; buffs still land. That is the same reason the 10-box burn packs exist — see [Raid XP](Raid-XP.md) for the XP cost.

## Conclusions

| Goal | Comp |
| --- | --- |
| Fastest named burn (melee, ignore tank/cler) | **Raid: BRD + ENC + 6 ROG** (6 MNK close second) |
| Fastest short named (casters, ignore tank/cler) | **Raid: BRD + ENC + 6 WIZ** |
| Fastest long / fat named (casters) | **Raid: BRD + ENC + 6 NEC** (or 3 WIZ + 3 NEC) |
| Best **real party camp** (melee) | **WAR + CLR + ENC + BRD + 2 ROG** (or 2 MNK) |
| Best **real party camp** (hard-hitting named) | **WAR + CLR + ENC + SHM + 2 ROG** |
| Best **real party** full-support | **WAR + CLR + ENC + BRD + SHM + 1 DPS** |
| Best party caster camp (short, with tank/cler) | **WAR + CLR + ENC + BRD + 2 WIZ** |
| Best party caster camp (long, with tank/cler) | **WAR + CLR + ENC + SHM + 2 NEC** (or ROG+NEC) |
| XP / hour on trash | Stay in **parties** — do not raid for grind XP |
| Skip | All-DPS with no ENC/BRD haste or Clarity/Tash; all-DoT on soft trash; “best mixed” packs that quietly dropped WAR+CLR |

## Why the support boxes win

- **Melee:** attack-rate haste multiplies dual-wield, backstab, and monk kick frequency. In a real party you only fit **two** hasted DPS after WAR+CLR+ENC+BRD — that is still usually better than three unhasted knives.
- **Casters:** Clarity is uptime; **Tash** is effective DPS. Wizards win short burns; mages add pet floor; necros (and shaman DoTs) need **fight length** so ticks are not overkill.
- **Camp reality:** WAR + CLR lock two seats. The fight among the remaining four is ENC first, then BRD vs SHM vs more DPS.
- **Raid cost:** you pay the raid XP split to buy tank/cler **plus** full supports **plus** extra DPS seats — see [Raid XP](Raid-XP.md).
