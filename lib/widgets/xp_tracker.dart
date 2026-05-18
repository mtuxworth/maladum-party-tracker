import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class XPTracker extends ConsumerWidget {
  final String adventurerId;

  const XPTracker({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));
    final xpPegs = adventurer.xpPegs;
    final costs = adventurer.rankXpCosts;
    final secondary = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        );

    int rowStart = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(costs.length, (rankIndex) {
        final rankCost = costs[rankIndex];
        final start = rowStart;
        rowStart += rankCost;

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Text('Level ${rankIndex + 1}', style: secondary),
              ),
              ...List.generate(rankCost, (pegIndex) {
                final absolutePeg = start + pegIndex + 1;
                final filled = absolutePeg <= xpPegs;
                return _XPPeg(
                  filled: filled,
                  onTap: () {
                    final target = filled ? absolutePeg - 1 : absolutePeg;
                    ref
                        .read(adventurerProvider(adventurerId).notifier)
                        .setXpPegs(target);
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}

class _XPPeg extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;

  const _XPPeg({required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFFFB300);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: filled ? 1.0 : 0.2,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
