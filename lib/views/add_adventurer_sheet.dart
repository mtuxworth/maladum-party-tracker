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
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _AddAdventurerSheet(),
  );
}

class _AddAdventurerSheet extends ConsumerStatefulWidget {
  const _AddAdventurerSheet();

  @override
  ConsumerState<_AddAdventurerSheet> createState() =>
      _AddAdventurerSheetState();
}

class _AddAdventurerSheetState extends ConsumerState<_AddAdventurerSheet> {
  AdventurerTemplate? _template;
  CharacterClass? _charClass;

  bool get _canSubmit => _template != null && _charClass != null;

  void _selectTemplate(AdventurerTemplate t) {
    setState(() {
      _template = t;
      _charClass = null;
    });
  }

  // Returns to the adventurer list, clearing all selections.
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final templateChosen = _template != null;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Column(
          children: [
            _SheetHandle(),
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
              child: Row(
                children: [
                  // Back arrow shown once a template is chosen.
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
                          : 'Add Adventurer',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_canSubmit)
                    FilledButton(
                      onPressed: _submit,
                      child: const Text('Add'),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: templateChosen
                  ? _ClassPickerList(
                      controller: controller,
                      template: _template!,
                      selectedClass: _charClass,
                      onSelectClass: (c) =>
                          setState(() => _charClass = c),
                    )
                  : _TemplateList(
                      controller: controller,
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
  final ScrollController controller;
  final void Function(AdventurerTemplate) onSelectTemplate;

  const _TemplateList({
    required this.controller,
    required this.onSelectTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(16),
      children: [
        _SectionHeader('Choose Adventurer'),
        const SizedBox(height: 8),
        ...kAllTemplates.map(
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

// ── Phase 2: class picker shown after adventurer chosen ──────────────────────

class _ClassPickerList extends StatelessWidget {
  final ScrollController controller;
  final AdventurerTemplate template;
  final CharacterClass? selectedClass;
  final void Function(CharacterClass) onSelectClass;

  const _ClassPickerList({
    required this.controller,
    required this.template,
    required this.selectedClass,
    required this.onSelectClass,
  });

  @override
  Widget build(BuildContext context) {
    final t = template;
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(16),
      children: [
        // Selected adventurer summary card.
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
        // Guilder cost summary once a class is chosen.
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
            // Stat grid.
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
      // Guilder cost badge on the right of each class row.
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
          const Icon(Icons.monetization_on_outlined,
              color: Color(0xFFE65100), size: 20),
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

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
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
