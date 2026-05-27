import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/adventurer.dart';
import '../models/equipment_item.dart';
import '../models/party_state.dart';

const _boxName = 'parties';
const _activeKey = '__active__';

class PartyNotifier extends Notifier<PartyState> {
  @override
  PartyState build() {
    final box = Hive.box<String>(_boxName);
    final activeName = box.get(_activeKey);
    if (activeName == null) return PartyState(name: 'My Party', guilders: 350);
    return _loadFromBox(box, activeName);
  }

  PartyState _loadFromBox(Box<String> box, String name) {
    final raw = box.get(name);
    if (raw == null) return PartyState(name: name);
    try {
      return PartyState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return PartyState(name: name);
    }
  }

  // ─── Party management ────────────────────────────────────────────────────

  // Adds an adventurer to the roster (no size limit — hire as many as you like).
  void addAdventurer(Adventurer adventurer) {
    state = state.copyWith(
      adventurers: [...state.adventurers, adventurer],
    );
    _save();
  }

  void removeAdventurer(String id) {
    state = state.copyWith(
      adventurers: state.adventurers.where((a) => a.id != id).toList(),
      activePartyIds: state.activePartyIds.where((i) => i != id).toList(),
    );
    _save();
  }

  void renameParty(String name) {
    final oldName = state.name;
    state = state.copyWith(name: name);
    _save();
    if (oldName != name) {
      unawaited(Hive.box<String>(_boxName).delete(oldName));
    }
  }

  void createNewParty(String name) {
    _save();
    state = PartyState(name: name, guilders: 350);
    _save();
  }

  void createPresetParty(String name, List<Adventurer> adventurers) {
    _save();
    state = PartyState(
      name: name,
      guilders: 350,
      adventurers: adventurers,
      // All preset adventurers start active (preset parties are ≤4).
      activePartyIds: adventurers.map((a) => a.id).toList(),
    );
    _save();
  }

  void switchToParty(String name) {
    _save();
    final box = Hive.box<String>(_boxName);
    state = _loadFromBox(box, name);
    _save();
  }

  List<String> listSavedParties() {
    return Hive.box<String>(_boxName)
        .keys
        .cast<String>()
        .where((k) => k != _activeKey)
        .toList()
      ..sort();
  }

  // ─── Active party ────────────────────────────────────────────────────────

  void setActiveParty(List<String> ids) {
    state = state.copyWith(
      activePartyIds: ids.take(maxPartySize).toList(),
    );
    _save();
  }

  // ─── Party stats ─────────────────────────────────────────────────────────

  void setGuilders(int amount) {
    state = state.copyWith(guilders: amount.clamp(0, 999999));
    _save();
  }

  void setRenown(int value) {
    state = state.copyWith(renown: value.clamp(0, maxRenown));
    _save();
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
    _save();
  }

  // ─── Storage ─────────────────────────────────────────────────────────────

  void updateStorageSlot(int index, EquipmentItem? item) {
    final slots = List<EquipmentItem?>.of(state.storageSlots);
    slots[index] = item;
    state = state.copyWith(storageSlots: slots);
    _save();
  }

  // ─── Rest ────────────────────────────────────────────────────────────────

  // Inn rest: costs 2 Guilders per hired adventurer; full recovery for all.
  void restInn() {
    final cost = state.adventurers.length * 2;
    if (state.guilders < cost) return;
    state = state.copyWith(
      guilders: state.guilders - cost,
      adventurers: _applyRest(state.adventurers),
    );
    _save();
  }

  // Wilderness rest: free; same recovery as Inn.
  void restWilderness() {
    state = state.copyWith(adventurers: _applyRest(state.adventurers));
    _save();
  }

  List<Adventurer> _applyRest(List<Adventurer> adventurers) {
    return adventurers.map((a) {
      a.statusSlots = List.filled(3, null);
      a.apSlots = List.filled(a.action.starting, false);
      return Adventurer.clone(a);
    }).toList();
  }

  // ─── Adventurer mutations (called by AdventurerNotifier) ─────────────────

  void updateAdventurer(Adventurer updated) {
    state = state.copyWith(
      adventurers: state.adventurers
          .map((a) => a.id == updated.id ? updated : a)
          .toList(),
    );
    _save();
  }

  // ─── End Quest ───────────────────────────────────────────────────────────

  // Applies post-quest recovery to active party members only.
  void endQuestReset() {
    final activeIds = Set<String>.from(state.activePartyIds);
    final updated = state.adventurers.map((a) {
      if (!activeIds.contains(a.id)) return a;
      a.statusSlots = List.filled(3, null);
      a.apSlots = List.filled(a.action.starting, false);
      a.magic.current = (a.magic.current + 2).clamp(0, a.magic.potential);
      return Adventurer.clone(a);
    }).toList();
    state = state.copyWith(adventurers: updated);
    _save();
  }

  // ─── Import ──────────────────────────────────────────────────────────────

  void importState(PartyState newState) {
    state = newState;
    _save();
  }

  // ─── Persistence ─────────────────────────────────────────────────────────

  void _save() {
    final box = Hive.box<String>(_boxName);
    unawaited(box.put(state.name, jsonEncode(state.toJson())));
    unawaited(box.put(_activeKey, state.name));
  }
}
