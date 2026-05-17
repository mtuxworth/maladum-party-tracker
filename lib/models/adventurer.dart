import 'dart:math';

import 'enums.dart';
import 'equipment_item.dart';
import 'maladum_stat.dart';

class Adventurer {
  final String id;
  String name;
  String characterClass;
  MaladumStat health;
  MaladumStat magic;
  MaladumStat skill;
  MaladumStat action;

  int xpPegs; // 0–21
  int skillPegs;
  List<String> ownedSkillIds;

  List<bool> apSlots;            // always 2 elements; true = spent
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
    this.xpPegs = 0,
    this.skillPegs = 0,
    List<String>? ownedSkillIds,
    List<bool>? apSlots,
    List<StatusEffect?>? statusSlots,
    List<EquipmentItem?>? gearSlots,
    List<EquipmentItem?>? packSlots,
  })  : id = id ?? _generateId(),
        ownedSkillIds = ownedSkillIds ?? [],
        apSlots = apSlots ?? [false, false],
        statusSlots = statusSlots ?? List.filled(3, null),
        gearSlots = gearSlots ?? List.filled(4, null),
        packSlots = packSlots ?? List.filled(10, null);

  int get usedGearVolume => gearSlots
      .whereType<EquipmentItem>()
      .fold(0, (sum, item) => sum + item.slots);

  int get usedPackVolume => packSlots
      .whereType<EquipmentItem>()
      .fold(0, (sum, item) => sum + item.slots);

  // Thresholds per PRD: ranks 1–6 at pegs 3, 7, 10, 14, 17, 21.
  int get currentRank {
    if (xpPegs >= 21) return 6;
    if (xpPegs >= 17) return 5;
    if (xpPegs >= 14) return 4;
    if (xpPegs >= 10) return 3;
    if (xpPegs >= 7) return 2;
    if (xpPegs >= 3) return 1;
    return 0;
  }

  factory Adventurer.clone(Adventurer source) => Adventurer(
        id: source.id,
        name: source.name,
        characterClass: source.characterClass,
        health: source.health,
        magic: source.magic,
        skill: source.skill,
        action: source.action,
        xpPegs: source.xpPegs,
        skillPegs: source.skillPegs,
        ownedSkillIds: List.of(source.ownedSkillIds),
        apSlots: List.of(source.apSlots),
        statusSlots: List.of(source.statusSlots),
        gearSlots: List.of(source.gearSlots),
        packSlots: List.of(source.packSlots),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'characterClass': characterClass,
        'health': health.toJson(),
        'magic': magic.toJson(),
        'skill': skill.toJson(),
        'action': action.toJson(),
        'xpPegs': xpPegs,
        'skillPegs': skillPegs,
        'ownedSkillIds': ownedSkillIds,
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
    while (rawGear.length < 4) { rawGear.add(null); }
    while (rawPack.length < 10) { rawPack.add(null); }

    final rawAp = (json['apSlots'] as List?)?.map((e) => e as bool).toList()
        ?? [false, false];

    return Adventurer(
      id: json['id'] as String,
      name: json['name'] as String,
      characterClass: json['characterClass'] as String,
      health: MaladumStat.fromJson(json['health'] as Map<String, dynamic>),
      magic: MaladumStat.fromJson(json['magic'] as Map<String, dynamic>),
      skill: MaladumStat.fromJson(json['skill'] as Map<String, dynamic>),
      action: MaladumStat.fromJson(json['action'] as Map<String, dynamic>),
      xpPegs: json['xpPegs'] as int,
      skillPegs: json['skillPegs'] as int,
      ownedSkillIds: (json['ownedSkillIds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      apSlots: rawAp,
      statusSlots: rawStatus.take(3).toList(),
      gearSlots: rawGear.take(4).toList(),
      packSlots: rawPack.take(10).toList(),
    );
  }
}

String _generateId() {
  final rand = Random();
  return List.generate(8, (_) => rand.nextInt(16).toRadixString(16)).join();
}
