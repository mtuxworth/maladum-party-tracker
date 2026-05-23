import 'package:flutter/material.dart';
import 'package:flutter_maladum/models/enums.dart';
import 'package:flutter_maladum/widgets/status_slot.dart';
import 'package:flutter_maladum/widgets/status_tray.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Widget _build(Adventurer adventurer) => ProviderScope(
      overrides: [fakeAdventurerOverride(adventurer)],
      child: MaterialApp(
        home: Scaffold(
          body: StatusTray(adventurerId: kTestId),
        ),
      ),
    );

void main() {
  group('StatusTray', () {
    testWidgets('renders exactly 3 status slots', (tester) async {
      await tester.pumpWidget(_build(makeTestAdventurer()));

      expect(find.byType(StatusSlot), findsNWidgets(3));
    });

    testWidgets('empty slots display the add icon', (tester) async {
      await tester.pumpWidget(_build(makeTestAdventurer()));

      expect(find.byIcon(Icons.add), findsNWidgets(3));
    });

    testWidgets('occupied slot hides the add icon', (tester) async {
      final adventurer = makeTestAdventurer();
      adventurer.statusSlots[0] = StatusEffect.poisoned;

      await tester.pumpWidget(_build(adventurer));

      // Slot now shows an image, not text — only 2 empty slots remain.
      expect(find.byIcon(Icons.add), findsNWidgets(2));
    });

    testWidgets('renders Status label', (tester) async {
      await tester.pumpWidget(_build(makeTestAdventurer()));

      expect(find.text('Status'), findsOneWidget);
    });
  });
}
