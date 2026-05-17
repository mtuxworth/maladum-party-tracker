import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/skill.dart';
import '../models/skill_data.dart';
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

    final availableSkills = kAllSkills
        .where(
          (s) =>
              s.characterClass == adventurer.characterClass &&
              !adventurer.ownedSkillIds.contains(s.id) &&
              (s.prerequisiteId == null ||
                  adventurer.ownedSkillIds.contains(s.prerequisiteId)),
        )
        .toList();

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Rank $newRank!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: const Color(0xFFE65100))),
          Text(adventurer.name,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Choose a permanent reward:'),
            const SizedBox(height: 16),
            _SectionLabel('Boost a Max Stat'),
            const SizedBox(height: 6),
            _RewardTile(
              icon: Icons.favorite,
              label: '+1 Health Max',
              onTap: () {
                notifier.increaseStatMax(StatType.health);
                Navigator.pop(context);
              },
            ),
            _RewardTile(
              icon: Icons.auto_fix_high,
              label: '+1 Magic Max',
              onTap: () {
                notifier.increaseStatMax(StatType.magic);
                Navigator.pop(context);
              },
            ),
            _RewardTile(
              icon: Icons.sports_martial_arts,
              label: '+1 Skill Max',
              onTap: () {
                notifier.increaseStatMax(StatType.skill);
                Navigator.pop(context);
              },
            ),
            _RewardTile(
              icon: Icons.bolt,
              label: '+1 Action Max',
              onTap: () {
                notifier.increaseStatMax(StatType.action);
                Navigator.pop(context);
              },
            ),
            if (availableSkills.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionLabel('Unlock a Skill'),
              const SizedBox(height: 6),
              ...availableSkills.map(
                (skill) => _SkillRewardTile(
                  skill: skill,
                  onTap: () {
                    notifier.unlockSkill(skill.id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
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

class _SkillRewardTile extends StatelessWidget {
  final Skill skill;
  final VoidCallback onTap;

  const _SkillRewardTile({required this.skill, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.auto_awesome, size: 20),
      title: Text(skill.name),
      subtitle: Text(
        skill.description,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        'T${skill.tier}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }
}
