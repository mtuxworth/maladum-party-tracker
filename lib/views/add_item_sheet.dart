import 'dart:math';

import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/equipment_data.dart';
import '../models/equipment_item.dart';
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
                filtered: _filtered,
                onSearchChanged: (v) => setState(() => _search = v),
                onSearchCleared: () {
                  _searchController.clear();
                  setState(() => _search = '');
                },
                onCategorySelected: (cat) => setState(
                  () => _selectedCategory =
                      _selectedCategory == cat ? null : cat,
                ),
                onClearCategory: () =>
                    setState(() => _selectedCategory = null),
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
  final List<CatalogItem> filtered;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onClearCategory;
  final VoidCallback onShowCustom;

  const _CatalogView({
    required this.forGear,
    required this.searchController,
    required this.search,
    required this.selectedCategory,
    required this.filtered,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onCategorySelected,
    required this.onClearCategory,
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
            forGear ? 'Add Gear Item' : 'Add Pack Item',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedCategory == null,
                onSelected: (_) => onClearCategory(),
                visualDensity: VisualDensity.compact,
              ),
              ...kEquipmentCategories.map(
                (cat) => FilterChip(
                  label: Text(cat),
                  selected: selectedCategory == cat,
                  onSelected: (_) => onCategorySelected(cat),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
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
            item.rank > 0 ? 'R${item.rank}' : 'Excl',
            style: TextStyle(
              fontSize: 11,
              color:
                  item.rank > 0 ? Colors.grey : const Color(0xFF6A1B9A),
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

  int get _maxSlots => widget.forGear ? 2 : 4;

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
                decoration:
                    const InputDecoration(labelText: 'Item name'),
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
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(_colorLabel(c)),
                        ),
                      )
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
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(_rarityLabel(r)),
                        ),
                      )
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
                      onChanged: (v) =>
                          setState(() => _slots = v.round()),
                    ),
                  ),
                ],
              ),
              if (widget.forGear)
                SwitchListTile(
                  title: const Text('Innate item'),
                  subtitle:
                      const Text('Can only be displaced by armour'),
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

String _generateId() {
  final rand = Random();
  return List.generate(8, (_) => rand.nextInt(16).toRadixString(16))
      .join();
}
