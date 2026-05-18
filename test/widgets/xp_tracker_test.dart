import 'package:flutter/material.dart';
import 'package:flutter_maladum/widgets/xp_tracker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Widget _build(Adventurer adventurer) => ProviderScope(
      overrides: [fakeAdventurerOverride(adventurer)],
      child: MaterialApp(
        home: Scaffold(
          body: XPTracker(adventurerId: kTestId),
        ),
      ),
    );

void main() {
  // Default rankXpCosts = [3, 4, 4, 5, 5] → 5 rows, 21 pegs total.
  group('XPTracker', () {
    testWidgets('renders 5 rank rows', (tester) async {
      await tester.pumpWidget(_build(makeTestAdventurer()));

      // One GestureDetector per peg: 3+4+4+5+5 = 21 total.
      expect(find.byType(GestureDetector), findsNWidgets(21));
    });

    testWidgets('all pegs dim when xpPegs is 0', (tester) async {
      await tester.pumpWidget(_build(makeTestAdventurer(xpPegs: 0)));
      await tester.pump(const Duration(milliseconds: 200));

      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((w) => w.opacity)
          .toList();

      expect(opacities.length, 21);
      expect(opacities.every((o) => o == 0.2), isTrue);
    });

    testWidgets('first 7 pegs are filled when xpPegs is 7', (tester) async {
      await tester.pumpWidget(_build(makeTestAdventurer(xpPegs: 7)));
      await tester.pump(const Duration(milliseconds: 200));

      final opacities = tester
          .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
          .map((w) => w.opacity)
          .toList();

      expect(opacities.sublist(0, 7).every((o) => o == 1.0), isTrue);
      expect(opacities.sublist(7).every((o) => o == 0.2), isTrue);
    });
  });
}
