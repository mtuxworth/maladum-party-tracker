import 'dart:io';

import 'package:flutter_maladum/models/enums.dart';
import 'package:flutter_maladum/models/party_state.dart';
import 'package:flutter_maladum/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/helpers.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('maladum_test');
    Hive.init(tempDir.path);
    await Hive.openBox<String>('parties');
    container = ProviderContainer();
    container
        .read(partyProvider.notifier)
        .importState(
          PartyState(
            name: 'Before',
            adventurers: [makeTestAdventurer(healthStarting: 4)],
          ),
        );
  });

  tearDown(() async {
    container.dispose();
    await Hive.deleteFromDisk();
    tempDir.deleteSync(recursive: true);
  });

  test('import replaces a live adventurer and later edits keep it', () {
    container.listen(adventurerProvider(kTestId), (_, _) {});
    container
        .read(adventurerProvider(kTestId).notifier)
        .decrementStat(StatType.health);
    expect(container.read(adventurerProvider(kTestId)).health.current, 3);

    container
        .read(partyProvider.notifier)
        .importState(
          PartyState(
            name: 'After',
            adventurers: [makeTestAdventurer(healthStarting: 5)],
          ),
        );
    expect(container.read(adventurerProvider(kTestId)).health.current, 5);

    container
        .read(adventurerProvider(kTestId).notifier)
        .decrementStat(StatType.magic);
    final saved = container.read(partyProvider).adventurers.single;
    expect(saved.health.current, 5);
    expect(saved.magic.current, 2);
  });
}
