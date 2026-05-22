import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/adventurer_template.dart';
import '../models/adventurer_templates.dart';
import '../models/character_class.dart';
import '../models/character_classes.dart';
import '../models/maladum_stat.dart';
import '../models/skill.dart';
import '../models/skill_data.dart';
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
  final Set<String> _pickedSkillIds = {};

  int get _maxStartingSkills => _template?.skillStart ?? 0;

  List<Skill> get _availableStartingSkills {
    final cls = _charClass;
    if (cls == null) return [];
    return kAllSkills
        .where((s) => s.tier == 1 && cls.skillNames.contains(s.name))
        .toList();
  }

  bool get _canSubmit =>
      _template != null && _charClass != null;

  void _selectTemplate(AdventurerTemplate t) {
    setState(() {
      _template = t;
      _charClass = null;
      _pickedSkillIds.clear();
    });
  }

  void _toggleSkill(String id) {
    setState(() {
      if (_pickedSkillIds.contains(id)) {
        _pickedSkillIds.remove(id);
      } else if (_pickedSkillIds.length < _maxStartingSkills) {
        _pickedSkillIds.add(id);
      }
    });
  }

  void _submit() {
    final tmpl = _template!;
    final cls = _charClass!;
    final adventurer = Adventurer(
      name: tmpl.name,
      templateId: tmpl.id,
      characterClass: cls.id,
      health:
          MaladumStat(starting: tmpl.healthStart, potential: tmpl.healthPotential),
      magic:
          MaladumStat(starting: tmpl.magicStart, potential: tmpl.magicPotential),
      skill:
          MaladumStat(starting: tmpl.skillStart, potential: tmpl.skillPotential),
      action:
          MaladumStat(starting: tmpl.actionStart, potential: tmpl.actionPotential),
      xpPegs: tmpl.startingXp,
      skillPegs: tmpl.skillStart,
      rankXpCosts: List.of(tmpl.rankXpCosts),
      ownedSkillIds: _pickedSkillIds.toList(),
    );
    ref.read(partyProvider.notifier).addAdventurer(adventurer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final skills = _availableStartingSkills;

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Add Adventurer',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _canSubmit ? _submit : null,
                    child:
                        Text('Add ${_template?.name ?? 'Adventurer'}'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionHeader('Choose Adventurer'),
                  const SizedBox(height: 8),
                  ...kAllTemplates.map(
                    (t) => _TemplateTile(
                      template: t,
                      isSelected: _template == t,
                      onTap: () => _selectTemplate(t),
                    ),
                  ),
                  if (_template != null) ...[
                    const SizedBox(height: 20),
                    _SectionHeader('Choose Class'),
                    const SizedBox(height: 8),
                    ...kAllClasses.map(
                      (c) {
                        final selected = _charClass == c;
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: selected
                                ? const Color(0xFFE65100)
                                : null,
                            size: 20,
                          ),
                          title: Text(c.name),
                          subtitle: Text(
                            'G${c.guilderCost}'
                            '${c.magicPegSlots > 0 ? ' · ${c.magicPegSlots} magic pegs' : ''}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () => setState(() {
                            _charClass = c;
                            _pickedSkillIds.clear();
                          }),
                        );
                      },
                    ),
                  ],
                  if (_charClass != null &&
                      _maxStartingSkills > 0 &&
                      skills.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionHeader(
                      'Starting Skills'
                      ' (${_pickedSkillIds.length}/$_maxStartingSkills)',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose up to $_maxStartingSkills Tier-1 skills.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    ...skills.map(
                      (s) => CheckboxListTile(
                        dense: true,
                        value: _pickedSkillIds.contains(s.id),
                        title: Text('${s.name} (${s.category})'),
                        subtitle: Text(
                          s.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onChanged:
                            _pickedSkillIds.contains(s.id) ||
                                    _pickedSkillIds.length <
                                        _maxStartingSkills
                                ? (_) => _toggleSkill(s.id)
                                : null,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateTile({
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = template;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? const BorderSide(color: Color(0xFFE65100), width: 2)
            : BorderSide.none,
      ),
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
        trailing: Text(
          'H ${t.healthStart}/${t.healthPotential}  '
          'M ${t.magicStart}/${t.magicPotential}  '
          'Sk ${t.skillStart}/${t.skillPotential}  '
          'Ac ${t.actionStart}/${t.actionPotential}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        selected: isSelected,
      ),
    );
  }
}
