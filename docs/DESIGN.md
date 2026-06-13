# GENERALS TD — Master Design Document

## 1. Vision Statement

You are a General. Your only job is defense. The enemy launches escalating combined-arms assaults — infantry waves, armor columns, air strikes, stealth infiltrators — and you survive them by building, upgrading, and commanding static defenses while spending your Generals' Powers on key moments. Three factions (USA, China, GLA) play fundamentally differently — not as palette swaps, but as different mental games. The fantasy is the late-mission moment in any Generals campaign where you've built up your defenses and watch your Patriots, your Gatling Cannons, your Stingers chew through a desperate enemy assault — except now that's the entire game.

## 2. Design Pillars

These five rules are non-negotiable. Every feature decision is checked against them.

1. **Faction identity over balance perfection.** USA, China, and GLA must require different strategies, different mental models, different play patterns — not just different stats on similar towers. A USA player and a GLA player should look at the same level and see different problems.
2. **Defense IS the strategy.** Generals' entire defensive vocabulary translates: linked defenses, garrisoned buildings, splash vs single-target, stealth detection, supply line vulnerability, power management. None of these get cut for simplicity. They are the game.
3. **Combined arms forces composition.** No "best tower" exists. Infantry, vehicles, aircraft, and stealth units each demand specific counters. The player must compose a layered defense, not stack one solution. If the player can win by building 20 of the same tower, the design has failed.
4. **Generals' Powers are the climax.** The big emotional moments aren't shooting individual tanks — they're calling an A-10 strike on a critical choke point, or watching a Particle Cannon sweep through an armored push. These limited-use abilities are the spice that makes each match memorable.
5. **Asymmetric enemy factions.** The enemy isn't generic — they're a specific Generals faction (USA, China, or GLA), and you can tell from the wave composition. A China assault is dense and slow with horde bonuses; a GLA assault uses stealth, suicide, and mob tactics; a USA assault is precise, expensive, and uses air power.

## 3. The Three Factions

This is the heart of the project. Each faction is a complete identity, articulated through tower roster, economy, special mechanics, and Generals' Powers.

### 3A. USA — High-Tech Linked Defense

**Identity in one phrase:** "Few defenders, each excellent, all networked."

**Strategic feel:** Expensive opening, irresistible late game. You build slowly and feel underdefended early, then everything falls into place around wave 4-5 and you're suddenly impervious.

**Signature mechanics:**

- **Linked defenses.** Patriots within range of each other share targeting data — when one locks on, all of them skip the lock-on delay. Encourages clustering.
- **Drones.** Several towers spawn small mobile drones (Sentry, Hellfire, Repair) that orbit nearby and add capability.
- **Laser systems.** Beam weapons that hit instantly, no projectile travel time. Excellent against fast targets.
- **Air superiority.** USA Generals' Powers are mostly aerial.

**Tower roster (initial design):**

| Tower | Role | Cost | Notes |
|-------|------|------|-------|
| Patriot Missile System | Anti-vehicle / anti-air | High | Links with other Patriots for shared targeting |
| Sentry Drone Pad | Anti-infantry, recon | Medium | Deploys auto-patrolling drone, reveals stealth in radius |
| Laser Turret | Anti-armor precision | High | Beam weapon, ignores armor, slow fire rate |
| Fire Base | Garrison structure | Medium | Holds 4 infantry "units" — adds DPS based on what's loaded |
| Avenger | Anti-missile / anti-air | High | Lasers down enemy projectiles before they hit |

**Generals' Powers (limited-use abilities):**

| Power | Effect | Cooldown |
|-------|--------|----------|
| Spy Drone | Reveals stealth in large radius for 30s | Short |
| A-10 Strike | Single bomb run on target line | Medium |
| Carpet Bomb | Massive bombing run, large area | Long |
| Particle Cannon | Superweapon. Beam sweeps target line for 10s, devastating | Very Long |

