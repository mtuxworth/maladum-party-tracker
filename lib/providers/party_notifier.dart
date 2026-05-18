import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/adventurer.dart';
import '../models/party_state.dart';

const _boxName = 'parties';
const _activeKey = '__active__';

class PartyNotifier extends Notifier<PartyState> {
  @override
  PartyState build() {
    // Box is pre-opened in main() so this access is synchronous.
    final box = Hive.box<String>(_boxName);
    final activeName = box.get(_activeKey);
    if (activeName == null) return PartyState(name: 'My Party');
    return _loadFromBox(box, activeName);
  }

  PartyState _loadFromBox(Box<String> box, String name) {
    final raw = box.get(name);
    if (raw == null) return PartyState(name: name);
    try {
      return PartyState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt stored data — start fresh rather than crashing.
      return PartyState(name: name);
    }
  }

  // ─── Party management ────────────────────────────────────────────────────

  void addAdventurer(Adventurer adventurer) {
    if (state.adventurers.length >= maxPartySize) return;
    state = PartyState(
      name: state.name,
      adventurers: [...state.adventurers, adventurer],
    );
    _save();
  }

  void removeAdventurer(String id) {
    state = PartyState(
      name: state.name,
      adventurers: state.adventurers.where((a) => a.id != id).toList(),
    );
    _save();
  }

  void renameParty(String name) {
    final oldName = state.name;
    state = PartyState(name: name, adventurers: state.adventurers);
    _save();
    // Remove the stale key so it doesn't appear in the party list.
    if (oldName != name) {
      unawaited(Hive.box<String>(_boxName).delete(oldName));
    }
  }

  void createNewParty(String name) {
    _save();
    state = PartyState(name: name);
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

  // Called by AdventurerNotifier after every in-game mutation.
  void updateAdventurer(Adventurer updated) {
    state = PartyState(
      name: state.name,
      adventurers: state.adventurers
          .map((a) => a.id == updated.id ? updated : a)
          .toList(),
    );
    _save();
  }

  // ─── End Quest (steps 1–3) ───────────────────────────────────────────────
  // Step 4 (+1 Max Stat choice per adventurer) is driven by the UI via
  // AdventurerNotifier.increaseStatMax after the dialog resolves.
  void endQuestReset() {
    final updated = state.adventurers.map((a) {
      a.statusSlots = List.filled(3, null);
      a.apSlots = [false, false];
      a.magic.current = (a.magic.current + 2).clamp(0, a.magic.potential);
      return Adventurer.clone(a);
    }).toList();
    state = PartyState(name: state.name, adventurers: updated);
    _save();
  }

  // ─── Import ──────────────────────────────────────────────────────────────

  void importState(PartyState newState) {
    state = newState;
    _save();
  }

  // ─── Persistence ─────────────────────────────────────────────────────────

  void _save() {
    // Fire-and-forget: Hive queues writes and in-memory state is immediate.
    final box = Hive.box<String>(_boxName);
    unawaited(box.put(state.name, jsonEncode(state.toJson())));
    unawaited(box.put(_activeKey, state.name));
  }
}
