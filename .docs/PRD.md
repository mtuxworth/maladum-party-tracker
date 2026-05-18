Here is the finalized Product Requirements Document (PRD) summary for the **Maladum Party Tracker**. This serves as your project's technical and functional blueprint.

---

## 1. Product Overview

* **Name:** Maladum Party Tracker
* **Platform:** Flutter Web (PWA-enabled)
* **Architecture:** Offline-first with local persistence and JSON-based portability.
* **Primary Goal:** A digital companion to manage Adventurer states, inventory, and campaign progression for the Maladum board game.

---

## 2. Core Functional Modules

### **2.1 Adventurer Dashboard (The "Triple-Stat" Logic)**

* **Stats Tracked:** Health, Magic (Vigor), Skill, and Action Points (AP).
* **Stat Architecture:** Each stat maintains three values:
  * **Starting** — the base value for the character template; shown on the character sheet for reference.
  * **Potential** — the maximum the stat can ever reach (formerly "Max"); increased by rank-up rewards.
  * **Current** — the live in-game value, starts equal to Starting, adjusted up and down during play.
* **Character Sheet Layout:** A static "Stats" section displays Starting and Potential side-by-side. A separate "Battle" section shows the live Current value with increment/decrement controls.
* **AP System:** 2 primary slots per turn with a tap-to-dim toggle and a global "Reset All" function.

### **2.2 Battle View & Status Effects**

* **Capacity:** Exactly 3 Status Slots per character.
* **Status Library:** Color-coded effects (e.g., Poison, Bless, Stun). Status effects should be a typed `StatusEffect` enum or class (with `name` + `color`) — not raw strings.
* **Overwrite Protocol:** If a 4th status is added, the user selects one of the existing 3 to replace.

### **2.3 Experience & Rank Progression**

* **Rank Cap:** Each adventurer has up to 5 rank levels (Rank 1–5). Rank 0 is the starting state.
* **Per-Rank XP Cost:** Each rank has its own XP threshold stored on the character template (e.g., Rank 1 costs 3 XP, Rank 2 costs 4 XP). This varies by character — it is not a fixed global table.
* **XP Track UI:** Displayed as one row per rank level (up to 5 rows). Each row shows the XP pegs required for that rank, filled as the player earns XP. The active rank row is highlighted; completed rows are fully filled.
* **Rank Thresholds:** Computed from the per-rank cost list on the character template, not a hardcoded peg count. Threshold logic lives as a computed property on `Adventurer` — not in the UI layer.
* **Rewards:** Automated prompts to increase a Potential Stat or choose a new Skill from the Class Skill Tree.

### **2.4 Skills & Class Integration**

* **Class System:** Pre-defined classes (e.g., Maladaar, Berserker) that filter available skills. Class is assigned when adding an adventurer to the party — not after creation.
* **Starting Skills:** At character creation, the adventurer may immediately unlock a number of Tier 1 skills equal to their starting Skill stat value. A skill selection screen is shown as part of the "Add Adventurer" flow after class is chosen.
* **Skill Prerequisites:** Tiered skill nodes (Tier 1 must be owned to unlock Tier 2 and above).
* **Skill Pegs:** A **separate counter** on `Adventurer`, independent of XP Pegs. The UI decrements a Skill Peg when a skill is activated.

---

## 2.5 Premade Character Templates

* **Template Library:** The game ships with a fixed set of named adventurer templates (e.g., "Aldric the Bold", "Senna Duskwalker"). Each template defines the character's name, portrait reference, and base stat block (Starting and Potential for Health, Magic, Skill, Action) along with the per-rank XP cost list.
* **Party Creation Flow:** When adding an adventurer to a party the user:
  1. Picks a premade template from a scrollable gallery.
  2. Assigns a class to that adventurer (class determines available skills).
  3. Selects starting Tier 1 skills up to the template's starting Skill value.
* **Template Data:** Stored in `lib/models/adventurer_templates.dart` as a `const` list — not user-editable, not persisted in Hive.
* **Uniqueness:** The same template can be used by multiple party members (house-rule support); no enforcement required.

---

## 2.6 Reference Databases (View-Only)

The app exposes three read-only reference screens accessible from the main drawer:

* **Items Database** — full list of all `EquipmentItem` definitions (name, color/type, rarity, slot size). Filterable by color and rarity. Tapping an entry shows full detail.
* **Skills Database** — full list of all skills grouped by class and tier. Filterable by class. Shows name, description, tier, and prerequisite.
* **Classes Database** — list of all playable classes with a description, stat affinities, and a preview of their Tier 1 skill list.