**Weakness:** Slow to build up. Cheap horde enemies (China-style) overwhelm before defenses online. Stealth bypasses linked Patriot networks.

### 3B. China — Concentration of Fire

**Identity in one phrase:** "Stack overlapping fields of fire until nothing gets through."

**Strategic feel:** Resource-rich and dense from the start. Many cheap towers stacked at choke points. Power management is constant pressure.

**Signature mechanics:**

- **Horde bonus for buildings.** Two or more Gatling Cannons within close range gain bonus fire rate. Encourages clusters.
- **Power grid.** Total power pool. Towers go offline if drained. Power plants are vulnerable.
- **Speaker Towers (buff towers).** Don't shoot — boost adjacent towers' fire rate.
- **Hackers.** Passive economy generation. Special "tower" that doesn't shoot, makes money.

**Tower roster:**

| Tower | Role | Cost | Notes |
|-------|------|------|-------|
| Gatling Cannon | Anti-infantry / anti-air | Low | Hitscan, spin-up delay, detects stealth |
| Bunker | Garrison fortification | Low | Holds 5 infantry, modular DPS |
| Inferno Tower | AOE flame, anti-infantry | Medium | DOT damage on path tiles |
| Speaker Tower | Buff | Medium | +30% fire rate to towers in radius |
| Nuke Cannon | Long-range siege | High | Slow fire rate, massive splash |

**Generals' Powers:**

| Power | Effect | Cooldown |
|-------|--------|----------|
| Cash Hack | Instant credit injection | Short |
| Artillery Barrage | Shells rain on target area for 5s | Medium |
| EMP Pulse | Disables vehicle enemies in area for 8s | Medium |
| Cluster Mines | Lays minefield on path segment | Medium |
| Nuclear Missile | Superweapon. Single nuke, large radius | Very Long |

**Weakness:** Power outages cripple defense. Long-range artillery enemies snipe Gatlings without being hit. Power Plants explode when destroyed, damaging nearby towers (a hidden cost of dense bases).

### 3C. GLA — Stealthy Asymmetric Survival

**Identity in one phrase:** "Cheap, hidden, never quite dead."

**Strategic feel:** Improvisation. You build trash that breaks easily, but it comes back. Salvage from enemy kills. Stealth and traps. No power management at all.

**Signature mechanics:**

- **No power requirement.** Build anywhere, anytime, no infrastructure tax.
- **Building holes.** When a tower is destroyed, it leaves a "hole." If the hole isn't destroyed within 30 seconds, the tower auto-rebuilds at half cost.
- **Salvage.** Each enemy killed within range of a GLA tower drops salvage. Workers automatically collect; salvage gives bonus credits or upgrades random towers.
- **Stealth defenses.** Several GLA towers are stealthed by default — invisible to enemies until they fire.

**Tower roster:**

| Tower | Role | Cost | Notes |
|-------|------|------|-------|
| Stinger Site | Anti-vehicle / anti-air | Low | 3 rockets, operated by infantry — vulnerable to snipers |
| Tunnel Network | Multi-purpose | Medium | Garrison troops, redirect a path tile, or spawn ambush units |
| Demo Trap | Single-use mine | Very Low | Stealthed proximity bomb, reusable after 15s cooldown |
| Toxin Trap | Path AOE | Low | Toxic cloud, DOT damage on path tile |
| Scud Launcher | Long-range artillery | Medium | Splash damage, slow fire rate |

**Generals' Powers:**

| Power | Effect | Cooldown |
|-------|--------|----------|
| Rebel Ambush | Spawns infantry units to intercept enemies | Short |
| Sneak Attack | Deploys tunnel network at any location instantly | Medium |
| Anthrax Bomb | Toxic cloud DOT on target area for 20s | Medium |
| GPS Scrambler | Stealths all friendly towers for 30s | Medium |
| SCUD Storm | Superweapon. 8-missile barrage on target line | Very Long |

**Weakness:** Stealth-detection towers (USA Spy Drone, China Gatling) reveal you. Anti-infantry snipes Stinger operators, disabling Stingers without destroying them. Trap-heavy strategies fall apart against air units.

