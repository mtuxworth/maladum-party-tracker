# Maladum Party Tracker — Task List

Status legend: `[ ]` To Do · `[~]` In Progress · `[x]` Done

---

## Phase 1 — Project Setup

- [x] 1.1 Create Flutter project (`flutter create maladum_tracker`)
- [x] 1.2 Add dependencies to `pubspec.yaml`: `flutter_riverpod`, `hive_flutter`, `flutter_staggered_grid_view`
- [x] 1.3 Set up folder structure: `lib/models`, `lib/providers`, `lib/widgets`, `lib/views`, `assets/images/items`
- [x] 1.4 Configure `ThemeData` — Dungeon Dark theme (scaffold `#1A1A1A`, primary amber)
- [x] 1.5 Wrap `main()` in `ProviderScope` and initialize Hive

---

## Phase 2 — Data Models (`lib/models/`)

- [x] 2.1 Define enums: `ItemColor`, `Rarity`, `StatusEffect`
- [x] 2.2 Implement `MaladumStat` class (starting / current / max, `toJson`, `fromJson`)
- [x] 2.3 Implement `EquipmentItem` class (id, name, color, rarity, slots, isInnate, `toJson`, `fromJson`)
- [x] 2.4 Implement `Adventurer` class:
  - [x] 2.4a Fields: name, characterClass, health, magic, skill, action, xpPegs, skillPegs
  - [x] 2.4b Fixed-size lists: `gearSlots = List.filled(4, null)`, `packSlots = List.filled(10, null)`
  - [x] 2.4c Typed status slots: `List<StatusEffect?> statusSlots = [null, null, null]`
  - [x] 2.4d Computed properties: `usedGearVolume`, `usedPackVolume`, `currentRank`
  - [x] 2.4e `toJson` / `fromJson` (full serialization including all lists)
- [x] 2.5 Implement `PartyState` model (list of Adventurers, party name)
- [x] 2.6 Write unit tests for stat logic, rank thresholds, and volume calculations

---

## Phase 3 — State Management (`lib/providers/`)

- [x] 3.1 Create `AdventurerNotifier` (Riverpod `Notifier`) — manages a single Adventurer's mutable state
- [x] 3.2 Create `PartyNotifier` (Riverpod `Notifier`) — manages the list of Adventurers
- [x] 3.3 Implement Hive persistence layer:
  - [x] 3.3a Auto-save party state on every mutation
  - [x] 3.3b Load saved party on app start
- [x] 3.4 Implement JSON export (serialize `PartyState` → file download trigger for web)
- [x] 3.5 Implement JSON import (file picker → deserialize → replace `PartyState`)

---

## Phase 4 — App Shell & Navigation (`lib/views/`)

- [x] 4.1 Implement `MainScaffold` with `AppBar` (Import / Export / Rest buttons) and `Drawer`
- [x] 4.2 Implement `ResponsiveLayout` widget (breakpoint: 600px → `DesktopView` or `MobileView`)
- [x] 4.3 Implement `DesktopView` — `Row` of `AdventurerCard` widgets (1–4 players, `Expanded`)
- [x] 4.4 Implement `MobileView` — `PageView` with `TabBar` showing character names
- [x] 4.5 Implement "Add Adventurer" flow (form: name, class selection, starting stats)
- [x] 4.6 Implement Drawer — switch between saved parties

---

## Phase 5 — Adventurer Dashboard (`lib/widgets/`)

### 5.1 Header
- [x] 5.1a `CharacterHeader` — portrait (`CircleAvatar`), name, class, rank badge
- [x] 5.1b `XPTracker` — `Wrap` of 21 `XPPeg` widgets (3 tiers, color-coded), rank-up icons at peg 3 and 7 of each tier

### 5.2 Battle Controls
- [x] 5.2a `StatCounter` — current (large), max (small), +/− buttons with cap enforcement
- [x] 5.2b `StatGrid` — `Row` of 4 `StatCounter` widgets (Health, Magic, Skill, Action)
- [x] 5.2c `APCircle` — tap to toggle `isSpent` (dim) state
- [x] 5.2d `ActionPointTracker` — row of 2 `APCircle` widgets
- [x] 5.2e `StatusSlot` — typed `StatusEffect`, tap opens `ModalBottomSheet` to select/overwrite
- [x] 5.2f `StatusTray` — row of 3 `StatusSlot` widgets with 4th-status overwrite prompt

### 5.3 Skills
- [x] 5.3a `SkillNode` widget — displays skill name, tier, prerequisite lock state
- [x] 5.3b `SkillTree` — `ExpansionTile` wrapping a `ListView` of `SkillNode` widgets, filtered by class
- [x] 5.3c Skill activation logic — decrement `skillPegs` on use, enforce prerequisites

---

## Phase 6 — Inventory System (`lib/widgets/`)

- [x] 6.1 Implement `ItemTile`:
  - [x] 6.1a Color-coded border by `ItemColor`
  - [x] 6.1b Rarity badge (corner icon)
  - [x] 6.1c Innate indicator overlay (`isInnate: true`)
  - [x] 6.1d Long-press → "Give to [Adventurer]" context menu (`showMenu`)
- [x] 6.2 Implement `GearSlotsGrid` — `StaggeredGridView` (4 slots, size 1–2), innate replacement prompt when armour overwrites an innate slot
- [x] 6.3 Implement `InventoryPackGrid` — `StaggeredGridView` (10 fixed slots, size 1–4)
- [x] 6.4 Implement item transfer logic — move item to target Adventurer's first available slot(s)
- [x] 6.5 Implement add/remove item flow (item picker or manual entry form)

---

## Phase 7 — Rest & Recovery

- [x] 7.1 Implement "End Quest" trigger from `AppBar`:
  - [x] 7.1a Wipe all status slots
  - [x] 7.1b Reset AP slots
  - [x] 7.1c Recover 2 Magic (capped at max)
  - [x] 7.1d Prompt each Adventurer: +1 Health Max or +1 Skill Max

---

## Phase 8 — XP & Rank-Up Flow

- [x] 8.1 Increment XP peg UI (tap peg to fill)
- [x] 8.2 Trigger rank-up dialog when `currentRank` increases:
  - [x] 8.2a Option A: increase a Max Stat (+1)
  - [x] 8.2b Option B: choose a new Skill from the Class Skill Tree

---

## Phase 9 — Polish & PWA

- [ ] 9.1 Add fallback color-coded text tiles when item/skill image assets are missing
- [ ] 9.2 Configure Flutter Web PWA manifest (name, icons, theme color)
- [ ] 9.3 Test responsive layout at key breakpoints (360px, 600px, 1024px, 1440px)
- [ ] 9.4 Test JSON round-trip (export → import → verify state matches)
- [ ] 9.5 Test offline functionality (PWA cache, Hive persistence across reloads)
- [ ] 9.6 Configure deployment (GitHub Pages / Firebase Hosting / Vercel)
