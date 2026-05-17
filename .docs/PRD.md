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
* **Stat Architecture:** Each stat maintains a **Starting** value (base), **Current** value (live), and **Max** value (cap).
* **AP System:** 2 primary slots per turn with a tap-to-dim toggle and a global "Reset All" function.

### **2.2 Battle View & Status Effects**

* **Capacity:** Exactly 3 Status Slots per character.
* **Status Library:** Color-coded effects (e.g., Poison, Bless, Stun). Status effects should be a typed `StatusEffect` enum or class (with `name` + `color`) — not raw strings.
* **Overwrite Protocol:** If a 4th status is added, the user selects one of the existing 3 to replace.

### **2.3 Experience & Rank Progression**

* **XP Track:** 21 total pegs across 3 tiers (Novice, Veteran, Legend).
* **Rank Thresholds:** Ranks 1–6 unlocked at specific peg counts (3 and 7 of each tier). Threshold logic lives as a computed property or static method on `Adventurer` — not in the UI layer.
* **Rewards:** Automated prompts to increase a Max Stat or choose a new Skill from the Class Skill Tree.

### **2.4 Skills & Class Integration**

* **Class System:** Pre-defined classes (e.g., Maladaar, Berserker) that filter available skills.
* **Skill Prerequisites:** Tiered skill nodes (Tier 1 must be owned to buy Tier 2).
* **Skill Pegs:** A **separate counter** on `Adventurer`, independent of XP Pegs. The UI decrements a Skill Peg when a skill is activated.

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
* **`Drawer`**: To switch between different saved Parties.
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

To handle **Starting/Current/Max** logic visually:

* Show **Current** as a large number in the center.
* Show **Max** in small text at the bottom right.
* Use a "Plus/Minus" system where tapping "Plus" checks against `maxValue` before incrementing.

### **The `XPTracker` Widget**

* Use a `Wrap` widget with 21 `XPPeg` (CustomPaint or Container) widgets.
* Every 3rd and 7th peg in a tier should have a small "Rank Up" icon next to it to visually prompt the user that a reward is coming.
* Rank threshold logic is a computed property on `Adventurer`, not in this widget.

---

## 7. Core Data Models (`models.dart`)

This file handles the "brain" of your characters. It includes the `Stat` class for the Start/Current/Max logic and the `Adventurer` class that manages the 4 Gear slots.

```dart
import 'dart:convert';

enum ItemColor { blue, red, yellow, purple, grey }
enum Rarity { common, uncommon, rare, exclusive }
enum StatusEffect { poison, bless, stun /* ... extend as needed */ }

class MaladumStat {
  final int starting;
  int current;
  int max;

  MaladumStat({required this.starting, required this.max}) : current = starting;

  Map<String, dynamic> toJson() => {'starting': starting, 'current': current, 'max': max};
  factory MaladumStat.fromJson(Map<String, dynamic> json) =>
      MaladumStat(starting: json['starting'], max: json['max'])..current = json['current'];
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
  String characterClass;
  MaladumStat health;
  MaladumStat magic;
  MaladumStat skill;
  MaladumStat action;

  int xpPegs = 0;       // 0 to 21
  int skillPegs = 0;    // separate from XP; spent when activating skills

  List<StatusEffect?> statusSlots = [null, null, null]; // 3 typed status slots

  // Fixed-size lists: gearSlots = 4, packSlots = 10
  List<EquipmentItem?> gearSlots = List.filled(4, null);
  List<EquipmentItem?> packSlots = List.filled(10, null);

  Adventurer({
    required this.name,
    required this.characterClass,
    required this.health,
    required this.magic,
    required this.skill,
    required this.action,
  });

  int get usedGearVolume => gearSlots.whereType<EquipmentItem>().fold(0, (sum, i) => sum + i.slots);
  int get usedPackVolume => packSlots.whereType<EquipmentItem>().fold(0, (sum, i) => sum + i.slots);

  // Rank computed from XP pegs (thresholds: 3 and 7 per tier)
  int get currentRank {
    if (xpPegs >= 21) return 6;
    if (xpPegs >= 17) return 5;
    if (xpPegs >= 14) return 4;
    if (xpPegs >= 10) return 3;
    if (xpPegs >= 7)  return 2;
    if (xpPegs >= 3)  return 1;
    return 0;
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