## 4. Enemy Catalog (Wave Composition)

The enemy faction varies per mission/wave-set. The player's defenses must compose to handle all four enemy categories:

**Infantry** — cheap, slow, many. Primary counter: Gatling Cannons, Bunkers, AOE.

- Examples: Red Guard (China), Rebels (GLA), Rangers (USA)

**Vehicles** — armored, medium speed, single targets. Primary counter: Patriots, Stingers, Laser Turrets.

- Examples: Battlemaster Tank (China), Crusader (USA), Scorpion (GLA), Technical (GLA, fast)

**Aircraft** — fast, fly over obstacles, ignore ground-only towers. Primary counter: AA towers (Stinger, Patriot, Gatling).

- Examples: Comanche (USA), MiG (China), no GLA aircraft (GLA aerial threat = SCUD)

**Stealth/Special** — invisible without detection, special mechanics. Primary counter: Detection towers, anti-everything.

- Examples: Stealth Fighter (USA), Hijacker (GLA), Terrorist (GLA, suicide), Toxin Tractor (GLA, AOE)

**Hero/Boss units** appear at wave milestones (every 5 waves):

- Black Lotus (China hacker — disables a tower temporarily)
- Jarmen Kell (GLA sniper — kills tower operators from outside range)
- Colonel Burton (USA commando — places explosives on towers)

## 5. Economy

Three-source economy:

1. **Wave stipend** — base credits each wave for surviving (scales with wave number).
2. **Kill bounty** — credits per enemy killed (small, scales with enemy strength).
3. **Capturable nodes** — Oil Derricks placed on the map. If the player builds a tower covering one, they get passive income while it's defended. Enemies can target the derrick.

**Faction modifiers:**

- USA: 90% base income, but +50% from Oil Derricks (incentivizes capture/defense)
- China: 100% base income, +1 free "Hacker" tower at wave 3 that passively generates
- GLA: 110% base income from kill bounties (salvage), can't capture Oil Derricks but can build Black Market for paid one-time upgrades

## 6. Tech Tree & Upgrades

Each tower has 3 upgrade tiers:

- **Tier 1:** As placed.
- **Tier 2:** Better stats. (~70% of original cost.)
- **Tier 3:** Adds a unique secondary effect. (Same cost as T2.)

**Examples:**

- Patriot T2: +25% range, +25% damage.
- Patriot T3: Splash damage on impact (small radius).
- Gatling T2: Faster spin-up, +50% fire rate.
- Gatling T3: Adds anti-air missile rack as secondary weapon.
- Stinger T2: 4 rockets instead of 3.
- Stinger T3: Operators are stealthed when not firing.

Upgrades only available after wave milestones (T2 unlocks after wave 3, T3 after wave 5) — keeps progression structured.

## 7. Map / Path Design Philosophy

Maps are designed around three principles:

1. **Branching paths with choke points.** The Generals games featured terrain-driven choke points (bridges, narrows, base entrances). Every map has 1-3 spawn points and the paths from them must converge or interact at chokepoints where defenses get value.
2. **Build zones, not free placement.** Towers can be placed only on designated tiles. This isn't a limitation — it's a design tool. Where the build zones are determines the strategic shape of the level. Terrain (rivers, mountains, ruined cities) dictates the build layout.
3. **Capturable terrain.** Oil Derricks, Tech Buildings (garrisonable for a free defensive emplacement), and Salvage Crates are placed on maps. They're worth fighting to defend.

## 8. Game Modes

**Campaign** (3 sets of 7 missions each, one per playable faction). Generals' campaign structure inverted: instead of attacking, you defend specific locations against escalating waves. Each mission has a story beat (intel briefing, mission objective beyond just survival).

**Skirmish** — pick faction, pick map, set difficulty, defend.

