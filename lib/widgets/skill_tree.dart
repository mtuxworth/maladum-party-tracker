import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_classes.dart';
import '../models/skill_data.dart';
import '../providers/providers.dart';
import 'skill_node.dart';

class SkillTree extends ConsumerWidget {
  final String adventurerId;

  const SkillTree({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    final charClass = kAllClasses
        .where((c) => c.id == adventurer.characterClass)
        .firstOrNull;
    final categories = charClass?.skillCategories ?? [];
    final classSkills = kAllSkills
        .where((s) => categories.contains(s.category))
        .toList();

    return ExpansionTile(
      title: Row(
        children: [
          const Text('Skills'),
          const SizedBox(width: 8),
          Text(
            '(${adventurer.skillPegs} pegs)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      children: classSkills.map((skill) {
        final isOwned = adventurer.ownedSkillIds.contains(skill.id);
        final isPrerequisiteMet = skill.prerequisiteId == null ||
            adventurer.ownedSkillIds.contains(skill.prerequisiteId);

        return SkillNode(
          skill: skill,
          isOwned: isOwned,
          isPrerequisiteMet: isPrerequisiteMet,
          skillPegs: adventurer.skillPegs,
          onUnlock: () => notifier.unlockSkill(skill.id),
          onUse: () {
            final used = notifier.useSkillPeg();
            if (!used && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No skill pegs remaining.')),
              );
            }
          },
        );
      }).toList(),
    );
  }
}
