# Maladum Party Tracker — Initial Requirements

This document defines the coding standards, functional expectations, UI specifications, and behavioral rules that all implementation must follow. It is the source of truth for how code should be written and how the app should behave.

---

## 1. Code Style & Quality

### 1.1 General
- Follow the official [Dart style guide](https://dart.dev/effective-dart/style) at all times.
- Use `flutter analyze` with zero warnings before considering any feature complete.
- Format all files with `dart format` (line length: 80).
- Prefer `final` and `const` wherever possible — mutability should be intentional.
- No `dynamic` types. Use explicit types or generics.
- No `print()` in production code. Use a logging abstraction if debugging output is needed.

### 1.2 Naming
- Classes: `UpperCamelCase` (e.g., `AdventurerCard`, `MaladumStat`)
- Files: `snake_case` (e.g., `adventurer_card.dart`, `party_notifier.dart`)
- Variables and methods: `lowerCamelCase`
- Constants: `lowerCamelCase` with `const` prefix (e.g., `const maxGearSlots = 4`)
- Enums: `UpperCamelCase` type, `lowerCamelCase` values (e.g., `ItemColor.blue`)
- Widget files should match their class name exactly (e.g., `StatCounter` lives in `stat_counter.dart`)

### 1.3 Comments
- Comments explain **why**, not what. Well-named identifiers explain what.
- Add a comment when: there is a non-obvious constraint, a subtle invariant, or a workaround for a known limitation.
- No multi-line comment blocks or paragraph docstrings.
- One short line max per comment. Example:
  ```dart
  // Armour can overwrite an innate slot; other item types cannot.
  ```
- Do not comment out dead code — delete it.

### 1.4 Widget Structure
- Each widget lives in its own file.
- Keep `build()` methods short. Extract sub-widgets as private methods (`_buildHeader()`) or separate `StatelessWidget` subclasses when a section exceeds ~30 lines.
- Prefer `StatelessWidget` + Riverpod consumers over `StatefulWidget` unless local ephemeral state is required (e.g., a toggle, animation controller).
- Always pass `super.key` in widget constructors.

### 1.5 File Organization
```
lib/
  models/       # Pure data classes, enums, JSON logic — no Flutter imports
  providers/    # Riverpod notifiers and providers
  widgets/      # Reusable, stateless UI components
  views/        # Full screens composed from widgets
  utils/        # Pure helper functions (no state, no Flutter)
assets/
  images/items/ # Item and skill image assets
```
- No business logic in `views/`. Views compose widgets; logic lives in providers or models.
- No UI code in `models/` or `providers/`.

---

## 2. State Management

- **Riverpod only.** No `setState` outside of truly local UI state (animation, focus).
- Use `NotifierProvider` for mutable state (`PartyNotifier`, `AdventurerNotifier`).
- Use `Provider` for derived/computed values.
- Never expose raw `List` from a notifier — expose an unmodifiable view or copy to prevent external mutation.
- All state mutations go through the notifier. Widgets never mutate model objects directly.

---

## 3. Data & Persistence

- **Hive** is the persistence layer. All `Adventurer` and `PartyState` changes auto-save on every mutation.
- Models must be serializable: every class that touches persistence implements `toJson()` and `fromJson()`.
- JSON import must validate structure before applying — do not crash on malformed files; show a user-facing error.
- `gearSlots` is always `List.filled(4, null)`. `packSlots` is always `List.filled(10, null)`. These sizes are constants, never magic numbers inline.
- Slot volume constraints are enforced at the model/provider layer, not the UI layer.

---

## 4. Functional Requirements

### 4.1 Adventurer Stats
- Every stat (`MaladumStat`) has three values: `starting`, `current`, `max`.
- `current` cannot exceed `max`. `current` cannot go below 0.
- Incrementing/decrementing is always validated before applying.
- Starting values are set at character creation and do not change during a campaign (they are the reference baseline).

### 4.2 Action Points
- Each Adventurer has exactly 2 AP slots per turn.
- Tapping an AP slot toggles its `isSpent` state (visually dims).
- "Reset All AP" sets all slots to `isSpent: false` for the whole party at once.
- AP resets automatically on End Quest.

### 4.3 Status Effects
- Exactly 3 status slots per Adventurer.
- Status effects are typed via `StatusEffect` enum — never raw strings.
- Adding a 4th status triggers a replace dialog: the user picks which of the 3 existing slots to overwrite.
- All status slots are cleared on End Quest.

### 4.4 XP & Rank
- XP track: 21 pegs total across 3 tiers (Novice: 1–7, Veteran: 8–14, Legend: 15–21).
- Rank thresholds are computed on `Adventurer` via `currentRank` (not in the UI).
- Ranks 1–6 unlock at peg counts: 3, 7, 10, 14, 17, 21.
- Reaching a new rank immediately triggers a rank-up dialog (before the user can continue).
- Rank-up options: increase one Max Stat by 1, or unlock a new Skill from the Class Skill Tree.

### 4.5 Skills
- Skills are class-specific. Only skills belonging to the Adventurer's class are shown.
- Tier 2 skills require the Tier 1 skill in the same branch to be owned.
- Activating a skill costs 1 Skill Peg. If `skillPegs == 0`, activation is blocked with a clear message.
- `skillPegs` is separate from `xpPegs`.

### 4.6 Inventory
- Gear zone: 4 slots. Items occupy 1–2 slots.
- Pack: 10 slots. Items occupy 1–4 slots.
- An item cannot be added if insufficient contiguous slots are available.
- Innate items (`isInnate: true`) occupy a gear slot and cannot be removed — only overwritten by armour (Yellow). When overwritten, the innate item is moved to the pack if space permits; otherwise the action is blocked with a message.
- Item transfer between party members: long-press any `ItemTile` → context menu lists other Adventurers → item moves to the target's first available slot(s). Blocked if target has insufficient space.

### 4.7 End Quest (Rest)
Triggered from the `AppBar`. Applies to all party members simultaneously:
1. Clear all status slots.
2. Reset all AP slots to unspent.
3. Restore 2 Magic (capped at each Adventurer's Magic max).
4. Prompt each Adventurer individually: +1 Health Max or +1 Skill Max.

### 4.8 Party Management
- Support 1–4 Adventurers per party.
- Party name is editable from the `AppBar`.
- Multiple saved parties are accessible via the `Drawer`.
- A new party can be created from the `Drawer`; the existing party is saved before switching.

---

## 5. UI & Visual Requirements

### 5.1 Theme
- **Mode:** Dark only — no light mode toggle.
- **Background:** `#1A1A1A` (deep charcoal).
- **Primary accent:** Amber / gold (`Colors.amber[800]`).
- **Secondary accent:** Deep grey (`#2C2C2C`) for card surfaces.
- **Text:** High-contrast off-white (`#F5F5F5`) for primary; muted grey (`#9E9E9E`) for secondary.
- **Danger / destructive actions:** Deep red (`#C62828`).

### 5.2 Item Color Coding
| Type    | Color  | Hex       |
|---------|--------|-----------|
| Weapons | Blue   | `#1565C0` |
| Gear    | Red    | `#B71C1C` |
| Armour  | Yellow | `#F9A825` |
| Gems    | Purple | `#6A1B9A` |
| Traps   | Grey   | `#546E7A` |

These colors are used as `ItemTile` border/background accents, not solid fills.

### 5.3 Responsive Layout
- **Breakpoint:** 600px logical width.
- **≥600px (Desktop/Tablet):** Side-by-side `Row` of `AdventurerCard` widgets. All 1–4 cards visible simultaneously. Cards use `Expanded` to fill the row evenly.
- **<600px (Mobile):** `PageView` with a `TabBar` at the top showing character names. One Adventurer in focus at a time.
- No horizontal scrolling on either layout.

### 5.4 Component Behavior
- **`StatCounter`:** Current value displayed large and centered. Max displayed small at bottom-right. +/− buttons flanking the current value. Buttons visually disabled (not just blocked) when at floor or ceiling.
- **`XPTracker`:** 21 pegs in a `Wrap`. Filled pegs are brighter; empty pegs are dim. Peg 3 and peg 7 of each tier show a small rank-up icon. Tapping a peg fills all pegs up to and including it.
- **`APCircle`:** Full opacity when unspent; 30% opacity when spent. Tap toggles.
- **`StatusSlot`:** Empty slots show a faint placeholder border. Filled slots show the status name and a color indicator. Tap opens a `ModalBottomSheet` with the available status list.
- **`ItemTile`:** Colored left border matching item type. Rarity shown as a small badge in the top-right corner. If `isInnate`, overlay a small lock icon. If no image asset exists, render a color-coded text tile as fallback.

### 5.5 Dialogs & Feedback
- Rank-up dialog is non-dismissible (must make a choice).
- Status overwrite dialog lists the 3 current statuses; user taps one to replace.
- Destructive actions (remove item, clear party) require a confirmation dialog.
- Insufficient-space errors and blocked actions show a `SnackBar` — not a dialog.
- All dialogs follow the dark theme (no white dialog backgrounds).

---

## 6. Non-Functional Requirements

### 6.1 Performance
- The app must remain responsive with 4 Adventurers loaded simultaneously.
- Hive writes are async and must not block the UI thread.
- `const` constructors used wherever widgets are static.
- Avoid rebuilding the entire party view on a single stat change — Riverpod providers should be scoped to the individual `Adventurer` level.

### 6.2 Offline First
- The app must be fully functional with no network connection.
- All data lives in local Hive storage.
- PWA cache must cover all static assets so the app loads offline after first visit.

### 6.3 Accessibility
- All interactive elements have a minimum tap target of 48×48px.
- `Semantics` labels on icon-only buttons (Import, Export, Rest).
- Color is never the sole differentiator — item types also use labels or icons.

### 6.4 Error Handling
- No unhandled exceptions. Wrap risky operations (file I/O, JSON parsing) in try/catch.
- Errors surface as `SnackBar` messages in plain language — no stack traces shown to the user.
- On corrupt/missing Hive data, initialize a fresh empty party rather than crashing.

### 6.5 Testing
- Unit tests for: all `MaladumStat` boundary conditions, `currentRank` thresholds, volume calculations, JSON round-trip.
- Widget tests for: `StatCounter` increment/decrement limits, `StatusTray` overwrite flow, `XPTracker` peg tap behavior.
- No mocking of Hive in tests — use an in-memory Hive box instead.
