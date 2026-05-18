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

// Card background colours matched to the rulebook skill category colours.
Color skillCategoryColor(String category) => switch (category) {
      'Agility' => const Color(0xFF6B3A1F),
      'Cunning' => const Color(0xFF4A2875),
      'Endurance' => const Color(0xFF1A3A72),
      'Magic' => const Color(0xFF0D1F5C),
      'Melee' => const Color(0xFF7F1010),
      'Ranged' => const Color(0xFF1A4A3A),
      'Stealth' => const Color(0xFF1C1C28),
      'Support' => const Color(0xFF5A4010),
      'Survival' => const Color(0xFF1A4A1A),
      _ => const Color(0xFF2C2C2C),
    };

// One card per unique skill name, showing tier pegs and current description.
class SkillGroup extends StatelessWidget {
  final List<Skill> tiers; // sorted tier 1 → 3
  final Set<String> ownedSkillIds;
  final int skillPegs;
  final void Function(String skillId) onUnlock;
  final VoidCallback onUse;

  const SkillGroup({
    required this.tiers,
    required this.ownedSkillIds,
    required this.skillPegs,
    required this.onUnlock,
    required this.onUse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int currentTier = 0;
    for (final s in tiers) {
      if (ownedSkillIds.contains(s.id)) currentTier = s.tier;
    }

    final isOwned = currentTier > 0;
    final displaySkill = isOwned
        ? tiers.firstWhere((s) => s.tier == currentTier)
        : tiers.first;
    final nextSkill =
        tiers.where((s) => s.tier == currentTier + 1).firstOrNull;
    final canUnlock = nextSkill != null;

    final category = tiers.first.category;
    final bgColor = skillCategoryColor(category);
    const white = Colors.white;
    const white70 = Color(0xB3FFFFFF);
    const white40 = Color(0x66FFFFFF);

    return Card(
      color: bgColor,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(skillCategoryIcon(category), size: 16, color: white70),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tiers.first.name,
                    style: const TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(tiers.length, (i) {
                    final owned = (i + 1) <= currentTier;
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: owned ? white : Colors.transparent,
                          border: Border.all(
                            color: owned ? white : white40,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              displaySkill.description,
              style: const TextStyle(color: white70, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isOwned || canUnlock) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isOwned)
                    _CardButton(
                      label: 'Use',
                      onPressed: skillPegs > 0 ? onUse : null,
                    ),
                  if (isOwned && canUnlock) const SizedBox(width: 8),
                  if (canUnlock)
                    _CardButton(
                      label: isOwned
                          ? 'Upgrade to T${currentTier + 1}'
                          : 'Unlock',
                      onPressed: () => onUnlock(nextSkill.id),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _CardButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white38,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
