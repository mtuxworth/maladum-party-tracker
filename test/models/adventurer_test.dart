import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_maladum/models/adventurer.dart';
import 'package:flutter_maladum/models/enums.dart';
import 'package:flutter_maladum/models/equipment_item.dart';
import 'package:flutter_maladum/models/maladum_stat.dart';

Adventurer _makeAdventurer({int xpPegs = 0}) => Adventurer(
      name: 'Test',
      characterClass: 'Berserker',
      health: MaladumStat(starting: 5, max: 5),
      magic: MaladumStat(starting: 3, max: 3),
      skill: MaladumStat(starting: 4, max: 4),
      action: MaladumStat(starting: 2, max: 2),
      xpPegs: xpPegs,
    );

void main() {
  // Default rankXpCosts = [3, 4, 4, 5, 5]; cumulative: 3, 7, 11, 16, 21.
  group('Adventurer.currentRank', () {
    test('rank 0 below first threshold', () {
      expect(_makeAdventurer(xpPegs: 0).currentRank, equals(0));
      expect(_makeAdventurer(xpPegs: 2).currentRank, equals(0));
    });

    test('rank 1 at peg 3', () {
      expect(_makeAdventurer(xpPegs: 3).currentRank, equals(1));
      expect(_makeAdventurer(xpPegs: 6).currentRank, equals(1));
    });

    test('rank 2 at peg 7', () {
      expect(_makeAdventurer(xpPegs: 7).currentRank, equals(2));
      expect(_makeAdventurer(xpPegs: 10).currentRank, equals(2));
    });

    test('rank 3 at peg 11', () {
      expect(_makeAdventurer(xpPegs: 11).currentRank, equals(3));
      expect(_makeAdventurer(xpPegs: 15).currentRank, equals(3));
    });

    test('rank 4 at peg 16', () {
      expect(_makeAdventurer(xpPegs: 16).currentRank, equals(4));
      expect(_makeAdventurer(xpPegs: 20).currentRank, equals(4));
    });

    test('rank 5 (max) at peg 21', () {
      expect(_makeAdventurer(xpPegs: 21).currentRank, equals(5));
      expect(_makeAdventurer(xpPegs: 25).currentRank, equals(5));
    });
  });

  group('Adventurer slot sizes', () {
    test('gearSlots initialises to 4 nulls', () {
      final a = _makeAdventurer();
      expect(a.gearSlots.length, equals(4));
      expect(a.gearSlots.every((s) => s == null), isTrue);
    });

    test('packSlots initialises to 10 nulls', () {
      final a = _makeAdventurer();
      expect(a.packSlots.length, equals(10));
      expect(a.packSlots.every((s) => s == null), isTrue);
    });

    test('statusSlots initialises to 3 nulls', () {
      final a = _makeAdventurer();
      expect(a.statusSlots.length, equals(3));
      expect(a.statusSlots.every((s) => s == null), isTrue);
    });
  });

  group('Adventurer volume calculations', () {
    test('usedGearVolume is 0 when empty', () {
      expect(_makeAdventurer().usedGearVolume, equals(0));
    });

    test('usedPackVolume is 0 when empty', () {
      expect(_makeAdventurer().usedPackVolume, equals(0));
    });

    test('usedGearVolume sums item slots correctly', () {
      final a = _makeAdventurer();
      a.gearSlots[0] = EquipmentItem(
        id: '1', name: 'Sword', color: ItemColor.blue,
        rarity: Rarity.common, slots: 1,
      );
      a.gearSlots[1] = EquipmentItem(
        id: '2', name: 'Shield', color: ItemColor.yellow,
        rarity: Rarity.uncommon, slots: 2,
      );
      expect(a.usedGearVolume, equals(3));
    });

    test('usedPackVolume sums item slots correctly', () {
      final a = _makeAdventurer();
      a.packSlots[0] = EquipmentItem(
        id: '3', name: 'Gem', color: ItemColor.purple,
        rarity: Rarity.rare, slots: 4,
      );
      a.packSlots[4] = EquipmentItem(
        id: '4', name: 'Trap', color: ItemColor.grey,
        rarity: Rarity.common, slots: 1,
      );
      expect(a.usedPackVolume, equals(5));
    });
  });

  group('Adventurer JSON round-trip', () {
    test('restores all scalar fields', () {
      final original = _makeAdventurer(xpPegs: 7);
      original.skillPegs = 2;
      original.health.current = 3;

      final restored = Adventurer.fromJson(original.toJson());

      expect(restored.name, equals(original.name));
      expect(restored.characterClass, equals(original.characterClass));
      expect(restored.xpPegs, equals(7));
      expect(restored.skillPegs, equals(2));
      expect(restored.health.current, equals(3));
    });

    test('restores status slots', () {
      final original = _makeAdventurer();
      original.statusSlots[0] = StatusEffect.poison;
      original.statusSlots[2] = StatusEffect.bless;

      final restored = Adventurer.fromJson(original.toJson());

      expect(restored.statusSlots[0], equals(StatusEffect.poison));
      expect(restored.statusSlots[1], isNull);
      expect(restored.statusSlots[2], equals(StatusEffect.bless));
    });

    test('restores equipment in gear and pack slots', () {
      final original = _makeAdventurer();
      final sword = EquipmentItem(
        id: 'sw1', name: 'Iron Sword', color: ItemColor.blue,
        rarity: Rarity.common, slots: 1,
      );
      final gem = EquipmentItem(
        id: 'gm1', name: 'Fire Gem', color: ItemColor.purple,
        rarity: Rarity.rare, slots: 2, isInnate: false,
      );
      original.gearSlots[0] = sword;
      original.packSlots[3] = gem;

      final restored = Adventurer.fromJson(original.toJson());

      expect(restored.gearSlots[0]?.id, equals('sw1'));
      expect(restored.gearSlots[0]?.name, equals('Iron Sword'));
      expect(restored.packSlots[3]?.id, equals('gm1'));
      expect(restored.gearSlots.length, equals(4));
      expect(restored.packSlots.length, equals(10));
    });

    test('preserves isInnate flag through serialization', () {
      final original = _makeAdventurer();
      original.gearSlots[0] = const EquipmentItem(
        id: 'inn1', name: 'Innate Strike', color: ItemColor.red,
        rarity: Rarity.exclusive, slots: 1, isInnate: true,
      );

      final restored = Adventurer.fromJson(original.toJson());
      expect(restored.gearSlots[0]?.isInnate, isTrue);
    });
  });
}
