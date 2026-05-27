import 'package:flutter/material.dart';

import '../models/party_state.dart';

// Row of 12 red peg circles. Tapping a peg sets renown to that value;
// tapping the last filled peg deselects it (decrements by 1).
class RenownTracker extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;

  const RenownTracker({
    required this.value,
    required this.onChanged,
    super.key,
  });

  static const _filled = Color(0xFFC62828);
  static const _empty = Color(0x40C62828);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(maxRenown, (i) {
        final lit = i < value;
        return GestureDetector(
          onTap: () => onChanged(lit && i == value - 1 ? i : i + 1),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lit ? _filled : Colors.transparent,
              border: Border.all(
                color: lit ? _filled : _empty,
                width: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }
}
