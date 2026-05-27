import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/adventurer_template.dart';
import '../models/adventurer_templates.dart';
import '../models/character_class.dart';
import '../models/character_classes.dart';
import '../models/maladum_stat.dart';
import '../providers/providers.dart';

void showAddAdventurerSheet(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) => const _HireAdventurerDialog(),
  );
}

class _HireAdventurerDialog extends ConsumerStatefulWidget {
  const _HireAdventurerDialog();

  @override
  ConsumerState<_HireAdventurerDialog> createState() =>
      _HireAdventurerDialogState();
}

class _HireAdventurerDialogState
    extends ConsumerState<_HireAdventurerDialog> {
  AdventurerTemplate? _template;
  CharacterClass? _charClass;

  bool get _canSubmit => _template != null && _charClass != null;

  void _selectTemplate(AdventurerTemplate t) {
    setState(() {
      _template = t;
      _charClass = null;
    });
  }

  void _clearTemplate() {
    setState(() {
      _template = null;
      _charClass = null;
    });
  }

  void _submit() {
    final tmpl = _template!;
    final cls = _charClass!;
    final adventurer = Adventurer(
      name: tmpl.name,
      templateId: tmpl.id,
      characterClass: cls.id,
      health: MaladumStat(
        starting: tmpl.healthStart,
        potential: tmpl.healthPotential,
      ),
      magic: MaladumStat(
        starting: tmpl.magicStart,
        potential: tmpl.magicPotential,
      ),
      skill: MaladumStat(
        starting: tmpl.skillStart,
        potential: tmpl.skillPotential,
      ),
      action: MaladumStat(
        starting: tmpl.actionStart,
        potential: tmpl.actionPotential,
      ),
      xpPegs: tmpl.startingXp,
      skillPegs: tmpl.skillStart,
      rankXpCosts: List.of(tmpl.rankXpCosts),
      ownedSkillIds: [],
    );
    ref.read(partyProvider.notifier).addAdventurer(adventurer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Template IDs already present in the roster — excluded from the picker.
    final hiredIds = ref
        .watch(partyProvider)
        .adventurers
        .map((a) => a.templateId)
        .whereType<String>()
        .toSet();

    final templateChosen = _template != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 16, 8),
              child: Row(
                children: [
                  if (templateChosen)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Choose a different adventurer',
                      onPressed: _clearTemplate,
                    )
                  else
                    const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      templateChosen
                          ? _template!.name
                          : 'Hire Adventurer',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_canSubmit)
                    FilledButton(
                      onPressed: _submit,
                      child: const Text('Hire'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // ── Body ────────────────────────────────────────────────────
            Flexible(
              child: templateChosen
                  ? _ClassPickerList(
                      template: _template!,
                      selectedClass: _charClass,
                      onSelectClass: (c) =>
                          setState(() => _charClass = c),
                    )
                  : _TemplateList(
                      hiredIds: hiredIds,
                      onSelectTemplate: _selectTemplate,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Phase 1: adventurer selection list ──────────────────────────────────────

class _TemplateList extends StatelessWidget {
  final Set<String> hiredIds;
  final void Function(AdventurerTemplate) onSelectTemplate;

  const _TemplateList({
    required this.hiredIds,
    required this.onSelectTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final available =
        kAllTemplates.where((t) => !hiredIds.contains(t.id)).toList();

    if (available.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'All adventurers have already been hired.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader('Choose Adventurer'),
        const SizedBox(height: 8),
        ...available.map(
          (t) => _TemplateTile(
            template: t,
            onTap: () => onSelectTemplate(t),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Phase 2: class picker ────────────────────────────────────────────────────

class _ClassPickerList extends StatelessWidget {
  final AdventurerTemplate template;
  final CharacterClass? selectedClass;
  final void Function(CharacterClass) onSelectClass;

  const _ClassPickerList({
    required this.template,
    required this.selectedClass,
    required this.onSelectClass,
  });

  @override
  Widget build(BuildContext context) {
    final t = template;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SelectedAdventurerCard(template: t),
        const SizedBox(height: 20),
        _SectionHeader('Choose Class'),
        const SizedBox(height: 8),
        ...kAllClasses.map((c) {
          final isSelected = selectedClass == c;
          return _ClassTile(
            charClass: c,
            isSelected: isSelected,
            onTap: () => onSelectClass(c),
          );
        }),
        if (selectedClass != null) ...[
          const SizedBox(height: 16),
          _GuilderCostBanner(
            template: t,
            charClass: selectedClass!,
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SelectedAdventurerCard extends StatelessWidget {
  final AdventurerTemplate template;
  const _SelectedAdventurerCard({required this.template});

  @override
  Widget build(BuildContext context) {
    final t = template;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE65100), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              t.species,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatChip('Health', '${t.healthStart}/${t.healthPotential}'),
                const SizedBox(width: 8),
                _StatChip('Magic', '${t.magicStart}/${t.magicPotential}'),
                const SizedBox(width: 8),
                _StatChip('Skill', '${t.skillStart}/${t.skillPotential}'),
                const SizedBox(width: 8),
                _StatChip('Action', '${t.actionStart}/${t.actionPotential}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _GuilderBadge(t.guilderCost, highlight: false),
                if (t.startingXp > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${t.startingXp} starting XP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFE65100),
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF9E9E9E),
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

class _ClassTile extends StatelessWidget {
  final CharacterClass charClass;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClassTile({
    required this.charClass,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = charClass;
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Icon(
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_unchecked,
        color: isSelected ? const Color(0xFFE65100) : null,
        size: 20,
      ),
      title: Text(c.name),
      subtitle: c.magicPegSlots > 0
          ? Text(
              '${c.magicPegSlots} magic pegs',
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: _GuilderBadge(c.guilderCost, highlight: isSelected),
    );
  }
}

class _GuilderBadge extends StatelessWidget {
  final int cost;
  final bool highlight;
  const _GuilderBadge(this.cost, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFE65100)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$cost G',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: highlight ? Colors.white : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}

class _GuilderCostBanner extends StatelessWidget {
  final AdventurerTemplate template;
  final CharacterClass charClass;
  const _GuilderCostBanner({
    required this.template,
    required this.charClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE65100).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE65100).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.monetization_on_outlined,
            color: Color(0xFFE65100),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${template.name}  +${template.guilderCost} G',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  '${charClass.name}  +${charClass.guilderCost} G',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
              Text(
                '${template.guilderCost + charClass.guilderCost} Guilders',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

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

class _TemplateTile extends StatelessWidget {
  final AdventurerTemplate template;
  final VoidCallback onTap;

  const _TemplateTile({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = template;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        dense: true,
        onTap: onTap,
        title: Text(
          t.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          t.species,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'H ${t.healthStart}/${t.healthPotential}  '
              'M ${t.magicStart}/${t.magicPotential}  '
              'Sk ${t.skillStart}/${t.skillPotential}  '
              'Ac ${t.actionStart}/${t.actionPotential}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            _GuilderBadge(t.guilderCost),
          ],
        ),
      ),
    );
  }
}