These screens are purely informational — no mutations occur from them. Data is sourced from the same `const` data files used by the rest of the app (`kAllSkills`, `kAllClasses`, `kAllItems`).

---

## 3. Inventory & Equipment System

### **3.1 Equipment Attributes**

* **Color-Coding:**
* **Blue:** Weapons | **Red:** Gear | **Yellow:** Armour | **Purple:** Gems | **Grey:** Traps


* **Rarity:** Common, Uncommon, Rare, Exclusive.
* **Size (Volume):** Items occupy between 1 and 4 slots.
* **Innate Flag:** `EquipmentItem` has an `isInnate` boolean. Innate items are soft-locked in a gear slot — they can be replaced by armour but not freely removed.

### **3.2 Slot Management**

* **Gear Zone (4 Slots):** The "Active" area. Armour generally takes 2 slots, limiting characters to 2 pieces of Armour. One slot may be occupied by an innate skill item (`isInnate: true`), which can be overwritten by armour.
* **Inventory Pack (10 Slots):** Modeled as `List.filled(10, null)` — a fixed-size list matching `gearSlots`. Items occupy 1–4 contiguous slots; total volume is capped at 10.

---

## 4. Automation & Persistence

### **4.1 Rest & Recovery Engine**

* **End Quest Trigger:** Wipes statuses, resets AP, recovers 2 Magic, and allows a choice between +1 Health or +1 Skill.
* **Trade Hub:** Item trading is handled via a **long-press context menu** on any inventory item. Long-pressing shows a "Give to [Adventurer]" picker listing the other party members — no dedicated screen or overlay is required.

### **4.2 Data Portability**

* **Local Save:** Continuous auto-save to browser storage (Hive/SharedPreferences).
* **JSON Import/Export:** Manual file handling for campaign backups, device transfers, or sharing party states. `EquipmentItem` must implement both `toJson()` and `fromJson()`.

---

## 5. UI/UX Design Standards

* **Theme:** "Dungeon Dark" mode (High-contrast gold, deep greys, and ambers).
* **Responsive Layout:**
  * **Breakpoint:** 600px width.
  * **Desktop/Tablet (≥600px):** Side-by-side `Row` of `AdventurerCard` widgets for 1–4 players.
  * **Mobile (<600px):** `PageView` (swipeable) or `TabBar` for individual character focus.

* **Visual Fidelity:** Image support for equipment cards and skill icons, falling back to color-coded text tiles if assets are missing.

---

## 6. Technical Stack

* **Frontend:** Flutter (Web/PWA).
* **State Management:** Riverpod (`NotifierProvider` / `StateNotifierProvider`) — chosen for clean handling of the `Party → Adventurer → Stats` tree without prop-drilling.
* **Persistence:** `hive_flutter` for local NoSQL storage.
* **Deployment:** Static hosting (GitHub Pages, Firebase Hosting, or Vercel).

To build this in Flutter, you'll want a layout that is **responsive** (handles both tablets and phones) and **clean**. Since we are tracking multiple adventurers, the tree needs to handle a "Party" level and an "Individual" level.

Here is the recommended **Widget Tree** for the Maladum Party Tracker.

---

## 1. Top-Level Structure

This handles the "App Shell," JSON persistence, and navigation.

* **`MaladumApp` (MaterialApp)**
* **`ProviderScope` (Riverpod)**: Holds the `PartyState` (List of Adventurers).
* **`MainScaffold`**:
* **`AppBar`**: Includes the "Party Name," "JSON Export/Import" buttons, and the "End Quest (Rest)" button.
* **`Drawer`**: Switch between saved parties; links to the three reference database screens (Items, Skills, Classes).
* **`Body`**:
* **`ResponsiveLayout`** (breakpoint: 600px): Switches between `DesktopView` (side-by-side cards) and `MobileView` (PageView/TabBar navigation).




---

## 2. Desktop/Tablet View (≥600px, Side-by-Side)

* **`Row`**:
* **`Expanded`** (repeat for 1-4 adventurers):
* **`AdventurerCard`**: (See Section 4 for details).




---

## 3. Mobile View (<600px, Swipeable)

* **`PageView`** (or `DefaultTabController`):
* **`Column`**:
* **`TabBar`**: Showing character names or small portraits.
* **`Expanded`**:
* **`PageView` / `TabBarView`**:
* **`AdventurerDashboard`**: (Detailed view of the active character).




---

## 4. The `AdventurerDashboard` (The Core Widget)

This is the most complex widget. I recommend breaking it into these sub-widgets:

### **Header Section**

* **`CharacterHeader`** (Row):
* `CharacterPortrait` (CircleAvatar)
* `Column`: [Name, ClassName, RankBadge]
* `XPProgressBar`: A custom-painted row of 21 dots (7 Green, 7 Yellow, 7 Red).



