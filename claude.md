# Maladum Party Tracker — Claude Guide

Flutter Web PWA for tracking party state in the Maladum board game. Offline-first, no backend.

**Authoritative docs** (read these before implementing anything non-trivial):
- `.docs/PRD.md` — product spec and widget tree
- `.docs/initial-requirements.md` — coding standards, functional rules, UI spec
- `.docs/TASKS.md` — phase-by-phase task list; mark tasks `[x]` as they complete

---

## Current Progress

- [x] Phase 1 — Project setup, dependencies, theme, Hive init
- [x] Phase 2 — Data models and unit tests
- [ ] Phase 3 — State management (next)

---

## Tech Stack

| Concern | Choice |
|---|---|
| Framework | Flutter Web |
| State | Riverpod (`NotifierProvider`) — no `setState` for business logic |
| Persistence | `hive_flutter` — auto-save on every mutation |
| Inventory grid | `flutter_staggered_grid_view` |
| Deployment | Static hosting (GitHub Pages / Firebase / Vercel) |

---

## Architecture Rules

These are the rules most likely to be broken accidentally — follow them in every file.

**Layer boundaries**
- `lib/models/` — pure Dart only, no Flutter imports, no UI
- `lib/providers/` — Riverpod notifiers only, no UI
- `lib/widgets/` — one widget per file, filename matches class name
- `lib/views/` — compose widgets only, zero business logic

**State**
- All mutations go through a Riverpod notifier. Widgets never write to model objects directly.
- Never expose a raw mutable `List` from a notifier — expose an unmodifiable view or a copy.
- Scoped providers: one provider per `Adventurer`, not one for the whole party, to avoid full-party rebuilds on a single stat change.

**Models**
- `gearSlots` is always `List.filled(4, null)`. `packSlots` is always `List.filled(10, null)`. Use the constants `maxGearSlots` and `maxPackSlots` — never inline the numbers.
- Slot volume constraints are enforced at the model/provider layer, not in UI.
- `StatusEffect` is a typed enum — never a raw string.
- `skillPegs` and `xpPegs` are separate fields on `Adventurer`.
- Rank thresholds live on `Adventurer.currentRank`, not in any widget.

**Inventory / innate items**
- Innate items (`isInnate: true`) can only be overwritten by armour (`ItemColor.yellow`). When overwritten, move the innate item to the pack if space exists; otherwise block with a `SnackBar`.
- Item trading: long-press `ItemTile` → "Give to [Adventurer]" context menu — no dedicated Trade Hub screen.

---

## Code Standards (summary — full rules in `initial-requirements.md`)

- Zero `flutter analyze` warnings before marking a task done.
- `dart format` with line length 80.
- `final` and `const` by default — mutability is intentional.
- No `dynamic` types.
- No `print()` — use a logging abstraction.
- Comments explain **why** only, one line max. No docstrings.
- Always pass `super.key` in widget constructors.

---

## UI Constants

| Token | Value |
|---|---|
| Scaffold background | `#1A1A1A` |
| Card surface | `#2C2C2C` |
| Primary accent | `#E65100` (amber) |
| Text primary | `#F5F5F5` |
| Text secondary | `#9E9E9E` |
| Danger | `#C62828` |
| Responsive breakpoint | 600px logical width |

Item tile border colors: Blue `#1565C0` · Red `#B71C1C` · Yellow `#F9A825` · Purple `#6A1B9A` · Grey `#546E7A`

---

## Verification

Run these before marking any task complete:

```
flutter analyze lib/
flutter test
```

Both must pass with zero issues.