**Generals' Challenge** — like Zero Hour's mode. Pick your General (faction sub-specialty: USA Air Force / Laser / Superweapon, China Tank / Nuke / Infantry, GLA Demo / Toxin / Stealth). Each general has a slightly different tower roster and powers.

## 9. Visual Direction

Three distinct aesthetic languages, faithful to the source:

- **USA:** Clean blues and whites. Modern military prefab buildings. Holographic UI elements. Drones with blinking lights. Laser effects in red/blue.
- **China:** Reds and yellows. Brutalist concrete towers. Propaganda banners on Speaker Towers. Heavy industrial feel. Bullet tracers everywhere. Nuclear-green glow on China endgame towers.
- **GLA:** Tans, browns, dust. Ramshackle, mismatched, looks scavenged. Tents, shipping containers, makeshift camo netting. Sandstorms in environment. Toxic green for chemical weapons.

Maps reflect campaign geography: USA defends modern cities and bases; China defends industrial centers, Three Gorges Dam areas, hill fortresses; GLA defends desert, urban ruins, refugee-camp-style strongholds.

## 10. Audio Direction

Each faction has its own musical identity:

- **USA:** Orchestral, triumphant, brass-forward, militaristic
- **China:** Apocalyptic orchestra with East Asian percussion and instruments
- **GLA:** Middle Eastern strings layered with heavy metal guitars during action

**SFX:** Each faction's units have distinct sound profiles. Patriot launch ≠ Stinger launch ≠ Gatling spin-up. This is non-negotiable.

## 11. Reconciling with the Current Build

What we have today:

- One generic tower → represents the USA Patriot Missile System (placeholder mesh)
- One generic enemy → represents a China Battlemaster Tank (placeholder mesh)
- Two parallel paths → simplest possible level, valid as Mission 1's geometry
- Wave system + base health → core loop foundation, faction-agnostic

The current implementation is the USA prototype faction, mission 1, against China enemies, with all visuals as placeholders. Everything we've built is reusable; we're filling in identity, not refactoring.

## 12. Roadmap (Aligned to Pillars)

This isn't a fixed timeline. Each item is a session or two of work.

**Near-term (validate the fantasy):**

1. Click-to-place towers + economy (the missing interactivity)
2. Three tower types per faction (start with USA: Patriot, Sentry Drone, Fire Base)
3. Two enemy types: Infantry (Red Guard) and Vehicle (Battlemaster), so combined arms exists
4. First Generals' Power: A-10 Strike (the simplest, most dramatic ability)

**Mid-term (deepen the game):**

5. Tower upgrades (T2/T3)
6. Anti-air enemy type (Comanche) and AA-only towers
7. Stealth enemy + detection mechanic
8. Faction selection screen with visual differentiation
9. China faction implemented (towers, powers, mechanics)

**Long-term (round it out):**

10. GLA faction implemented
11. 3-5 hand-designed maps with terrain and Oil Derricks
12. Hero / boss enemies
13. Superweapons (one per faction, end-of-mission moments)
14. Campaign structure with mission briefings

## 13. Open Design Questions

Things we'll revisit as we play:

- Should the player choose their faction per mission, or play a campaign locked to one?
- Are Generals' Powers tied to a "Generals' Promotion" rank that increases per wave (Generals 1) or recharged on cooldown (TD-style)?
- How do we represent power outages visually for China? Towers literally turn off / dim?
- GLA's salvage mechanic: automatic, or requires the player to build/manage salvage workers?
- Difficulty: classic (Easy/Normal/Hard difficulty multipliers) or Generals'-style (different missions, not just different numbers)?

## 14. Core Loop Summary

To anchor everything else: a complete play session is 7 missions = ~30-60 minutes per campaign. Within a single mission:

1. Briefing (text + map preview) — 30s
2. Build phase (PRE_GAME) — player places initial towers with starting credits
3. Wave loop (×N waves):
   - Player presses N to start wave
   - Enemies spawn, defenses engage
   - Player calls Generals' Powers if needed
   - Wave clears → credits earned, build/upgrade between waves
