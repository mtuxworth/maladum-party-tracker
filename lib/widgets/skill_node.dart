import 'package:flutter/material.dart';

import '../models/skill.dart';
import 'keyword_text.dart';

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

// Card background colours — light pastels with black text.
Color skillCategoryColor(String category) => switch (category) {
      'Agility'   => const Color(0xFFCDB8F0), // light purple
      'Cunning'   => const Color(0xFFDDC8A8), // light tan
      'Endurance' => const Color(0xFFEEEE88), // light lemon yellow
      'Magic'     => const Color(0xFFAAD4F8), // light blue
      'Melee'     => const Color(0xFFF0A0A0), // light red
      'Ranged'    => const Color(0xFF9ADCB4), // light green
      'Stealth'   => const Color(0xFFF8C080), // light orange
      'Support'   => const Color(0xFFCCCCDC), // light grey
      'Survival'  => const Color(0xFF8ECC98), // light forest green
      _           => const Color(0xFF2C2C2C),
    };

// One card per unique skill name, showing tier dots, current description,
// and XP-cost buttons to unlock/upgrade or refund the highest owned tier.
class SkillGroup extends StatelessWidget {
  final List<Skill> tiers; // sorted tier 1 → 3
  final Set<String> ownedSkillIds;
  // Remaining XP the adventurer can still spend (xpPegs - skills already owned).
  final int xpAvailable;
  // 0-indexed rank (level 1 = rank 0). Tier N requires rank >= N - 1.
  final int currentRank;
  final void Function(String skillId) onUnlock;
  // Called with the highest currently-owned tier's id to refund 1 XP.
  final void Function(String skillId) onRemove;

  const SkillGroup({
    required this.tiers,
    required this.ownedSkillIds,
    required this.xpAvailable,
    required this.currentRank,
    required this.onUnlock,
    required this.onRemove,
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
    final highestOwned = isOwned
        ? tiers.firstWhere((s) => s.tier == currentTier)
        : null;
    final nextSkill =
        tiers.where((s) => s.tier == currentTier + 1).firstOrNull;
    // Tier N requires character level N (rank N-1).
    final levelGated =
        nextSkill != null && nextSkill.tier > currentRank + 1;
    final canUnlock = nextSkill != null && xpAvailable > 0 && !levelGated;

    final category = tiers.first.category;
    final bgColor = skillCategoryColor(category);
    const ink = Colors.black87;
    const ink60 = Color(0x99000000);
    const ink35 = Color(0x59000000);

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
                Icon(skillCategoryIcon(category), size: 16, color: ink60),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tiers.first.name,
                    style: const TextStyle(
                      color: ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                // Tier dots: filled = owned, empty = not yet unlocked.
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
                          color: owned ? ink : Colors.transparent,
                          border: Border.all(
                            color: owned ? ink : ink35,
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
            KeywordText(
              displaySkill.description,
              style: const TextStyle(color: ink60, fontSize: 12),
            ),
            if (isOwned || nextSkill != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  // Info button on the left — tappable area is the full IconButton.
                  if (tiers.length > 1)
                    IconButton(
                      onPressed: () =>
                          _showTierDialog(context, tiers, currentTier),
                      icon: const Icon(Icons.info_outline),
                      iconSize: 20,
                      color: ink35,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      tooltip: 'All tier descriptions',
                    ),
                  const Spacer(),
                  if (isOwned)
                    _CardButton(
                      label: '− Refund',
                      onPressed: () => onRemove(highestOwned!.id),
                    ),
                  if (isOwned && nextSkill != null) const SizedBox(width: 8),
                  if (nextSkill != null)
                    _CardButton(
                      label: levelGated
                          ? 'Requires Level ${nextSkill.tier}'
                          : isOwned
                              ? 'Upgrade T${currentTier + 1} (1 XP)'
                              : 'Unlock (1 XP)',
                      onPressed: canUnlock ? () => onUnlock(nextSkill.id) : null,
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

void _showTierDialog(
  BuildContext context,
  List<Skill> tiers,
  int currentTier,
) {
  showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _TierDialogContent(tiers: tiers, currentTier: currentTier),
      ),
    ),
  );
}

class _TierDialogContent extends StatelessWidget {
  final List<Skill> tiers;
  final int currentTier;

  const _TierDialogContent({required this.tiers, required this.currentTier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tiers.first.name,
            style: const TextStyle(
              color: Color(0xFFF5F5F5),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...tiers.map((skill) {
            final isOwned = skill.tier <= currentTier;
            final isCurrent = skill.tier == currentTier;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tier badge
                  Container(
                    width: 48,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? const Color(0xFFE65100)
                          : isOwned
                              ? const Color(0xFF444444)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isOwned
                            ? Colors.transparent
                            : const Color(0xFF555555),
                      ),
                    ),
                    child: Text(
                      'Tier ${skill.tier}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isCurrent
                            ? Colors.white
                            : isOwned
                                ? const Color(0xFFCCCCCC)
                                : const Color(0xFF777777),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KeywordText(
                      skill.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isOwned
                            ? const Color(0xFFF5F5F5)
                            : const Color(0xFF777777),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFFE65100)),
              ),
            ),
          ),
        ],
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
        foregroundColor: Colors.black87,
        disabledForegroundColor: Colors.black38,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
