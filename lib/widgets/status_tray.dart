import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'status_slot.dart';

class StatusTray extends ConsumerWidget {
  final String adventurerId;

  const StatusTray({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusSlots = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.statusSlots),
    );
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Status', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: StatusSlot(
                slotIndex: i,
                effect: statusSlots[i],
                onChanged: (effect) => notifier.setStatus(i, effect),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