4. Final wave / boss — climactic assault
5. Victory or defeat screen

## Design v2 — Survival Mode Rework

### Core Reframe: Survival Mode TD

Generals TD is not "Kingdom Rush with C&C aesthetics." It is the Generals survival/economy multiplayer mode, single-player, structured as a tower defense. The player builds infrastructure (Supply Centers, Power Plants, Hackers, Black Markets) AND defenses, scales economy outward, and survives escalating waves. The economy IS the strategy: each "build another defense or another supply line?" decision is the central tension.

### Full Generals Unit Translation

Every Generals unit gets a role: defensive tower, economy building, enemy, hero, Generals' Power, or decorative set dressing. Detailed roster:

#### USA — High-Tech Linked Defense
Power model: SOFT requirement. Cold Fusion Reactor (600c, +5 power). Underpowered towers fire at -25% rate (never shut off).

Economy buildings:
| Building | Cost | Effect |
|---|---|---|
| Supply Center | 800 | Chinook every 12s; +60 credits/sec (max 3) |
| Cold Fusion Reactor | 600 | +5 power capacity |
| Strategy Center | 1500 | Tech building — unlocks T2/T3; +10/sec passive |
| Detention Camp | 1000 | -10% cost on all future towers |

Towers:
| Tower | Cost | Range | Fire rate | Damage | Notes |
|---|---|---|---|---|---|
| Patriot Missile System | 75 | 10 | 1.0/s | 12 | 0.5× vs infantry, 1.5× vs vehicles. Patriots within 8 units share targeting (instant lock). |
| Sentry Drone Pad | 50 | 8 | 3.0/s | 4 | 1.5× vs infantry, 0.6× vs vehicles. Detects stealth. |
| Fire Base | 120 | 7 | 0.5/s | 35 | 1.0× both. T3: holds 4 virtual infantry, +5 damage each. |
| Avenger | 150 | 9 | 2.0/s | 8 | Anti-air specialist; intercepts enemy projectiles. |
| Tomahawk Storm | 200 | 18 | 0.3/s | 50 splash | 3-unit splash artillery. Requires Strategy Center for T3. |

Generals' Powers:
| Power | Cooldown | Effect |
|---|---|---|
| Spy Drone | 60s | Reveals stealth in 8-radius for 30s |
| Paradrop | 90s | 5 friendly Rangers auto-attack nearby enemies, 30s |
| A-10 Strike | 120s | Bomb run on target line, 30 damage, 6-unit radius |
| Carpet Bomb | 180s | 60 damage, 10-unit radius |
| Particle Cannon | 600s | Superweapon (requires Strategy Center). Beam sweeps line 10s, 200 dmg/s |

#### China — Concentration of Fire
Power model: HARD requirement. Nuclear Reactor (800c, +10 power, explodes on death: 50 damage to towers in 5-unit radius). Underpowered towers fully shut off.

Economy buildings:
| Building | Cost | Effect |
|---|---|---|
| Supply Center | 1000 | +50 credits/sec |
| Nuclear Reactor | 800 | +10 power; dangerous on death |
| Hacker Hut | 700 | +20 credits/sec; spawns decorative hacker |
| Propaganda Center | 1500 | Tech building — unlocks T2/T3; +20% Speaker Tower radii |
| Internet Center | 2000 | +50 credits/sec; low HP, high-risk economy |

Towers:
| Tower | Cost | Range | Fire rate | Damage | Notes |
|---|---|---|---|---|---|
| Gatling Cannon | 60 | 7 | 4.0/s (2s spin-up) | 3 | Anti-infantry/air, detects stealth. Horde bonus: +25% fire rate with 2+ Gatlings within 5 units. |
| Bunker | 50 | 6 | 1.5/s | 6 | Garrisonable. T3: 5 infantry, +4 damage each. |
| Speaker Tower | 120 | — | — | — | Buff: towers within 6 units gain +30% fire rate. |
| Inferno Cannon | 180 | 8 | 0.6/s | 8 + 4/s DOT 5s | 3-unit splash. Devastating vs grouped infantry. |
| Nuke Cannon | 250 | 20 | 0.2/s | 80 splash | 5-unit radius siege. T3: radiation 5/s DOT for 8s. |

