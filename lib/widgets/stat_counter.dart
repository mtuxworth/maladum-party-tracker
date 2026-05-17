import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/enums.dart';
import '../models/maladum_stat.dart';
import '../providers/providers.dart';

class StatCounter extends ConsumerWidget {
  final String adventurerId;
  final StatType statType;
  final String label;

  const StatCounter({
    required this.adventurerId,
    required this.statType,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));
    final stat = _statFor(adventurer);
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              tooltip: 'Decrease $label',
              // null → visually disabled per requirements
              onPressed: stat.current > 0
                  ? () => notifier.decrementStat(statType)
                  : null,
            ),
            SizedBox(
              width: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '${stat.current}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      '/${stat.max}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Increase $label',
              onPressed: stat.current < stat.max
                  ? () => notifier.incrementStat(statType)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  MaladumStat _statFor(Adventurer adventurer) => switch (statType) {
        StatType.health => adventurer.health,
        StatType.magic => adventurer.magic,
        StatType.skill => adventurer.skill,
        StatType.action => adventurer.action,
      };
}
