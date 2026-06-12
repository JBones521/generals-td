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
Project initialized, empty. No scenes built yet. Next step: basic test scene to verify pipeline.