Generals' Powers:
| Power | Cooldown | Effect |
|---|---|---|
| Cash Hack | 60s | Instant +200 credits |
| Cluster Mines | 90s | 8 mines on path segment, 25 damage each |
| Artillery Barrage | 120s | 8 shells over 5s, 15 damage each, 4-unit radius |
| EMP Pulse | 150s | Disables vehicle enemies in 8-radius for 8s |
| Frenzy | 180s | Towers in 10-radius +50% fire rate for 15s |
| Nuclear Carpet Bomb | 240s | 80 damage area + 10/s DOT for 10s |
| Nuclear Missile | 600s | Superweapon (requires Propaganda Center). 300 damage, 15-unit radius, radiation |

#### GLA — Stealthy Asymmetric Survival
Power model: NONE. No power infrastructure at all.

Economy buildings:
| Building | Cost | Effect |
|---|---|---|
| Supply Stash | 600 | +40 credits/sec; up to 5 stashes (other factions cap at 3 Supply Centers) |
| Black Market | 1200 | +25 credits/sec + one-time upgrades (e.g. "Arm The Mob": +30% damage to anti-infantry towers) |
| Palace | 1500 | Tech building — unlocks T2/T3. Garrisonable. |
| Arms Dealer | 1000 | Decorative; small cost reduction on Stinger Sites |

Towers:
| Tower | Cost | Range | Fire rate | Damage | Notes |
|---|---|---|---|---|---|
| Stinger Site | 70 | 9 | 1.5/s | 10 | Infantry-operated; enemies with snipe capability disable temporarily. |
| Tunnel Network | 100 | — | — | — | Garrisonable; can spawn Rebel Ambush at another tunnel. |
| Demo Trap | 40 | — | — | 60 | Stealthed proximity mine; 15s rearm cooldown. |
| Toxin Trap | 90 | 4 AOE | — | 3/s DOT | Camouflaged. T3: stronger toxin + slow. |
| SCUD Launcher | 220 | 22 | 0.15/s | 70 splash | 4-unit radius artillery. |

Signature mechanics:
- Building Holes: destroyed GLA tower leaves a hole (10 HP). If the hole survives 30s, the tower auto-rebuilds at 50% cost.
- Salvage: kills near GLA towers drop salvage; every 3 salvage = random tower +10% damage permanently (max +50%).

Generals' Powers:
| Power | Cooldown | Effect |
|---|---|---|
| Rebel Ambush | 60s | 4 Rebels at target point, 30s |
| Cash Bounty | 90s | +50% kill bounties for 30s |
| Sneak Attack | 120s | Builds Tunnel Network anywhere instantly |
| Emergency Repair | 120s | Towers in 6-radius restored to full HP |
| Anthrax Bomb | 150s | Toxic cloud 6/s DOT for 20s, 8-radius |
| GPS Scrambler | 180s | Stealths all friendly towers 30s |
| SCUD Storm | 600s | Superweapon (requires Palace). 8 missiles, 50 damage each + toxin aftermath |

#### Enemy Roster (baseline stats; multiplied by wave health/speed modifiers)

Infantry:
| Unit | Faction | HP | Speed | Dmg to base | Bounty | Notes |
|---|---|---|---|---|---|---|
| Red Guard | China | 12 | 6 | 1 | 3 | In game |
| Ranger | USA | 15 | 5 | 1 | 4 | |
| Rebel | GLA | 10 | 7 | 1 | 3 | |
| RPG Trooper | GLA | 18 | 4 | 2 | 5 | |
| Tank Hunter | China | 20 | 4 | 2 | 5 | |
| Terrorist | GLA | 8 | 8 | 5 | 2 | Suicide burst damage on reach |

