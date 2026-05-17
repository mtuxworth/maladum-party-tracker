import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/maladum_stat.dart';
import '../providers/providers.dart';

const List<String> _kClasses = ['Maladaar', 'Berserker'];

void showAddAdventurerSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const AddAdventurerSheet(),
  );
}

class AddAdventurerSheet extends ConsumerStatefulWidget {
  const AddAdventurerSheet({super.key});

  @override
  ConsumerState<AddAdventurerSheet> createState() => _AddAdventurerSheetState();
}

class _AddAdventurerSheetState extends ConsumerState<AddAdventurerSheet> {
  final _nameController = TextEditingController();
  String _selectedClass = _kClasses.first;
  int _health = 5;
  int _magic = 3;
  int _skill = 3;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final adventurer = Adventurer(
      name: name,
      characterClass: _selectedClass,
      health: MaladumStat(starting: _health, max: _health),
      magic: MaladumStat(starting: _magic, max: _magic),
      skill: MaladumStat(starting: _skill, max: _skill),
      // Action Points are always 2 slots per the rules.
      action: MaladumStat(starting: 2, max: 2),
    );

    ref.read(partyProvider.notifier).addAdventurer(adventurer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Adventurer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: _selectedClass,
            decoration: const InputDecoration(labelText: 'Class'),
            items: _kClasses
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _selectedClass = v!),
          ),
          const SizedBox(height: 12),
          _StatStepperRow(
            label: 'Health',
            value: _health,
            onChanged: (v) => setState(() => _health = v),
          ),
          _StatStepperRow(
            label: 'Magic',
            value: _magic,
            onChanged: (v) => setState(() => _magic = v),
          ),
          _StatStepperRow(
            label: 'Skill',
            value: _skill,
            onChanged: (v) => setState(() => _skill = v),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Adventurer'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatStepperRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _StatStepperRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 64, child: Text(label)),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: value < 10 ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