### **Battle Controls (The "Live" Area)**

* **`StatGrid`** (Row of 4 columns):
* `StatCounter`: (Health, Magic, Skill, Action).
* *Inside:* [Label, MaxValue, Incrementor/Decrementor Buttons, CurrentValueDisplay].




* **`ActionPointTracker`**:
* Row of 2 `APCircle` widgets. Tapping toggles `isSpent` state.


* **`StatusTray`**:
* Row of 3 `StatusSlot` widgets (typed `StatusEffect`, not raw strings).
* *Logic:* On tap, opens a `ModalBottomSheet` to select/overwrite status.



### **Inventory Section (The Grid)**

* **`EquipmentZone`**:
* **`GearSlotsGrid`**: A `Wrap` or `GridView` (2x2) providing 4 slots. Innate items render with a soft-lock indicator; armour may overwrite them.
* `ItemTile`: Color-coded border (Blue/Red/etc.), handles size (1 or 2 slots).
* Long-press on any `ItemTile` → "Give to [Adventurer]" context menu.


* **`InventoryPackGrid`**: A `GridView` (2x5) for the 10 fixed slots (`List.filled(10, null)`).
* `ItemTile`: Handles size (1, 2, or 4 slots).
* Long-press on any `ItemTile` → "Give to [Adventurer]" context menu.




---

## 5. Visual Widget Hierarchy Sketch

```text
MaladumApp
└── MainScaffold
    ├── GlobalAppBar (Export/Import/EndQuest)
    └── Body (Consumer<PartyState>)
        └── ResponsiveLayout (breakpoint: 600px)
            ├── DesktopView (Row of AdventurerCards, 1–4 players)
            └── MobileView (PageView / TabBarView)
                └── SingleAdventurerView
                    ├── Column (Main Layout)
                    │   ├── Row (Rank/XP Progress Bar)
                    │   ├── StatRow (HP, MP, SP, AP - Current/Max)
                    │   ├── Row (2 Action Points - Tap to dim)
                    │   ├── Row (3 Status Slots - Tap to select/overwrite)
                    │   └── ExpansionTile (Skills List)
                    │       └── ListView (Skill Tree nodes)
                    └── InventoryDashboard (The 4 Gear + 10 Pack grid)
                        ├── Grid (4 Gear Slots - Size 1-2, innate soft-lock)
                        └── Grid (10 Pack Slots - Size 1-4, fixed list)

```

---

## 6. Important Widget Details

### **The `ItemTile` Widget**

```dart
class ItemTile extends StatelessWidget {
  final MaladumItem item;
  // Use the color enum to set the decoration background
  // Blue = Weapons, Red = Gear, etc.
  // Display Rarity (Common/Rare) as a small badge or icon in corner.
  // If item.isInnate, show a soft-lock icon overlay.
  // Long-press triggers "Give to [Adventurer]" context menu.
}
```

### **The `StatCounter` Widget**

Two display modes for the same widget:

* **Reference mode** (character sheet): Shows **Starting** and **Potential** side-by-side, read-only.
* **Battle mode** (live play): Shows **Current** as a large number with Plus/Minus buttons. Checks against `potential` before incrementing. Shows `potential` in small text for context.

### **The `XPTracker` Widget**

* Rendered as a `Column` of up to 5 rank rows. Each row represents one rank level and contains a number of peg dots equal to the XP cost for that rank.
* Pegs in completed ranks are fully filled. Pegs in the current rank are filled up to the adventurer's XP progress within that rank. Future rank rows are empty.
* The active rank row is visually highlighted (e.g., brighter border or label).
* Rank threshold logic is a computed property on `Adventurer` using the per-rank cost list — not hardcoded in this widget.

---

## 7. Core Data Models (`models.dart`)

This file handles the "brain" of your characters. It includes the `Stat` class for the Start/Current/Max logic and the `Adventurer` class that manages the 4 Gear slots.