Vehicles:
| Unit | Faction | HP | Speed | Dmg to base | Bounty | Notes |
|---|---|---|---|---|---|---|
| Battlemaster Tank | China | 40 | 3 | 2 | 8 | In game |
| Crusader | USA | 50 | 3.5 | 2 | 10 | |
| Scorpion | GLA | 30 | 4 | 2 | 7 | |
| Technical | GLA | 22 | 7 | 1 | 5 | Fast |
| Overlord Tank | China | 120 | 2 | 5 | 25 | Heavy, rare |
| Paladin | USA | 80 | 2.5 | 4 | 18 | |

Aircraft (fly over obstacles, ignore ground-only towers):
| Unit | Faction | HP | Speed | Dmg to base | Bounty |
|---|---|---|---|---|---|
| MiG | China | 35 | 9 | 3 | 12 |
| Comanche | USA | 30 | 8 | 3 | 10 |
| Helix | China | 60 | 5 | 4 | 15 |

GLA has no aircraft (historical accuracy preserved).

Heroes/Bosses (milestone waves): Black Lotus (China — temporarily disables a tower), Jarmen Kell (GLA — snipes tower operators from outside range), Colonel Burton (USA — plants explosives on towers).

Decorative buildings (map set dressing): USA — Command Center, War Factory, Airfield with parked Raptors. China — Command Center, War Factory, Airfield with MiGs, Nuclear Missile Silo. GLA — Command Center, tunnel entrances, Arms Dealer, Black Market tents.

### Economy System

Three layers:
1. Supply Centers (Layer 1, core early/mid-game): USA Chinook +60/sec, China Truck +50/sec, GLA Stash +40/sec (up to 5 stashes)
2. Faction-specific late-game (Layer 2): USA Oil Derricks, China Hackers, GLA Black Market
3. Kill bounties (Layer 3, 10-20% of total income)

Credit scale: Generals-authentic pricing adopted in Step 9 (towers 500-1200, Supply Center 800 with +120/12s Chinook deliveries, max 3). Original draft numbers superseded. Flat wave stipend removed.

### Wave Pacing (TD Best Practices)

- Wave duration: 30-60 seconds active spawning
- NEVER all-same-enemy waves — always mix at least 2 types
- Inter-wave pause: 15-30 seconds, with "press N for +25 credit early-start bonus"
- Next-wave preview shown in HUD
- Total session: 20-40 min, 20-30 waves
- Boss waves every 5 waves: Black Lotus, Jarmen Kell, Colonel Burton

### Damage Type Triangle

Tower types: Anti-Infantry / Anti-Vehicle / Anti-Air / Splash-AOE
Each strong vs specific enemy types, weak vs others
Player must compose layered defense

### Tower Upgrade Tiers

T1 (placed) → T2 (+25% damage/range, 75% cost) → T3 (unique mechanic, same cost as T2)
T2 unlocks after wave 5, T3 after wave 10 + tech building (Strategy Center / Propaganda Center / Palace)

### Development Roadmap

Step 8: Playability (health bars, 15 waves, early-start bonus) — DONE
Step 9: Economy rework — DONE (power plants moved to Step 9b)
Step 10: Tower variety expansion (Avenger, Tomahawk; first aircraft enemy; T2/T3 upgrades)
Step 11: Generals' Powers (A-10 Strike, Spy Drone, HUD power buttons)
Step 12: China faction implementation
Step 13: GLA faction implementation
Step 14+: Maps, polish, content

### Open Design Questions

1. Power mechanic asymmetry: USA soft / China hard / GLA none — recommended faction-asymmetric
2. Tower selling: 75% refund recommended, upgrades non-refundable individually
3. Placement freedom: free placement with path buffer zone (current implementation) is correct
4. Wave preview detail: count + dominant type ("12 Battlemaster + 8 Red Guard, China assault")
5. Endless vs fixed: 25 fixed waves = campaign mission; endless mode unlocked after first win
