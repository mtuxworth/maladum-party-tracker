import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/enums.dart';
import '../models/equipment_item.dart';
import '../models/maladum_stat.dart';
import 'providers.dart';

class AdventurerNotifier
    extends AutoDisposeFamilyNotifier<Adventurer, String> {
  @override
  Adventurer build(String arg) {
    return ref
        .read(partyProvider)
        .adventurers
        .firstWhere((a) => a.id == arg);
  }

  // ─── Internals ───────────────────────────────────────────────────────────

  MaladumStat _statFor(StatType type) => switch (type) {
        StatType.health => state.health,
        StatType.magic => state.magic,
        StatType.skill => state.skill,
        StatType.action => state.action,
      };

  void _emit() {
    state = Adventurer.clone(state);
    ref.read(partyProvider.notifier).updateAdventurer(state);
  }

  // ─── Stats ───────────────────────────────────────────────────────────────

  void incrementStat(StatType type) {
    final stat = _statFor(type);
    if (stat.current >= stat.potential) return;
    stat.current++;
    _emit();
  }

  void decrementStat(StatType type) {
    final stat = _statFor(type);
    if (stat.current <= 0) return;
    stat.current--;
    _emit();
  }

  // Rank-up reward: +1 starting value (and current, capped at potential).
  // Only valid when starting < potential.
  void increaseStatStarting(StatType type) {
    final stat = _statFor(type);
    stat.starting++;
    stat.current = (stat.current + 1).clamp(0, stat.potential);
    _emit();
  }

  // End-quest reward: +1 potential (raises the ceiling).
  void increaseStatMax(StatType type) {
    _statFor(type).potential++;
    _emit();
  }

  // ─── Action Points ───────────────────────────────────────────────────────

  void toggleAP(int index) {
    if (index < 0) return;
    // Extend apSlots if action.starting grew via level-up after creation.
    if (state.apSlots.length <= index) {
      state.apSlots = [
        ...state.apSlots,
        ...List.filled(index - state.apSlots.length + 1, false),
      ];
    }
    state.apSlots[index] = !state.apSlots[index];
    _emit();
  }

  void resetAP() {
    state.apSlots = List.filled(state.action.starting, false);
    _emit();
  }

  // ─── Status Effects ──────────────────────────────────────────────────────

  void setStatus(int slotIndex, StatusEffect? effect) {
    assert(slotIndex >= 0 && slotIndex < 3);
    state.statusSlots[slotIndex] = effect;
    _emit();
  }

  void clearAllStatuses() {
    state.statusSlots = List.filled(3, null);
    _emit();
  }

  // ─── XP ──────────────────────────────────────────────────────────────────

  void setXpPegs(int pegs) {
    final maxXp = state.rankXpCosts.fold(0, (a, b) => a + b);
    state.xpPegs = pegs.clamp(0, maxXp);
    _emit();
  }

  // ─── Skill Pegs ──────────────────────────────────────────────────────────

  void addSkillPeg() {
    state.skillPegs++;
    _emit();
  }

  // Returns false if no skill pegs remain.
  bool useSkillPeg() {
    if (state.skillPegs <= 0) return false;
    state.skillPegs--;
    _emit();
    return true;
  }

  // Unlocks a skill tier, spending 1 XP.
  // Blocked if no XP is available or the tier exceeds the character's level.
  void unlockSkill(String skillId) {
    if (state.ownedSkillIds.contains(skillId)) return;
    if (state.ownedSkillIds.length >= state.xpPegs) return;
    // Import-free tier lookup: tier is encoded as the trailing digit in the id.
    final tier = int.tryParse(skillId.split('_').last) ?? 1;
    if (tier > state.currentRank + 1) return;
    state.ownedSkillIds = [...state.ownedSkillIds, skillId];
    _emit();
  }

  // Removes the given skill tier, refunding 1 XP. The caller is responsible
  // for only offering this on the highest owned tier in a skill group.
  void removeSkill(String skillId) {
    if (!state.ownedSkillIds.contains(skillId)) return;
    state.ownedSkillIds =
        state.ownedSkillIds.where((id) => id != skillId).toList();
    _emit();
  }

  // ─── Inventory ───────────────────────────────────────────────────────────

  // Clears all gear indices occupied by the item at [index].
  void _clearGearItem(int index) {
    final existing = state.gearSlots[index];
    if (existing == null) return;
    for (int i = 0; i < maxGearSlots; i++) {
      if (state.gearSlots[i]?.id == existing.id) state.gearSlots[i] = null;
    }
  }

  // Clears all pack indices occupied by the item at [index].
  void _clearPackItem(int index) {
    final existing = state.packSlots[index];
    if (existing == null) return;
    for (int i = 0; i < maxPackSlots; i++) {
      if (state.packSlots[i]?.id == existing.id) state.packSlots[i] = null;
    }
  }

  // Returns the start index of [slots] consecutive null gear slots, or -1.
  int _findGearSlot(int slots) {
    for (int i = 0; i <= maxGearSlots - slots; i++) {
      if (List.generate(slots, (d) => state.gearSlots[i + d])
          .every((s) => s == null)) {
        return i;
      }
    }
    return -1;
  }

  // Returns the start index of [slots] consecutive null pack slots, or -1.
  int _findPackSlot(int slots) {
    for (int i = 0; i <= maxPackSlots - slots; i++) {
      if (List.generate(slots, (d) => state.packSlots[i + d])
          .every((s) => s == null)) {
        return i;
      }
    }
    return -1;
  }

  // Moves a gear item to the pack. Returns false if no pack space.
  bool unequipGearItem(int slotIndex) {
    final item = state.gearSlots[slotIndex];
    if (item == null) return false;
    if (state.usedPackVolume + item.slots > maxPackSlots) return false;
    final packIdx = _findPackSlot(item.slots);
    if (packIdx == -1) return false;
    _clearGearItem(slotIndex);
    for (int d = 0; d < item.slots; d++) {
      state.packSlots[packIdx + d] = item;
    }
    _emit();
    return true;
  }

  void setGearSlot(int index, EquipmentItem? item) {
    assert(index >= 0 && index < maxGearSlots);
    if (item == null) {
      _clearGearItem(index);
    } else {
      state.gearSlots[index] = item;
    }
    _emit();
  }

  void setPackSlot(int index, EquipmentItem? item) {
    assert(index >= 0 && index < maxPackSlots);
    if (item == null) {
      _clearPackItem(index);
    } else {
      state.packSlots[index] = item;
    }
    _emit();
  }

  // Rounds item.slots up to the nearest even number for gear storage.
  // Each visual gear slot = 2 actual slot-units.
  int _gearN(EquipmentItem item) => ((item.slots + 1) ~/ 2) * 2;

  // Adds to gear, filling [_gearN] consecutive null slots.
  // Armour (yellow) may displace an innate item to the pack first.
  // Returns false if there is no room.
  bool addGearItem(EquipmentItem item) {
    final gearN = _gearN(item);
    if (item.color == ItemColor.yellow) {
      final innateIdx =
          state.gearSlots.indexWhere((s) => s?.isInnate == true);
      if (innateIdx != -1) {
        final innate = state.gearSlots[innateIdx]!;
        if (state.usedPackVolume + innate.slots > maxPackSlots) return false;
        final packIdx = _findPackSlot(innate.slots);
        if (packIdx == -1) return false;
        _clearGearItem(innateIdx);
        for (int d = 0; d < innate.slots; d++) {
          state.packSlots[packIdx + d] = innate;
        }
        final gearIdx = _findGearSlot(gearN);
        if (gearIdx == -1) return false;
        for (int d = 0; d < gearN; d++) {
          state.gearSlots[gearIdx + d] = item;
        }
        _emit();
        return true;
      }
    }
    if (state.usedGearVolume + gearN > maxGearSlots) return false;
    final idx = _findGearSlot(gearN);
    if (idx == -1) return false;
    for (int d = 0; d < gearN; d++) {
      state.gearSlots[idx + d] = item;
    }
    _emit();
    return true;
  }

  // Adds to pack, filling [item.slots] consecutive null slots.
  // Returns false if there is no room.
  bool addPackItem(EquipmentItem item) {
    if (state.usedPackVolume + item.slots > maxPackSlots) return false;
    final idx = _findPackSlot(item.slots);
    if (idx == -1) return false;
    for (int d = 0; d < item.slots; d++) {
      state.packSlots[idx + d] = item;
    }
    _emit();
    return true;
  }

  // Receives an item into the pack from another adventurer's transfer.
  bool receivePackItem(EquipmentItem item) => addPackItem(item);

  // Moves a gear item to another adventurer's pack. Returns false if no room.
  bool giveGearItem(int slotIndex, String toAdventurerId) {
    final item = state.gearSlots[slotIndex];
    if (item == null) return false;
    final ok = ref
        .read(adventurerProvider(toAdventurerId).notifier)
        .receivePackItem(item);
    if (!ok) return false;
    _clearGearItem(slotIndex);
    _emit();
    return true;
  }

  // Moves an armour item from the pack into [targetGearSlot].
  // If that slot is occupied the displaced item swaps into the pack.
  // Items in other gear slots are never touched.
  // Returns false if there is no pack space for the displaced item.
  // Places a pack armour item into [targetGearSlot] (must be 0 or 2).
  // Items displaced from the target range are returned to the pack.
  // Uses gear-rounded slot count so each visual slot = 2 actual slot-units.
  // Returns false if there is no pack space for any displaced item.
  bool swapPackToGear(EquipmentItem packItem, int targetGearSlot) {
    assert(targetGearSlot >= 0 && targetGearSlot < maxGearSlots);
    if (packItem.color != ItemColor.yellow) return false;
    final gearN = _gearN(packItem);
    if (targetGearSlot + gearN > maxGearSlots) return false;
    final packIdx = state.packSlots.indexWhere((s) => s?.id == packItem.id);
    if (packIdx == -1) return false;

    // Collect unique items currently occupying the target gear range.
    final displaced = <String, EquipmentItem>{};
    for (int i = targetGearSlot; i < targetGearSlot + gearN; i++) {
      final s = state.gearSlots[i];
      if (s != null) displaced[s.id] = s;
    }

    // Simulate pack with the incoming item removed; find space for each
    // displaced item before committing any real mutation.
    final tempPack = List<EquipmentItem?>.of(state.packSlots);
    for (int i = 0; i < maxPackSlots; i++) {
      if (tempPack[i]?.id == packItem.id) tempPack[i] = null;
    }
    for (final d in displaced.values) {
      int found = -1;
      for (int i = 0; i <= maxPackSlots - d.slots; i++) {
        if (List.generate(d.slots, (j) => tempPack[i + j])
            .every((s) => s == null)) {
          found = i;
          break;
        }
      }
      if (found == -1) return false;
      for (int j = 0; j < d.slots; j++) {
        tempPack[found + j] = d;
      }
    }

    // Apply: write simulated pack (removes incoming, adds displaced),
    // clear displaced from gear, write incoming item into gear.
    for (int i = 0; i < maxPackSlots; i++) {
      state.packSlots[i] = tempPack[i];
    }
    for (int i = targetGearSlot; i < targetGearSlot + gearN; i++) {
      state.gearSlots[i] = null;
    }
    for (int d = 0; d < gearN; d++) {
      state.gearSlots[targetGearSlot + d] = packItem;
    }

    _emit();
    return true;
  }

  // Moves a pack item to another adventurer's pack. Returns false if no room.
  bool givePackItem(int slotIndex, String toAdventurerId) {
    final item = state.packSlots[slotIndex];
    if (item == null) return false;
    final ok = ref
        .read(adventurerProvider(toAdventurerId).notifier)
        .receivePackItem(item);
    if (!ok) return false;
    _clearPackItem(slotIndex);
    _emit();
    return true;
  }
}
