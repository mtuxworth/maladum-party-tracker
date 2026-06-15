import 'dart:math';

import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/equipment_data.dart';
import '../models/equipment_item.dart';
import '../models/item_abilities.dart';
import '../widgets/item_tile.dart';

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
  final _searchController = TextEditingController();
  String _search = '';
  String? _selectedCategory;
  Rarity? _selectedRarity;
  ItemSet? _selectedSet;
  bool _showCustomForm = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CatalogItem> get _filtered {
    final q = _search.toLowerCase();
    final items = kEquipmentCatalog.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_selectedRarity != null && item.rarity != _selectedRarity) {
        return false;
      }
      if (_selectedSet != null && item.itemSet != _selectedSet) {
        return false;
      }
      if (q.isNotEmpty &&
          !item.name.toLowerCase().contains(q) &&
          !item.description.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) {
        if (_selectedCategory != null) return a.name.compareTo(b.name);
        final catCmp = a.category.compareTo(b.category);
        return catCmp != 0 ? catCmp : a.name.compareTo(b.name);
      });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.78;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: sheetHeight,
        child: _showCustomForm
            ? _CustomItemForm(
                forGear: widget.forGear,
                onBack: () => setState(() => _showCustomForm = false),
              )
            : _CatalogView(
                forGear: widget.forGear,
                searchController: _searchController,
                search: _search,
                selectedCategory: _selectedCategory,
                selectedRarity: _selectedRarity,
                selectedSet: _selectedSet,
                filtered: _filtered,
                onSearchChanged: (v) => setState(() => _search = v),
                onSearchCleared: () {
                  _searchController.clear();
                  setState(() => _search = '');
                },
                onCategoryChanged: (cat) =>
                    setState(() => _selectedCategory = cat),
                onRarityChanged: (r) =>
                    setState(() => _selectedRarity = r),
                onSetChanged: (s) =>
                    setState(() => _selectedSet = s),
                onShowCustom: () =>
                    setState(() => _showCustomForm = true),
              ),
      ),
    );
  }
}

// ─── Catalog view ─────────────────────────────────────────────────────────────

class _CatalogView extends StatelessWidget {
  final bool forGear;
  final TextEditingController searchController;
  final String search;
  final String? selectedCategory;
  final Rarity? selectedRarity;
  final ItemSet? selectedSet;
  final List<CatalogItem> filtered;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<Rarity?> onRarityChanged;
  final ValueChanged<ItemSet?> onSetChanged;
  final VoidCallback onShowCustom;

