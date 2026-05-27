import 'adventurer.dart';
import 'equipment_item.dart';

const int maxPartySize = 4;
const int maxStorageSlots = 5;
const int maxRenown = 12;

class PartyState {
  String name;
  int guilders;
  int renown;
  String notes;
  // Full roster — all hired adventurers (may exceed maxPartySize).
  List<Adventurer> adventurers;
  // IDs of ≤4 adventurers currently selected for the active quest.
  List<String> activePartyIds;
  // Items stored at base camp (fixed 5 slots).
  List<EquipmentItem?> storageSlots;

  PartyState({
    required this.name,
    this.guilders = 0,
    this.renown = 0,
    this.notes = '',
    List<Adventurer>? adventurers,
    List<String>? activePartyIds,
    List<EquipmentItem?>? storageSlots,
  })  : adventurers = adventurers ?? [],
        activePartyIds = activePartyIds ?? [],
        storageSlots = storageSlots ?? List.filled(maxStorageSlots, null);

  // Adventurers currently on the quest.
  List<Adventurer> get activeParty =>
      adventurers.where((a) => activePartyIds.contains(a.id)).toList();

  PartyState copyWith({
    String? name,
    int? guilders,
    int? renown,
    String? notes,
    List<Adventurer>? adventurers,
    List<String>? activePartyIds,
    List<EquipmentItem?>? storageSlots,
  }) =>
      PartyState(
        name: name ?? this.name,
        guilders: guilders ?? this.guilders,
        renown: renown ?? this.renown,
        notes: notes ?? this.notes,
        adventurers: adventurers ?? this.adventurers,
        activePartyIds: activePartyIds ?? this.activePartyIds,
        storageSlots: storageSlots ?? this.storageSlots,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'guilders': guilders,
        'renown': renown,
        'notes': notes,
        'adventurers': adventurers.map((a) => a.toJson()).toList(),
        'activePartyIds': activePartyIds,
        'storageSlots': storageSlots.map((i) => i?.toJson()).toList(),
      };

  factory PartyState.fromJson(Map<String, dynamic> json) {
    EquipmentItem? parseItem(Object? raw) =>
        raw == null
            ? null
            : EquipmentItem.fromJson(raw as Map<String, dynamic>);

    final adventurers = (json['adventurers'] as List)
        .map((a) => Adventurer.fromJson(a as Map<String, dynamic>))
        .toList();

    // Backward compat: old saves had no activePartyIds — treat first ≤4 as active.
    final activeIds = (json['activePartyIds'] as List?)
            ?.map((e) => e as String)
            .toList() ??
        adventurers.map((a) => a.id).take(maxPartySize).toList();

    final rawStorage = (json['storageSlots'] as List?)
            ?.map(parseItem)
            .toList() ??
        <EquipmentItem?>[];
    while (rawStorage.length < maxStorageSlots) {
      rawStorage.add(null);
    }

    return PartyState(
      name: json['name'] as String,
      guilders: json['guilders'] as int? ?? 0,
      renown: json['renown'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      adventurers: adventurers,
      activePartyIds: activeIds,
      storageSlots: rawStorage.take(maxStorageSlots).toList(),
    );
  }
}
