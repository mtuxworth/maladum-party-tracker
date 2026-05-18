import 'package:flutter/material.dart';
import 'package:flutter_maladum/models/enums.dart';
import 'package:flutter_maladum/models/maladum_stat.dart';
import 'package:flutter_maladum/widgets/stat_counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Widget _build(StatType type, String label, Adventurer adventurer) =>
    ProviderScope(
      overrides: [fakeAdventurerOverride(adventurer)],
      child: MaterialApp(
        home: Scaffold(
          body: StatCounter(
            adventurerId: kTestId,
            statType: type,
            label: label,
          ),
        ),
      ),
    );

void main() {
  group('StatCounter', () {
    testWidgets('renders current value', (tester) async {
      final adventurer = makeTestAdventurer(healthStarting: 3, healthMax: 5);

      await tester.pumpWidget(_build(StatType.health, 'Health', adventurer));

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders starting and potential reference', (tester) async {
      final adventurer = makeTestAdventurer(healthStarting: 3, healthMax: 5);

      await tester.pumpWidget(_build(StatType.health, 'Health', adventurer));

      expect(find.text('3 → 5'), findsOneWidget);
    });

    testWidgets('decrease button is disabled when current is 0', (tester) async {
      final adventurer = makeTestAdventurer(healthStarting: 5, healthMax: 5);
      adventurer.health.current = 0;

      await tester.pumpWidget(_build(StatType.health, 'Health', adventurer));

      final decreaseButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.remove),
      );
      expect(decreaseButton.onPressed, isNull);
    });

    testWidgets('increase button is disabled when at potential', (tester) async {
      final adventurer = makeTestAdventurer(healthStarting: 5, healthMax: 5);

      await tester.pumpWidget(_build(StatType.health, 'Health', adventurer));

      final increaseButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.add),
      );
      expect(increaseButton.onPressed, isNull);
    });

    testWidgets('increase button is enabled when below potential', (tester) async {
      final adventurer = makeTestAdventurer(healthStarting: 5, healthMax: 5);
      adventurer.health = MaladumStat(starting: 3, potential: 5);

      await tester.pumpWidget(_build(StatType.health, 'Health', adventurer));

      final increaseButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.add),
      );
      expect(increaseButton.onPressed, isNotNull);
    });

    testWidgets('renders label text', (tester) async {
      final adventurer = makeTestAdventurer();
      await tester.pumpWidget(_build(StatType.magic, 'Magic', adventurer));

      expect(find.text('Magic'), findsOneWidget);
    });
  });
}
