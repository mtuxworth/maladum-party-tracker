import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'xp_tracker.dart';

// Stat colours matched to game card face colours.
const _kHealthColor = Color(0xFFEF5350);
const _kSkillColor = Color(0xFF9C27B0);
const _kMagicColor = Color(0xFF00897B);
const _kActionColor = Color(0xFF1E88E5);

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
            _StatPegs(adventurerId: adventurerId),
            const SizedBox(width: 16),
            Expanded(child: XPTracker(adventurerId: adventurerId)),
          ],
        ),
      ],
    );
  }
}

class _StatPegs extends ConsumerWidget {
  final String adventurerId;

  const _StatPegs({required this.adventurerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(adventurerProvider(adventurerId));
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        );

    Widget statRow(String label, int starting, int potential, Color color) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56,
                child: Text(label, style: labelStyle),
              ),
              for (int i = 0; i < starting; i++) _Peg(filled: true, color: color),
              for (int i = starting; i < potential; i++)
                _Peg(filled: false, color: color),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        statRow('Health', a.health.starting, a.health.potential, _kHealthColor),
        statRow('Skill', a.skill.starting, a.skill.potential, _kSkillColor),
        statRow('Magic', a.magic.starting, a.magic.potential, _kMagicColor),
        statRow('Action', a.action.starting, a.action.potential, _kActionColor),
      ],
    );
  }
}

class _Peg extends StatelessWidget {
  final bool filled;
  final Color color;

  const _Peg({required this.filled, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color : Colors.transparent,
          border: Border.all(
            color: filled ? color : Colors.white.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
      ),
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
