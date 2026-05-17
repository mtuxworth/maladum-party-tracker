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
    if (stat.current >= stat.max) return;
    stat.current++;
    _emit();
  }

  void decrementStat(StatType type) {
    final stat = _statFor(type);
    if (stat.current <= 0) return;
    stat.current--;
    _emit();
  }

  // Used for rank-up reward: +1 Max Stat.
  void increaseStatMax(StatType type) {
    _statFor(type).max++;
    _emit();
  }

  // ─── Action Points ───────────────────────────────────────────────────────

  void toggleAP(int index) {
    assert(index == 0 || index == 1);
    state.apSlots[index] = !state.apSlots[index];
    _emit();
  }

  void resetAP() {
    state.apSlots = [false, false];
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
    state.xpPegs = pegs.clamp(0, 21);
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

  // Called from SkillNode UI and from the rank-up dialog in Phase 8.
  void unlockSkill(String skillId) {
    if (state.ownedSkillIds.contains(skillId)) return;
    state.ownedSkillIds = [...state.ownedSkillIds, skillId];
    _emit();
  }

  // ─── Inventory ───────────────────────────────────────────────────────────

  void setGearSlot(int index, EquipmentItem? item) {
    assert(index >= 0 && index < maxGearSlots);
    state.gearSlots[index] = item;
    _emit();
  }

  void setPackSlot(int index, EquipmentItem? item) {
    assert(index >= 0 && index < maxPackSlots);
    state.packSlots[index] = item;
    _emit();
  }

  // Adds to first available gear slot. Armour (yellow) may displace an innate
  // item to the pack. Returns false if there is no room.
  bool addGearItem(EquipmentItem item) {
    if (item.color == ItemColor.yellow) {
      final innateIdx = state.gearSlots.indexWhere((s) => s?.isInnate == true);
      if (innateIdx != -1) {
        final innate = state.gearSlots[innateIdx]!;
        if (state.usedPackVolume + innate.slots > maxPackSlots) return false;
        final packIdx = state.packSlots.indexWhere((s) => s == null);
        if (packIdx == -1) return false;
        state.packSlots[packIdx] = innate;
        state.gearSlots[innateIdx] = item;
        _emit();
        return true;
      }
    }
    if (state.usedGearVolume + item.slots > maxGearSlots) return false;
    final idx = state.gearSlots.indexWhere((s) => s == null);
    if (idx == -1) return false;
    state.gearSlots[idx] = item;
    _emit();
    return true;
  }

  // Adds to first available pack slot. Returns false if there is no room.
  bool addPackItem(EquipmentItem item) {
    if (state.usedPackVolume + item.slots > maxPackSlots) return false;
    final idx = state.packSlots.indexWhere((s) => s == null);
    if (idx == -1) return false;
    state.packSlots[idx] = item;
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
    state.gearSlots[slotIndex] = null;
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
    state.packSlots[slotIndex] = null;
    _emit();
    return true;
  }
}
