import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'ap_circle.dart';

class ActionPointTracker extends ConsumerWidget {
  final String adventurerId;

  const ActionPointTracker({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);
    final apCount = adventurer.action.starting;
    final apSlots = adventurer.apSlots;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('AP', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < apCount; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              APCircle(
                // Guard against apSlots being shorter than apCount if the
                // adventurer gained AP via level-up after creation.
                isSpent: i < apSlots.length && apSlots[i],
                onTap: () => notifier.toggleAP(i),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
