import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../providers/providers.dart';

void showRankUpDialog(
  BuildContext context,
  String adventurerId,
  int newRank,
) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _RankUpDialog(
      adventurerId: adventurerId,
      newRank: newRank,
    ),
  );
}

class _RankUpDialog extends ConsumerWidget {
  final String adventurerId;
  final int newRank;

  const _RankUpDialog({required this.adventurerId, required this.newRank});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    final boostOptions = <({IconData icon, String label, StatType type})>[
      if (adventurer.health.starting < adventurer.health.potential)
        (icon: Icons.favorite, label: '+1 Health', type: StatType.health),
      if (adventurer.skill.starting < adventurer.skill.potential)
        (
          icon: Icons.sports_martial_arts,
          label: '+1 Skill',
          type: StatType.skill,
        ),
      if (adventurer.magic.starting < adventurer.magic.potential)
        (icon: Icons.auto_fix_high, label: '+1 Magic', type: StatType.magic),
      if (adventurer.action.starting < adventurer.action.potential)
        (icon: Icons.bolt, label: '+1 Action', type: StatType.action),
    ];

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Level ${newRank + 1}!',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xFFE65100)),
          ),
          Text(
            adventurer.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (boostOptions.isEmpty)
              const Text(
                'All stats are at maximum — no boosts available.',
                style: TextStyle(color: Colors.white54),
              )
            else ...[
              _SectionLabel('Choose a permanent stat boost'),
              const SizedBox(height: 6),
              ...boostOptions.map(
                (o) => _RewardTile(
                  icon: o.icon,
                  label: o.label,
                  onTap: () {
                    notifier.increaseStatStarting(o.type);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (boostOptions.isEmpty)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFFE65100),
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RewardTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(label),
      onTap: onTap,
    );
  }
}