```dart
import 'dart:convert';

enum ItemColor { blue, red, yellow, purple, grey }
enum Rarity { common, uncommon, rare, exclusive }
enum StatusEffect { poison, bless, stun /* ... extend as needed */ }

class MaladumStat {
  final int starting;   // base value from template; reference-only
  int current;          // live in-game value; starts = starting
  int potential;        // cap (formerly "max"); increased by rank-up rewards

  MaladumStat({required this.starting, required this.potential}) : current = starting;

  Map<String, dynamic> toJson() => {'starting': starting, 'current': current, 'potential': potential};
  factory MaladumStat.fromJson(Map<String, dynamic> json) =>
      MaladumStat(starting: json['starting'], potential: json['potential'])..current = json['current'];
}

class EquipmentItem {
  final String id;
  final String name;
  final ItemColor color;
  final Rarity rarity;
  final int slots;     // 1 to 4
  final bool isInnate; // soft-locked; replaceable by armour

  EquipmentItem({
    required this.id,
    required this.name,
    required this.color,
    required this.rarity,
    required this.slots,
    this.isInnate = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'color': color.name,
    'rarity': rarity.name, 'slots': slots, 'isInnate': isInnate,
  };

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
    id: json['id'],
    name: json['name'],
    color: ItemColor.values.byName(json['color']),
    rarity: Rarity.values.byName(json['rarity']),
    slots: json['slots'],
    isInnate: json['isInnate'] ?? false,
  );
}

class Adventurer {
  String name;
  String templateId;       // references AdventurerTemplate.id
  String characterClass;
  MaladumStat health;
  MaladumStat magic;
  MaladumStat skill;
  MaladumStat action;

  int xpPegs = 0;          // total XP earned (sum across all ranks)
  int skillPegs = 0;       // separate from XP; spent when activating skills
  List<int> rankXpCosts;   // per-rank XP thresholds from template, e.g. [3, 4, 4, 5, 5]

  List<StatusEffect?> statusSlots = [null, null, null]; // 3 typed status slots

  // Fixed-size lists: gearSlots = 4, packSlots = 10
  List<EquipmentItem?> gearSlots = List.filled(4, null);
  List<EquipmentItem?> packSlots = List.filled(10, null);

  Adventurer({
    required this.name,
    required this.templateId,
    required this.characterClass,
    required this.health,
    required this.magic,
    required this.skill,
    required this.action,
    required this.rankXpCosts,
  });

  int get usedGearVolume => gearSlots.whereType<EquipmentItem>().fold(0, (sum, i) => sum + i.slots);
  int get usedPackVolume => packSlots.whereType<EquipmentItem>().fold(0, (sum, i) => sum + i.slots);

  // Rank computed from cumulative XP cost list (up to 5 ranks)
  int get currentRank {
    int cumulative = 0;
    for (int i = 0; i < rankXpCosts.length; i++) {
      cumulative += rankXpCosts[i];
      if (xpPegs < cumulative) return i;
    }
    return rankXpCosts.length; // max rank achieved
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'name': name,
    'characterClass': characterClass,
    'health': health.toJson(),
    'magic': magic.toJson(),
    'skill': skill.toJson(),
    'action': action.toJson(),
    'xpPegs': xpPegs,
    'skillPegs': skillPegs,
    'statusSlots': statusSlots.map((s) => s?.name).toList(),
    'gearSlots': gearSlots.map((i) => i?.toJson()).toList(),
    'packSlots': packSlots.map((i) => i?.toJson()).toList(),
  };
}
```

---

## 8. Main Application Shell (`main.dart`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

void main() => runApp(const ProviderScope(child: MaladumTrackerApp()));

class MaladumTrackerApp extends StatelessWidget {
  const MaladumTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.amber[800],
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const PartyDashboard(),
    );
  }
}

class PartyDashboard extends ConsumerWidget {
  const PartyDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ResponsiveLayout switches at 600px
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 600;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Maladum Party Tracker'),
            actions: [
              IconButton(icon: const Icon(Icons.upload_file), onPressed: () {}),   // Import
              IconButton(icon: const Icon(Icons.download), onPressed: () {}),      // Export
              IconButton(icon: const Icon(Icons.nightlight_round), onPressed: () {}), // Rest
            ],
          ),
          body: isDesktop ? const DesktopPartyView() : const MobilePartyView(),
        );
      },
    );
  }
}
```

---

## 9. Folder Structure

```
lib/
  models/       # Data classes, JSON logic (MaladumStat, EquipmentItem, Adventurer)
  providers/    # Riverpod providers, Hive persistence
  widgets/      # StatCounter, ItemTile, XPPegRow, StatusSlot, APCircle
  views/        # DashboardView, InventoryView, RestView
assets/
  images/items/ # Color-coded item icons
```

---

## 10. Implementation Notes

* **Inventory Grid:** Use `StaggeredGridView` (`flutter_staggered_grid_view`) for variable-size item tiles in both gear and pack grids. Pin the package version early.
* **Trade between characters:** Long-press any `ItemTile` → show a `showMenu` / `PopupMenuButton` listing other party members → move the item to the target's first available slot.
* **Innate skill replacement:** When armour is dropped onto a gear slot occupied by an innate item, prompt the user to confirm the swap. The innate item is not destroyed — it returns to the pack if space permits.
