import 'package:flutter_maladum/models/adventurer.dart';
import 'package:flutter_maladum/models/maladum_stat.dart';
import 'package:flutter_maladum/providers/adventurer_notifier.dart';
import 'package:flutter_maladum/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:flutter_maladum/models/adventurer.dart';

const String kTestId = 'test-id';

Adventurer makeTestAdventurer({
  String name = 'Thorn',
  String characterClass = 'Maladaar',
  int healthStarting = 5,
  int healthMax = 5,
  int xpPegs = 0,
  int skillPegs = 0,
  List<String>? ownedSkillIds,
}) =>
    Adventurer(
      id: kTestId,
      name: name,
      characterClass: characterClass,
      health: MaladumStat(starting: healthStarting, potential: healthMax),
      magic: MaladumStat(starting: 3, potential: 3),
      skill: MaladumStat(starting: 4, potential: 4),
      action: MaladumStat(starting: 2, potential: 2),
      xpPegs: xpPegs,
      skillPegs: skillPegs,
      ownedSkillIds: ownedSkillIds ?? [],
    );

/// Fake notifier that bypasses Hive/partyProvider — returns a fixed state.
class FakeAdventurerNotifier extends AdventurerNotifier {
  final Adventurer initial;
  FakeAdventurerNotifier(this.initial);

  @override
  Adventurer build(String arg) => initial;
}

/// Overrides the entire adventurerProvider family so any adventurerId works.
Override fakeAdventurerOverride(Adventurer adventurer) =>
    adventurerProvider.overrideWith(() => FakeAdventurerNotifier(adventurer));
