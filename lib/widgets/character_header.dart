import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'xp_tracker.dart';

class CharacterHeader extends ConsumerWidget {
  final String adventurerId;

  const CharacterHeader({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              child: Text(
                adventurer.name[0].toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adventurer.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    adventurer.characterClass,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  _LevelBadge(rank: adventurer.currentRank),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: XPTracker(adventurerId: adventurerId)),
            const SizedBox(width: 16),
            _StatReference(adventurerId: adventurerId),
          ],
        ),
      ],
    );
  }
}

class _StatReference extends ConsumerWidget {
  final String adventurerId;

  const _StatReference({required this.adventurerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(adventurerProvider(adventurerId));
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        );
    final valueStyle = Theme.of(context).textTheme.bodySmall;

    Widget row(String name, int start, int potential) => Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                child: Text(name, style: labelStyle),
              ),
              Text('$start → $potential', style: valueStyle),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row('H', a.health.starting, a.health.potential),
        row('M', a.magic.starting, a.magic.potential),
        row('Sk', a.skill.starting, a.skill.potential),
        row('Ac', a.action.starting, a.action.potential),
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final int rank;

  const _LevelBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: primary),
      ),
      child: Text(
        'Level ${rank + 1}',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: primary),
      ),
    );
  }
}
