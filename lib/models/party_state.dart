import 'adventurer.dart';
import 'equipment_item.dart';
import 'quest_log_entry.dart';

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
  // Full history of completed quests.
  List<QuestLogEntry> questLog;
  // Metadata for the quest currently in progress (cleared on completion).
  String? activeQuestName;
  String? activeQuestCampaignId;
  bool activeIsRescueMission;
  // Adventurer IDs currently stranded from a previous quest.
  List<String> leftBehindIds;

  PartyState({
    required this.name,
    this.guilders = 0,
    this.renown = 0,
    this.notes = '',
    List<Adventurer>? adventurers,
    List<String>? activePartyIds,
    List<EquipmentItem?>? storageSlots,
    List<QuestLogEntry>? questLog,
    this.activeQuestName,
    this.activeQuestCampaignId,
    this.activeIsRescueMission = false,
    List<String>? leftBehindIds,
  })  : adventurers = adventurers ?? [],
        activePartyIds = activePartyIds ?? [],
        storageSlots = storageSlots ?? List.filled(maxStorageSlots, null),
        questLog = questLog ?? [],
        leftBehindIds = leftBehindIds ?? [];

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
    List<QuestLogEntry>? questLog,
    bool? activeIsRescueMission,
    List<String>? leftBehindIds,
  }) =>
      PartyState(
        name: name ?? this.name,
        guilders: guilders ?? this.guilders,
        renown: renown ?? this.renown,
        notes: notes ?? this.notes,
        adventurers: adventurers ?? this.adventurers,
        activePartyIds: activePartyIds ?? this.activePartyIds,
        storageSlots: storageSlots ?? this.storageSlots,
        questLog: questLog ?? this.questLog,
        // Nullable active-quest fields are excluded from copyWith because
        // they need to be explicitly set to null on quest completion —
        // use the PartyState constructor directly for that case.
        activeQuestName: activeQuestName,
        activeQuestCampaignId: activeQuestCampaignId,
        activeIsRescueMission:
            activeIsRescueMission ?? this.activeIsRescueMission,
        leftBehindIds: leftBehindIds ?? this.leftBehindIds,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'guilders': guilders,
        'renown': renown,
        'notes': notes,
        'adventurers': adventurers.map((a) => a.toJson()).toList(),
        'activePartyIds': activePartyIds,
        'storageSlots': storageSlots.map((i) => i?.toJson()).toList(),
        'questLog': questLog.map((e) => e.toJson()).toList(),
        if (activeQuestName != null) 'activeQuestName': activeQuestName,
        if (activeQuestCampaignId != null)
          'activeQuestCampaignId': activeQuestCampaignId,
        'activeIsRescueMission': activeIsRescueMission,
        'leftBehindIds': leftBehindIds,
      };

  factory PartyState.fromJson(Map<String, dynamic> json) {
    EquipmentItem? parseItem(Object? raw) =>
        raw == null
            ? null
            : EquipmentItem.fromJson(raw as Map<String, dynamic>);

    final adventurers = (json['adventurers'] as List)
        .map((a) => Adventurer.fromJson(a as Map<String, dynamic>))
        .toList();

    // Backward compat: old saves had no activePartyIds.
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

    final questLog = (json['questLog'] as List?)
            ?.map((e) =>
                QuestLogEntry.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <QuestLogEntry>[];

    final leftBehindIds = (json['leftBehindIds'] as List?)
            ?.map((e) => e as String)
            .toList() ??
        <String>[];

    return PartyState(
      name: json['name'] as String,
      guilders: json['guilders'] as int? ?? 0,
      renown: json['renown'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      adventurers: adventurers,
      activePartyIds: activeIds,
      storageSlots: rawStorage.take(maxStorageSlots).toList(),
      questLog: questLog,
      activeQuestName: json['activeQuestName'] as String?,
      activeQuestCampaignId: json['activeQuestCampaignId'] as String?,
      activeIsRescueMission:
          json['activeIsRescueMission'] as bool? ?? false,
      leftBehindIds: leftBehindIds,
    );
  }
}
