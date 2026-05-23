import 'dart:math';

import 'enums.dart';
import 'equipment_item.dart';
import 'maladum_stat.dart';

// Default per-rank XP costs used when no template data is available.
const List<int> kDefaultRankXpCosts = [3, 4, 4, 5, 5];

class Adventurer {
  final String id;
  String name;
  // ID of the AdventurerTemplate this character was created from.
  String? templateId;
  // ID of the CharacterClass assigned to this character.
  String characterClass;
  MaladumStat health;
  MaladumStat magic;
  MaladumStat skill;
  MaladumStat action;

  int xpPegs;
  int skillPegs;
  // XP required to complete each rank row, derived from the template.
  List<int> rankXpCosts;
  List<String> ownedSkillIds;
  List<String> ownedSpellIds;

  List<bool> apSlots;              // always 2 elements; true = spent
  List<StatusEffect?> statusSlots; // always 3 elements
  List<EquipmentItem?> gearSlots;  // always 4 elements
  List<EquipmentItem?> packSlots;  // always 10 elements

  Adventurer({
    String? id,
    required this.name,
    required this.characterClass,
    required this.health,
    required this.magic,
    required this.skill,
    required this.action,
    this.templateId,
    this.xpPegs = 0,
    this.skillPegs = 0,
    List<int>? rankXpCosts,
    List<String>? ownedSkillIds,
    List<String>? ownedSpellIds,
    List<bool>? apSlots,
    List<StatusEffect?>? statusSlots,
    List<EquipmentItem?>? gearSlots,
    List<EquipmentItem?>? packSlots,
  })  : id = id ?? _generateId(),
        rankXpCosts = rankXpCosts ?? kDefaultRankXpCosts,
        ownedSkillIds = ownedSkillIds ?? [],
        ownedSpellIds = ownedSpellIds ?? [],
        apSlots = apSlots ?? [false, false],
        statusSlots = statusSlots ?? List.filled(3, null),
        gearSlots = gearSlots ?? List.filled(maxGearSlots, null),
        packSlots = packSlots ?? List.filled(10, null);

  int get usedGearVolume {
    final seen = <String>{};
    int total = 0;
    for (final item in gearSlots.whereType<EquipmentItem>()) {
      // Each visual gear slot = 2 actual slot-units; round up to nearest even.
      if (seen.add(item.id)) total += ((item.slots + 1) ~/ 2) * 2;
    }
    return total;
  }

  int get usedPackVolume {
    final seen = <String>{};
    int total = 0;
    for (final item in packSlots.whereType<EquipmentItem>()) {
      if (seen.add(item.id)) total += item.slots;
    }
    return total;
  }

  // Rank is computed from cumulative rankXpCosts thresholds (up to 5 ranks).
  int get currentRank {
    final costs =
        rankXpCosts.isEmpty ? kDefaultRankXpCosts : rankXpCosts;
    int cumulative = 0;
    for (int i = 0; i < costs.length; i++) {
      cumulative += costs[i];
      if (xpPegs < cumulative) return i;
    }
    return costs.length;
  }

  factory Adventurer.clone(Adventurer source) => Adventurer(
        id: source.id,
        name: source.name,
        templateId: source.templateId,
        characterClass: source.characterClass,
        health: source.health,
        magic: source.magic,
        skill: source.skill,
        action: source.action,
        xpPegs: source.xpPegs,
        skillPegs: source.skillPegs,
        rankXpCosts: List.of(source.rankXpCosts),
        ownedSkillIds: List.of(source.ownedSkillIds),
        ownedSpellIds: List.of(source.ownedSpellIds),
        apSlots: List.of(source.apSlots),
        statusSlots: List.of(source.statusSlots),
        gearSlots: List.of(source.gearSlots),
        packSlots: List.of(source.packSlots),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (templateId != null) 'templateId': templateId,
        'characterClass': characterClass,
        'health': health.toJson(),
        'magic': magic.toJson(),
        'skill': skill.toJson(),
        'action': action.toJson(),
        'xpPegs': xpPegs,
        'skillPegs': skillPegs,
        'rankXpCosts': rankXpCosts,
        'ownedSkillIds': ownedSkillIds,
        'ownedSpellIds': ownedSpellIds,
        'apSlots': apSlots,
        'statusSlots': statusSlots.map((s) => s?.name).toList(),
        'gearSlots': gearSlots.map((i) => i?.toJson()).toList(),
        'packSlots': packSlots.map((i) => i?.toJson()).toList(),
      };

  factory Adventurer.fromJson(Map<String, dynamic> json) {
    StatusEffect? parseStatus(Object? raw) =>
        raw == null ? null : StatusEffect.values.byName(raw as String);

    EquipmentItem? parseItem(Object? raw) =>
        raw == null ? null : EquipmentItem.fromJson(raw as Map<String, dynamic>);

    final rawStatus = (json['statusSlots'] as List).map(parseStatus).toList();
    final rawGear = (json['gearSlots'] as List).map(parseItem).toList();
    final rawPack = (json['packSlots'] as List).map(parseItem).toList();

    // Pad to fixed sizes to guard against truncated JSON.
    while (rawStatus.length < 3) { rawStatus.add(null); }
    while (rawGear.length < maxGearSlots) { rawGear.add(null); }
    while (rawPack.length < 10) { rawPack.add(null); }

    final rawAp = (json['apSlots'] as List?)?.map((e) => e as bool).toList()
        ?? [false, false];

    final rawCosts = (json['rankXpCosts'] as List?)
            ?.map((e) => e as int)
            .toList() ??
        kDefaultRankXpCosts;

    return Adventurer(
      id: json['id'] as String,
      name: json['name'] as String,
      templateId: json['templateId'] as String?,
      characterClass: json['characterClass'] as String,
      health: MaladumStat.fromJson(json['health'] as Map<String, dynamic>),
      magic: MaladumStat.fromJson(json['magic'] as Map<String, dynamic>),
      skill: MaladumStat.fromJson(json['skill'] as Map<String, dynamic>),
      action: MaladumStat.fromJson(json['action'] as Map<String, dynamic>),
      xpPegs: json['xpPegs'] as int,
      skillPegs: json['skillPegs'] as int,
      rankXpCosts: rawCosts,
      ownedSkillIds: (json['ownedSkillIds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      ownedSpellIds: (json['ownedSpellIds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      apSlots: rawAp,
      statusSlots: rawStatus.take(3).toList(),
      gearSlots: rawGear.take(maxGearSlots).toList(),
      packSlots: rawPack.take(10).toList(),
    );
  }
}

String _generateId() {
  final rand = Random();
  return List.generate(8, (_) => rand.nextInt(16).toRadixString(16)).join();
}
