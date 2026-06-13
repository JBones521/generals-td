# Generals TD — Project Context

## Overview
A top-down 3D tower defense game inspired by Command & Conquer Generals. Built in Godot 4.x.

## Design Authority
The complete game design lives in docs/DESIGN.md. That document defines vision, faction identities, tower/enemy catalogs, economy, and roadmap. Treat it as the source of truth for creative decisions. CLAUDE.md (this file) is operational guidance for working in the repo. DESIGN.md is the design itself. When implementing features, check DESIGN.md to understand the intent, not just the immediate request.

DESIGN.md has been expanded with v2 — survival mode focus, full Generals unit translation, faction economies. v1 sections retained but v2 is the active design.

## Gameplay
- View: Top-down 3D, fixed camera
- Style: Branching path tower defense (multiple enemy routes, choke points)
- Factions: USA, China, GLA — all three playable. Architect for all three from day one using a Faction resource system, but build USA first as the prototype. Adding factions later should be data-driven, not require refactoring.

## Art Direction
- Current phase: Placeholder primitives ONLY (colored boxes, cylinders, spheres). Do not spend effort on art yet.
- Future phase: Real models will replace primitives later.

## Developer Context
- Solo developer working across two PCs (laptop and home PC) via this Git repo.
- No prior game coding experience. Explanations should be step-by-step.
- Avoid time estimates — they consistently miss.

## Workflow Conventions
- Commit and push after every meaningful change to keep PCs in sync.
- Clear commit messages describing what changed and why.
- Always `git pull` at the start of a session.

## Current Status
Steps 1-8 complete: full core loop playable. Branching paths, three USA towers, two China enemies with damage-type modifiers, click-to-place with validation, economy (credits/bounties/stipends), 15-wave progression with mixed compositions, enemy health bars, early-start bonus with countdown, next-wave preview, restart flow. Towers target the enemy furthest along its path. Debug logging gated behind GameState.DEBUG_LOGGING. Step 9 complete: Supply Center economy with animated Chinook deliveries replaces wave stipends; credit scale ×10; PlaceableData base resource for towers and buildings. Balance pass: compounding difficulty curve (1.12^wave), Tank Hunter and Overlord enemies added, boss waves at 5/10/15, sqrt-scaled bounties. Step 10a complete: T2/T3 tower upgrades with wave + Strategy Center gating, tower selection with info panel, selling at 75% refund, Strategy Center building (+10/sec, unlocks T3). Next: Step 10b — Comanche aircraft enemy, Avenger AA tower, air targeting.
