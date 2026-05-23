import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_classes.dart';
import '../models/spell.dart';
import '../models/spell_data.dart';
import '../providers/providers.dart';
import 'keyword_text.dart';

class SpellBrowser extends ConsumerWidget {
  final String adventurerId;

  const SpellBrowser({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventurer = ref.watch(adventurerProvider(adventurerId));
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    final charClass =
        kAllClasses.where((c) => c.id == adventurer.characterClass).firstOrNull;
    if (charClass == null || charClass.spellIds.isEmpty) {
      return const SizedBox.shrink();
    }

    // Resolve spell objects from the class's curated ID list, preserving order.
    final spellMap = {for (final s in kAllSpells) s.id: s};
    final classSpells = charClass.spellIds
        .map((id) => spellMap[id])
        .whereType<Spell>()
        .toList();

    // Group by rank.
    final Map<int, List<Spell>> byRank = {};
    for (final spell in classSpells) {
      byRank.putIfAbsent(spell.rank, () => []).add(spell);
    }
    final ranks = byRank.keys.toList()..sort();

    final owned = Set<String>.from(adventurer.ownedSpellIds);
    final totalSpent =
        adventurer.ownedSkillIds.length + adventurer.ownedSpellIds.length;
    final xpAvailable =
        (adventurer.xpPegs - totalSpent).clamp(0, adventurer.xpPegs);
    final currentRank = adventurer.currentRank;

    return ExpansionTile(
      title: Row(
        children: [
          const Icon(Icons.auto_fix_high, size: 16),
          const SizedBox(width: 8),
          const Text('Spells'),
          const SizedBox(width: 8),
          Text(
            '${owned.length} learned · $xpAvailable XP available',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ranks.map((rank) {
              return _RankSection(
                rank: rank,
                spells: byRank[rank]!,
                ownedSpellIds: owned,
                xpAvailable: xpAvailable,
                currentRank: currentRank,
                onLearn: (id) => notifier.learnSpell(id, rank),
                onForget: (id) => notifier.forgetSpell(id),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RankSection extends StatelessWidget {
  final int rank;
  final List<Spell> spells;
  final Set<String> ownedSpellIds;
  final int xpAvailable;
  // 0-indexed character rank (level 1 = rank 0).
  final int currentRank;
  final void Function(String id) onLearn;
  final void Function(String id) onForget;

  const _RankSection({
    required this.rank,
    required this.spells,
    required this.ownedSpellIds,
    required this.xpAvailable,
    required this.currentRank,
    required this.onLearn,
    required this.onForget,
  });

  @override
  Widget build(BuildContext context) {
    final rankGated = rank > currentRank + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  'Rank $rank',
                  style: TextStyle(
                    color: rankGated ? Colors.white38 : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (rankGated) ...[
                const SizedBox(width: 8),
                Text(
                  'Requires level $rank',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        ...spells.map((spell) => _SpellCard(
              spell: spell,
              isOwned: ownedSpellIds.contains(spell.id),
              canLearn: !rankGated && xpAvailable > 0,
              rankGated: rankGated,
              onLearn: () => onLearn(spell.id),
              onForget: () => onForget(spell.id),
            )),
      ],
    );
  }
}

class _SpellCard extends StatelessWidget {
  final Spell spell;
  final bool isOwned;
  final bool canLearn;
  final bool rankGated;
  final VoidCallback onLearn;
  final VoidCallback onForget;

  const _SpellCard({
    required this.spell,
    required this.isOwned,
    required this.canLearn,
    required this.rankGated,
    required this.onLearn,
    required this.onForget,
  });

  @override
  Widget build(BuildContext context) {
    final school = spell.school;
    const white = Colors.white;
    const white70 = Color(0xB3FFFFFF);
    const white40 = Color(0x66FFFFFF);

    final bgColor = isOwned
        ? school.backgroundColor
        : school.backgroundColor.withValues(alpha: 0.55);
    final borderColor = isOwned ? school.accentColor : white40;

    return Card(
      color: bgColor,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: isOwned ? 1.5 : 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(school.icon,
                    size: 13,
                    color: rankGated ? white40 : school.accentColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    spell.name,
                    style: TextStyle(
                      color: rankGated ? white40 : white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (isOwned)
                  Icon(Icons.auto_fix_high,
                      size: 14, color: school.accentColor),
              ],
            ),
            const SizedBox(height: 5),
            KeywordText(
              spell.description,
              style: TextStyle(
                color: rankGated ? white40 : white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isOwned)
                  _SpellButton(label: '− Forget', onPressed: onForget),
                if (!isOwned)
                  _SpellButton(
                    label: rankGated
                        ? 'Requires Level ${spell.rank}'
                        : 'Learn (1 XP)',
                    onPressed: canLearn ? onLearn : null,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpellButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _SpellButton({required this.label, required this.onPressed});

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
