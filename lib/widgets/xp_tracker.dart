import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

// Tier colors: Novice → Veteran → Legend
const List<Color> _kTierColors = [
  Color(0xFF4CAF50),
  Color(0xFFFFC107),
  Color(0xFFF44336),
];

// 1-indexed peg numbers that trigger a rank-up.
const Set<int> _kRankUpPegs = {3, 7, 10, 14, 17, 21};

class XPTracker extends ConsumerWidget {
  final String adventurerId;

  const XPTracker({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xpPegs = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.xpPegs),
    );

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(21, (i) {
        final pegNumber = i + 1;
        return _XPPeg(
          filled: pegNumber <= xpPegs,
          color: _kTierColors[i ~/ 7],
          isRankUp: _kRankUpPegs.contains(pegNumber),
          onTap: () => ref
              .read(adventurerProvider(adventurerId).notifier)
              .setXpPegs(pegNumber),
        );
      }),
    );
  }
}

class _XPPeg extends StatelessWidget {
  final bool filled;
  final Color color;
  final bool isRankUp;
  final VoidCallback onTap;

  const _XPPeg({
    required this.filled,
    required this.color,
    required this.isRankUp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: filled ? 1.0 : 0.25,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
          if (isRankUp)
            Positioned(
              top: -6,
              right: -4,
              child: Icon(
                Icons.star,
                size: 10,
                color: filled ? Colors.white : Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
