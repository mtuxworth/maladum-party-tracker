import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'ap_circle.dart';

class ActionPointTracker extends ConsumerWidget {
  final String adventurerId;

  const ActionPointTracker({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apSlots = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.apSlots),
    );
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('AP', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            APCircle(isSpent: apSlots[0], onTap: () => notifier.toggleAP(0)),
            const SizedBox(width: 10),
            APCircle(isSpent: apSlots[1], onTap: () => notifier.toggleAP(1)),
          ],
        ),
      ],
    );
  }
}
