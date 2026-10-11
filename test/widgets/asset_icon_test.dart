import 'package:flutter/material.dart';
import 'package:flutter_maladum/widgets/asset_icon.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('missing asset shows initials fallback', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AssetIcon(
          path: 'assets/icons/does_not_exist.png',
          label: 'Magic Shield',
          size: 28,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MS'), findsOneWidget);
    expect(find.byTooltip('Magic Shield'), findsOneWidget);
  });

  testWidgets('single-word label uses first two letters', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AssetIcon(
          path: 'assets/icons/does_not_exist.png',
          label: 'Stunned',
          size: 28,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ST'), findsOneWidget);
  });
}
