# Maladum Party Tracker

A companion web app for the **Maladum: Dungeons of Enveron** board game by Battle Systems. Track your party's stats, inventory, skills, and XP progression during a campaign — no paper, no pencil, no fiddling with tracking tokens.

**Live app:** [mtuxworth.github.io/maladum-party-tracker](https://mtuxworth.github.io/maladum-party-tracker/)

---

## Features

- **Party management** — Support for 1–4 adventurers side by side (desktop) or as swipeable cards (mobile)
- **Premade characters** — Choose from the 6 official adventurer boards (Syrio, Moranna, Greet, Ailah, Grogmar, Nerinda) and assign a class at creation
- **Stat tracking** — Health, Skill, Magic, and Action displayed with starting values, potential ceilings, and live current values adjusted in play
- **XP & levelling** — Per-character XP rows (one per rank, up to 5) with per-rank costs; level-up dialog awards a stat boost or skill unlock on each rank
- **Skill tree** — Full 9-category skill tree (Agility, Cunning, Endurance, Magic, Melee, Ranged, Stealth, Support, Survival) with tier prerequisites and peg-based activation
- **Inventory** — Gear slots (4) and pack slots (10) with colour-coded item tiles by type, innate item rules, and party item trading via long-press
- **Status effects** — Three typed status slots per adventurer (Poison, Bless, etc.)
- **Action points** — Two AP slots per adventurer, toggled in play
- **End quest** — One-tap rest that clears statuses, resets AP, recovers Magic, and prompts stat upgrades
- **Offline-first PWA** — Works without an internet connection; state persists across sessions via local storage

---

## Tech Stack

| Concern | Choice |
|---|---|
| Framework | Flutter Web |
| State | Riverpod (`NotifierProvider`) |
| Persistence | Hive (local storage, auto-save on every mutation) |
| Deployment | GitHub Pages (auto-deploy via GitHub Actions) |

---

## Running Locally

Requires [Flutter](https://docs.flutter.dev/get-started/install) (stable channel).

```bash
flutter pub get
flutter run -d chrome
```

To build a production release:

```bash
flutter build web --release --base-href /maladum-party-tracker/
```

---

## Project Structure

```
lib/
  models/      # Pure Dart data models (Adventurer, Skill, Equipment, etc.)
  providers/   # Riverpod notifiers — all business logic lives here
  widgets/     # Reusable UI components (one widget per file)
  views/       # Screen-level compositions and dialogs
```

---

## Notes

- Character stats on the physical adventurer boards take precedence over any placeholder values in the app — the stat data for some characters is marked as provisional pending confirmation from the physical boards.
- Skill icons are currently placeholder Material icons; the intent is to replace them with assets extracted from the official rulebook artwork.

---

*Maladum: Dungeons of Enveron is a product of [Battle Systems](https://battlesystems.co.uk/). This app is an unofficial fan-made companion tool and is not affiliated with or endorsed by Battle Systems.*
