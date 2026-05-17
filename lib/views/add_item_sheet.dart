import 'dart:math';

import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/equipment_item.dart';

Future<EquipmentItem?> showAddItemSheet(
  BuildContext context, {
  required bool forGear,
}) {
  return showModalBottomSheet<EquipmentItem>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddItemSheet(forGear: forGear),
  );
}

class _AddItemSheet extends StatefulWidget {
  final bool forGear;
  const _AddItemSheet({required this.forGear});

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  ItemColor _color = ItemColor.blue;
  Rarity _rarity = Rarity.common;
  int _slots = 1;
  bool _isInnate = false;

  int get _maxSlots => widget.forGear ? 2 : 4;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.forGear ? 'Add Gear Item' : 'Add Pack Item',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Item name'),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<ItemColor>(
                  value: _color, // ignore: deprecated_member_use
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: ItemColor.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(_colorLabel(c)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _color = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Rarity>(
                  value: _rarity, // ignore: deprecated_member_use
                  decoration: const InputDecoration(labelText: 'Rarity'),
                  items: Rarity.values
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(_rarityLabel(r)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _rarity = v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Slots: $_slots',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Expanded(
                      child: Slider(
                        value: _slots.toDouble(),
                        min: 1,
                        max: _maxSlots.toDouble(),
                        divisions: _maxSlots - 1,
                        label: '$_slots',
                        onChanged: (v) => setState(() => _slots = v.round()),
                      ),
                    ),
                  ],
                ),
                if (widget.forGear)
                  SwitchListTile(
                    title: const Text('Innate item'),
                    subtitle: const Text('Can only be displaced by armour'),
                    value: _isInnate,
                    onChanged: (v) => setState(() => _isInnate = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submit,
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final item = EquipmentItem(
      id: _generateId(),
      name: _nameController.text.trim(),
      color: _color,
      rarity: _rarity,
      slots: _slots,
      isInnate: _isInnate,
    );
    Navigator.pop(context, item);
  }

  String _colorLabel(ItemColor c) => switch (c) {
        ItemColor.blue => 'Blue — Weapon',
        ItemColor.red => 'Red — Gear',
        ItemColor.yellow => 'Yellow — Armour',
        ItemColor.purple => 'Purple — Gem',
        ItemColor.grey => 'Grey — Trap',
      };

  String _rarityLabel(Rarity r) => switch (r) {
        Rarity.common => 'Common',
        Rarity.uncommon => 'Uncommon',
        Rarity.rare => 'Rare',
        Rarity.exclusive => 'Exclusive',
      };
}

String _generateId() {
  final rand = Random();
  return List.generate(8, (_) => rand.nextInt(16).toRadixString(16)).join();
}
