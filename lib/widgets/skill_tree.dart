import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_classes.dart';
import '../models/skill.dart';
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
    final skillNames = charClass?.skillNames ?? [];
    final classSkills = kAllSkills
        .where((s) => skillNames.contains(s.name))
        .toList();

    // Group into base skills (strip trailing _1/_2/_3) then sort by tier.
    final Map<String, List<Skill>> grouped = {};
    for (final skill in classSkills) {
      final baseId = skill.id.replaceAll(RegExp(r'_\d+$'), '');
      grouped.putIfAbsent(baseId, () => []).add(skill);
    }
    final groups = grouped.values.map((skills) {
      return [...skills]..sort((a, b) => a.tier.compareTo(b.tier));
    }).toList()
      ..sort((a, b) => a.first.name.compareTo(b.first.name));

    final owned = Set<String>.from(adventurer.ownedSkillIds);
    final spent = owned.length;
    final available = (adventurer.xpPegs - spent).clamp(0, adventurer.xpPegs);

    return ExpansionTile(
      title: Row(
        children: [
          const Text('Skills'),
          const SizedBox(width: 8),
          Text(
            '$spent spent · $available available',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Column(
            children: groups.map((tiers) {
              return SkillGroup(
                tiers: tiers,
                ownedSkillIds: owned,
                xpAvailable: available,
                currentRank: adventurer.currentRank,
                onUnlock: (id) => notifier.unlockSkill(id),
                onRemove: (id) => notifier.removeSkill(id),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
