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
