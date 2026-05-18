import 'package:flutter/material.dart';

import '../models/skill.dart';

IconData skillCategoryIcon(String category) => switch (category) {
      'Agility' => Icons.directions_run,
      'Cunning' => Icons.psychology,
      'Endurance' => Icons.shield,
      'Magic' => Icons.auto_fix_high,
      'Melee' => Icons.gavel,
      'Ranged' => Icons.adjust,
      'Stealth' => Icons.visibility_off,
      'Support' => Icons.favorite,
      'Survival' => Icons.terrain,
      _ => Icons.star_outline,
    };

class SkillNode extends StatelessWidget {
  final Skill skill;
  final bool isOwned;
  final bool isPrerequisiteMet;
  final int skillPegs;
  final VoidCallback onUnlock;
  final VoidCallback onUse;

  const SkillNode({
    required this.skill,
    required this.isOwned,
    required this.isPrerequisiteMet,
    required this.skillPegs,
    required this.onUnlock,
    required this.onUse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final canUnlock = !isOwned && isPrerequisiteMet;
    final canUse = isOwned && skillPegs > 0;

    return ListTile(
      leading: Icon(
        isOwned
            ? skillCategoryIcon(skill.category)
            : Icons.lock_outline,
        color: isOwned
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      title: Text(skill.name),
      subtitle: Text(
        skill.description,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TierBadge(tier: skill.tier),
          const SizedBox(width: 8),
          if (canUnlock)
            TextButton(onPressed: onUnlock, child: const Text('Unlock'))
          else if (isOwned)
            TextButton(
              onPressed: canUse ? onUse : null,
              child: const Text('Use'),
            ),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final int tier;

  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    final isTier1 = tier == 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isTier1
            ? const Color(0xFF1565C0).withValues(alpha: 0.2)
            : const Color(0xFFE65100).withValues(alpha: 0.2),
      ),
      child: Text(
        'T$tier',
        style: TextStyle(
          fontSize: 10,
          color: isTier1 ? const Color(0xFF1565C0) : const Color(0xFFE65100),
        ),
      ),
    );
  }
}