  const _CatalogView({
    required this.forGear,
    required this.searchController,
    required this.search,
    required this.selectedCategory,
    required this.selectedRarity,
    required this.selectedSet,
    required this.filtered,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onCategoryChanged,
    required this.onRarityChanged,
    required this.onSetChanged,
    required this.onShowCustom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Text(
            forGear ? 'Add Gear Item' : 'Add Inventory Item',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search…',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: onSearchCleared,
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(height: 8),
        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _FilterColumn(
                  label: 'Item Type',
                  child: _CategoryDropdown(
                    value: selectedCategory,
                    onChanged: onCategoryChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterColumn(
                  label: 'Item Rarity',
                  child: _RarityDropdown(
                    value: selectedRarity,
                    onChanged: onRarityChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterColumn(
                  label: 'Item Set',
                  child: _SetDropdown(
                    value: selectedSet,
                    onChanged: onSetChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length + 1,
            itemBuilder: (ctx, i) {
              if (i == filtered.length) {
                return Column(
                  children: [
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No items found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ListTile(
                      leading: const Icon(Icons.add_circle_outline),
                      title: const Text('Add Custom Item'),
                      onTap: onShowCustom,
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }
              final item = filtered[i];
              return _CatalogTile(
                item: item,
                onTap: () =>
                    Navigator.pop(ctx, item.toEquipmentItem()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CatalogTile extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onTap;

  const _CatalogTile({required this.item, required this.onTap});

  static const _rarityLabel = {
    Rarity.common: 'Common',
    Rarity.uncommon: 'Uncommon',
    Rarity.rare: 'Rare',
    Rarity.exclusive: 'Exclusive',
  };

  static const _rarityColor = {
    Rarity.common: Color(0xFF66BB6A),
    Rarity.uncommon: Color(0xFFFFB300),
    Rarity.rare: Color(0xFF42A5F5),
    Rarity.exclusive: Color(0xFF9E9E9E),
  };

  @override
  Widget build(BuildContext context) {
    final borderColor = kItemBorderColors[item.color]!;
    return ListTile(
      dense: true,
      leading: Container(
        width: 8,
        height: 32,
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(item.name, style: const TextStyle(fontSize: 14)),
          ),
          Text(
            _rarityLabel[item.rarity]!,
            style: TextStyle(
              fontSize: 11,
              color: _rarityColor[item.rarity],
            ),
          ),
        ],
      ),
      subtitle: Text(
        item.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11),
      ),
      onTap: onTap,
    );
  }
}

// ─── Custom item form ──────────────────────────────────────────────────────────

class _CustomItemForm extends StatefulWidget {
  final bool forGear;
  final VoidCallback onBack;

  const _CustomItemForm({required this.forGear, required this.onBack});

  @override
  State<_CustomItemForm> createState() => _CustomItemFormState();
}

class _CustomItemFormState extends State<_CustomItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  ItemColor _color = ItemColor.blue;
  Rarity _rarity = Rarity.common;
  int _slots = 1;
  bool _isInnate = false;
  bool _isStartingItem = false;
  ItemSet _itemSet = ItemSet.base;

  // 0 = no combat stat; 1–5 = Combat N
  int _combatDice = 0;
  // boolean abilities that are toggled on
  final Set<String> _boolAbilities = {};
  // numeric abilities: keyword → value (0 = off)
  final Map<String, int> _numericAbilities = {};

  int get _maxSlots => widget.forGear ? 2 : 4;

  String get _builtDescription {
    final parts = <String>[];
    if (_combatDice > 0) parts.add('Combat $_combatDice');
    for (final name in kFormBooleanAbilities) {
      if (_boolAbilities.contains(name)) parts.add(name);
    }
    for (final name in kFormNumericAbilities) {
      final v = _numericAbilities[name] ?? 0;
      if (v > 0) parts.add('$name $v');
    }
    return parts.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Custom Item',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
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
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Type'),
                child: DropdownButton<ItemColor>(
                  value: _color,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ItemColor.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(_colorLabel(c)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _color = v!),
                ),
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Rarity'),
                child: DropdownButton<Rarity>(
                  value: _rarity,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: Rarity.values
                      .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(_rarityLabel(r)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _rarity = v!),
                ),
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
              SwitchListTile(
                title: const Text('Starting item'),
                subtitle: const Text('Owned at the start of the campaign'),
                value: _isStartingItem,
                onChanged: (v) => setState(() => _isStartingItem = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Item Set'),
                child: DropdownButton<ItemSet>(
                  value: _itemSet,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ItemSet.values
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(kItemSetShortName[s]!),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _itemSet = v!),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // ── Combat dice ─────────────────────────────────────────────
              Text(
                'Combat Dice',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(
                kAbilityByKeyword['Combat']!.description,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[500]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _StepButton(
                    icon: Icons.remove,
                    onPressed: _combatDice > 0
                        ? () => setState(() => _combatDice--)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _combatDice == 0 ? 'None' : '$_combatDice',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: 12),
                  _StepButton(
                    icon: Icons.add,
                    onPressed: _combatDice < 5
                        ? () => setState(() => _combatDice++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ── Boolean abilities ────────────────────────────────────────
              Text(
                'Abilities',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: kFormBooleanAbilities.map((name) {
                  final selected = _boolAbilities.contains(name);
                  return FilterChip(
                    label: Text(name, style: const TextStyle(fontSize: 12)),
                    selected: selected,
                    visualDensity: VisualDensity.compact,
                    tooltip: kAbilityByKeyword[name]?.description,
                    onSelected: (_) => setState(() {
                      if (selected) {
                        _boolAbilities.remove(name);
                      } else {
                        _boolAbilities.add(name);
                      }
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // ── Numeric abilities ────────────────────────────────────────
              Text(
                'Numeric Abilities',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              ...kFormNumericAbilities.map((name) {
                final value = _numericAbilities[name] ?? 0;
                final ability = kAbilityByKeyword[name];
                final max = ability?.maxValue ?? 5;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (ability != null)
                              Text(
                                ability.description,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                      _StepButton(
                        icon: Icons.remove,
                        onPressed: value > 0
                            ? () => setState(
                                () => _numericAbilities[name] = value - 1)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          value == 0 ? '—' : '$value',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      _StepButton(
                        icon: Icons.add,
                        onPressed: value < max
                            ? () => setState(
                                () => _numericAbilities[name] = value + 1)
                            : null,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      EquipmentItem(
        id: _generateId(),
        name: _nameController.text.trim(),
        color: _color,
        rarity: _rarity,
        slots: _slots,
        isInnate: _isInnate,
        isStartingItem: _isStartingItem,
        itemSet: _itemSet,
        description: _builtDescription,
      ),
    );
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

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StepButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton.outlined(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 14),
        onPressed: onPressed,
      ),
    );
  }
}

String _generateId() {
  final rand = Random();
  return List.generate(8, (_) => rand.nextInt(16).toRadixString(16))
      .join();
}

// ─── Filter widgets ───────────────────────────────────────────────────────────

// Wraps a dropdown with a small heading label above it.
class _FilterColumn extends StatelessWidget {
  final String label;
  final Widget child;
  const _FilterColumn({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE65100),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        child,
      ],
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String?>(
        value: value,
        isDense: true,
        isExpanded: true,
        underline: const SizedBox(),
        hint: const Text('All', style: TextStyle(fontSize: 12)),
        style: const TextStyle(fontSize: 12, color: Color(0xFFF5F5F5)),
        items: [
          const DropdownMenuItem(
              value: null, child: Text('All')),
          ...kEquipmentCategories.map(
            (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _RarityDropdown extends StatelessWidget {
  final Rarity? value;
  final ValueChanged<Rarity?> onChanged;

  const _RarityDropdown({required this.value, required this.onChanged});

  static const _labels = {
    Rarity.common: 'Common',
    Rarity.uncommon: 'Uncommon',
    Rarity.rare: 'Rare',
    Rarity.exclusive: 'Exclusive',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<Rarity?>(
        value: value,
        isDense: true,
        isExpanded: true,
        underline: const SizedBox(),
        hint: const Text('All', style: TextStyle(fontSize: 12)),
        style: const TextStyle(fontSize: 12, color: Color(0xFFF5F5F5)),
        items: [
          const DropdownMenuItem(value: null, child: Text('All')),
          ...Rarity.values.map(
            (r) => DropdownMenuItem(
              value: r,
              child: Text(_labels[r]!),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _SetDropdown extends StatelessWidget {
  final ItemSet? value;
  final ValueChanged<ItemSet?> onChanged;

  const _SetDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<ItemSet?>(
        value: value,
        isDense: true,
        isExpanded: true,
        underline: const SizedBox(),
        hint: const Text('All', style: TextStyle(fontSize: 12)),
        style: const TextStyle(fontSize: 12, color: Color(0xFFF5F5F5)),
        items: [
          const DropdownMenuItem(value: null, child: Text('All')),
          ...ItemSet.values.map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(kItemSetName[s]!),
            ),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
