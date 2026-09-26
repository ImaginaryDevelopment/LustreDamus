# Raid XP vs party XP

Classic / Kunark / Velious **per-kill** experience when you `/raid` instead of staying in a normal **group** (party of ≤6).

Era note: numbers use the **14 Jan 2001** (Velious) group-bonus table SoE published. That is the right band for this sample set. A much friendlier group bonus landed in **May 2003** (PoP); if your server uses that, party XP is better than below and the raid penalty vs party is worse.

## How it works

1. Mob yields **base XP** (then × ZEM, con, etc.).
2. **Party:** apply a **group bonus** to the pool, then split among party members (by level after the 2001 split change).
3. **Raid:** the pool is shared across **everyone in the raid**. Community consensus (and SoE-era discussion): raid mode **does not get the group bonus**. Early raid XP had an extra penalty; that extra hit was removed, but **losing the bonus remains**.

So the raid “penalty” is: **more mouths on the same pie, and no group-bonus frosting** — unless kill speed from shared buffs pays you back (below).

### Velious-era group bonus (party only)

| Party size | Bonus on pool |
| ---: | ---: |
| 2 | +2% |
| 3 | +6% |
| 4 | +10% |
| 5 | +14% |
| 6 | +20% |

Bonus hits the **total** before the split. Equal-level party of 6 → each gets `1.20 / 6 = 20%` of what a solo would get from that kill.

## Equal-level per-kill split

Fix solo credit for one kill at **100**. Same-level characters only.

| Setup | Pool | Each person | vs solo | vs full party of 6 |
| --- | ---: | ---: | ---: | ---: |
| Solo | 100 | 100 | 100% | — |
| Party of 6 | 120 | **20** | 20% | **100%** (baseline) |
| Tiny raid of 6 | 100 | **16.7** | 16.7% | **~83%** (−17%) |
| Raid of 10 | 100 | **10** | 10% | **50%** (−50%) |

### Tiny raid (6 in raid grouping)

Same six people, raid window instead of one party:

- You **lose the +20% group bonus**.
- Split is still six ways.
- Per kill you get about **5/6** of what the same people get as a normal full group (~**17% less**).
- Buff coverage is **the same** as a party of 6 — you gain nothing.

There is almost never an XP *or* buff reason to `/raid` six people. Stay in a **party**.

### Raid of 10 — split vs buffs

Ten equal-level raiders, no group bonus:

- Each gets **10%** of solo per kill → **half** a full party-of-6 share.
- On paper you need **~2×** kills/hour to match that party’s XP/hour.

**But** a raid can field buffs a party cannot. Max party is 6, so **ENC + BRD + 6 rogues** (8) plus tank/heal (**10**) only fits in a raid. Celerity, songs, Clarity, and Tash still hit the other raid groups.

| Pack | Knives / nukes under ENC+BRD | Fits in |
| --- | ---: | --- |
| Party `BRD + ENC + 4 ROG` | 4 stacked | Party |
| Party `ENC + 5 ROG` | 5 (Celerity only) | Party |
| Raid `BRD + ENC + 6 ROG` (+ tank/heal) | **6 stacked** | Raid of ~8–10 |

Same story for wizards: party tops out around **four** stacked nukers (`BRD + ENC + 4 WIZ`) or **five** under ENC only; raid fields **six** under both supports.

Rough burn read (see [Party DPS](Party-DPS-Estimates.md)): six stacked rogues often kill **~1.3–1.5×** as fast as the best six-box melee party (four stacked or five Celerity-only), sometimes more on fat nameds. XP/hour ≈ `(kills/hour) × (XP/kill)`:

| If 10-raid kill rate vs party-of-6 is… | Net XP/hour vs that party |
| --- | --- |
| 1.0× (same speed) | **~50%** — raid loses badly |
| 1.5× | **~75%** — still behind on XP |
| **2.0×** | **~100%** — break-even on XP |
| 2.5×+ | Ahead on XP **and** burns |

So the 10-raid pack is often **best for named loot / burn camps** (you wanted ENC+BRD on six DPS). It is **not** automatically best XP/hour — you need about **double** the party’s kill rate to cancel the split. Easy trash: stay in parties. Slow / high-HP nameds where six stacked DPS actually doubles clear speed: raid can break even or win.

If those 10 only care about grind XP and the camp is easy, two parties (e.g. 6 + 4) keep group bonuses and skip the raid split.

## Uneven levels

Shares scale with **level** (post-2001). A higher-level raider takes a larger slice; lower-level boxes get less than the equal-level table. Race XP mods are personal after the split; they are not the raid penalty.

## Practical conclusions

| Goal | Do this |
| --- | --- |
| XP / hour on easy trash | **Parties only.** Do not raid. |
| 6 boxes, already enough DPS | One **party of 6** — not a 6-person raid. |
| ENC + BRD + 6 ROG/WIZ on one named | **/raid** (~8–10). Best burn; XP/kill is ~half a full party — need ~2× kill rate to match XP/hour. |
| Raid bosses / locked raid loot | Take the XP hit; you are there for the kill and drops. |

**Per kill:** tiny raid of 6 ≈ **83%** of party-of-6 XP (no buff upside). Raid of 10 ≈ **50%** of party-of-6 XP, but can field **ENC + BRD + 6 DPS** that a party cannot.
