import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/equipment_data.dart';
import '../models/equipment_item.dart';
import '../models/party_state.dart';
import '../providers/providers.dart';
import '../widgets/item_tile.dart' show kItemBorderColors;

void showMarketDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) => const _MarketDialog(),
  );
}

// ── Sell list data helpers ────────────────────────────────────────────────────

sealed class _ItemOwner {
  const _ItemOwner();
}

final class _OwnedByAdventurer extends _ItemOwner {
  final String adventurerId;
  final String adventurerName;
  final bool isGear;
  final int slotIndex;
  const _OwnedByAdventurer({
    required this.adventurerId,
    required this.adventurerName,
    required this.isGear,
    required this.slotIndex,
  });
}

final class _OwnedByStorage extends _ItemOwner {
  final int slotIndex;
  const _OwnedByStorage(this.slotIndex);
}

class _SellEntry {
  final EquipmentItem item;
  final _ItemOwner owner;
  const _SellEntry({required this.item, required this.owner});

  String get ownerLabel => switch (owner) {
        _OwnedByAdventurer(:final adventurerName) => adventurerName,
        _OwnedByStorage() => 'Storage',
      };
}

List<_SellEntry> _buildSellList(PartyState party) {
  final entries = <_SellEntry>[];

  for (final a in party.adventurers) {
    final seen = <String>{};

    for (int i = 0; i < a.gearSlots.length; i++) {
      final item = a.gearSlots[i];
      if (item != null && seen.add(item.id)) {
        entries.add(_SellEntry(
          item: item,
          owner: _OwnedByAdventurer(
            adventurerId: a.id,
            adventurerName: a.name,
            isGear: true,
            slotIndex: i,
          ),
        ));
      }
    }

    for (int i = 0; i < a.packSlots.length; i++) {
      final item = a.packSlots[i];
      if (item != null && seen.add(item.id)) {
        entries.add(_SellEntry(
          item: item,
          owner: _OwnedByAdventurer(
            adventurerId: a.id,
            adventurerName: a.name,
            isGear: false,
            slotIndex: i,
          ),
        ));
      }
    }
  }

  for (int i = 0; i < party.storageSlots.length; i++) {
    final item = party.storageSlots[i];
    if (item != null) {
      entries.add(_SellEntry(
        item: item,
        owner: _OwnedByStorage(i),
      ));
    }
  }

  return entries;
}

// ── Main dialog ───────────────────────────────────────────────────────────────

class _MarketDialog extends ConsumerStatefulWidget {
  const _MarketDialog();

  @override
  ConsumerState<_MarketDialog> createState() => _MarketDialogState();
}

class _MarketDialogState extends ConsumerState<_MarketDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _search = '';
  String? _selectedCategory;
  Rarity? _selectedRarity;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<CatalogItem> get _filtered {
    final q = _search.toLowerCase();
    return kEquipmentCatalog.where((item) {
      if (_selectedCategory != null && item.category != _selectedCategory) {
        return false;
      }
      if (_selectedRarity != null && item.rarity != _selectedRarity) {
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
  }

  @override
  Widget build(BuildContext context) {
    final party = ref.watch(partyProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
              child: Row(
                children: [
                  const Icon(
                    Icons.storefront,
                    color: Color(0xFFE65100),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Market',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _TreasuryBadge(guilders: party.guilders),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Close market',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Buy'), Tab(text: 'Sell')],
            ),
            const Divider(height: 1),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BuyTab(
                    party: party,
                    searchController: _searchController,
                    search: _search,
                    selectedCategory: _selectedCategory,
                    selectedRarity: _selectedRarity,
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
                    onBuyTap: _handleBuyTap,
                  ),
                  _SellTab(
                    party: party,
                    onSellTap: _handleSellTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBuyTap(CatalogItem catalogItem) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _BuyConfirmDialog(
        catalogItem: catalogItem,
        party: ref.read(partyProvider),
        onConfirm: (destKey, item, price) {
          Navigator.pop(ctx);
          _executeBuy(destKey, item, price, catalogItem.name);
        },
      ),
    );
  }

  void _executeBuy(
    String destKey,
    EquipmentItem item,
    int price,
    String itemName,
  ) {
    final notifier = ref.read(partyProvider.notifier);
    bool placed;
    String? errorMsg;

    if (destKey == 'storage') {
      final emptyIdx =
          ref.read(partyProvider).storageSlots.indexWhere((s) => s == null);
      if (emptyIdx == -1) {
        placed = false;
        errorMsg = 'Storage is full.';
      } else {
        notifier.updateStorageSlot(emptyIdx, item);
        placed = true;
      }
    } else {
      // destKey is an adventurer id
      placed = ref
          .read(adventurerProvider(destKey).notifier)
          .addPackItem(item);
      if (!placed) {
        final adv = ref
            .read(partyProvider)
            .adventurers
            .firstWhere((a) => a.id == destKey);
        errorMsg = "No room in ${adv.name}'s pack.";
      }
    }

    if (placed) {
      if (price > 0) {
        notifier.setGuilders(ref.read(partyProvider).guilders - price);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              price > 0
                  ? 'Bought $itemName for $price G.'
                  : 'Added $itemName to inventory.',
            ),
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg ?? 'Could not add item.')),
      );
    }
  }

  void _handleSellTap(_SellEntry entry) {
    final price = int.tryParse(entry.item.sellPrice ?? '') ?? 0;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sell ${entry.item.name}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ${entry.ownerLabel}',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: Color(0xFFFFB300),
                ),
                const SizedBox(width: 6),
                Text(
                  price > 0
                      ? 'Receive $price Guilders'
                      : 'No sell price listed',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFE65100),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _executeSell(entry, price);
            },
            child: const Text('Sell'),
          ),
        ],
      ),
    );
  }

  void _executeSell(_SellEntry entry, int price) {
    final notifier = ref.read(partyProvider.notifier);

    switch (entry.owner) {
      case _OwnedByAdventurer(
          :final adventurerId,
          :final isGear,
          :final slotIndex,
        ):
        final advNotifier =
            ref.read(adventurerProvider(adventurerId).notifier);
        if (isGear) {
          advNotifier.setGearSlot(slotIndex, null);
        } else {
          advNotifier.setPackSlot(slotIndex, null);
        }
      case _OwnedByStorage(:final slotIndex):
        notifier.updateStorageSlot(slotIndex, null);
    }

    if (price > 0) {
      notifier.setGuilders(ref.read(partyProvider).guilders + price);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            price > 0
                ? 'Sold ${entry.item.name} for $price G.'
                : 'Removed ${entry.item.name} from inventory.',
          ),
        ),
      );
    }
  }
}

// ── Buy tab ───────────────────────────────────────────────────────────────────

class _BuyTab extends StatelessWidget {
  final PartyState party;
  final TextEditingController searchController;
  final String search;
  final String? selectedCategory;
  final Rarity? selectedRarity;
  final List<CatalogItem> filtered;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<Rarity?> onRarityChanged;
  final ValueChanged<CatalogItem> onBuyTap;

  const _BuyTab({
    required this.party,
    required this.searchController,
    required this.search,
    required this.selectedCategory,
    required this.selectedRarity,
    required this.filtered,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onCategoryChanged,
    required this.onRarityChanged,
    required this.onBuyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No items found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _BuyCatalogTile(
                    item: filtered[i],
                    onTap: () => onBuyTap(filtered[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _BuyCatalogTile extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onTap;

  const _BuyCatalogTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = kItemBorderColors[item.color]!;
    final price = int.tryParse(item.buyPrice ?? '');
    final priceLabel = price != null
        ? '$price G'
        : item.buyPrice != null
            ? item.buyPrice!
            : '—';

    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Container(
        width: 8,
        height: 32,
        decoration: BoxDecoration(
          color: color,
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
              color: item.rank > 0 ? Colors.grey : const Color(0xFF6A1B9A),
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
      trailing: _PriceBadge(
        label: priceLabel,
        isNumeric: price != null,
        color: const Color(0xFFFFB300),
      ),
    );
  }
}

// ── Buy confirmation dialog ───────────────────────────────────────────────────

class _BuyConfirmDialog extends StatefulWidget {
  final CatalogItem catalogItem;
  final PartyState party;
  final void Function(String destKey, EquipmentItem item, int price) onConfirm;

  const _BuyConfirmDialog({
    required this.catalogItem,
    required this.party,
    required this.onConfirm,
  });

  @override
  State<_BuyConfirmDialog> createState() => _BuyConfirmDialogState();
}

class _BuyConfirmDialogState extends State<_BuyConfirmDialog> {
  late String _destKey;

  @override
  void initState() {
    super.initState();
    _destKey = widget.party.adventurers.isNotEmpty
        ? widget.party.adventurers.first.id
        : 'storage';
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.catalogItem;
    final party = widget.party;
    final price = int.tryParse(cat.buyPrice ?? '') ?? 0;
    final hasNumericPrice =
        cat.buyPrice != null && int.tryParse(cat.buyPrice!) != null;
    final canAfford = !hasNumericPrice || party.guilders >= price;
    final storageUsed = party.storageSlots.where((s) => s != null).length;

    return AlertDialog(
      title: Text(cat.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cat.description.isNotEmpty) ...[
              Text(
                cat.description,
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
              const SizedBox(height: 12),
            ],
            // Price row
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: Color(0xFFFFB300),
                ),
                const SizedBox(width: 6),
                Text(
                  hasNumericPrice
                      ? '$price Guilders'
                      : cat.buyPrice != null
                          ? '${cat.buyPrice} (variable — no deduction)'
                          : 'No price listed',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (hasNumericPrice && !canAfford) ...[
              const SizedBox(height: 4),
              Text(
                'Not enough Guilders (have ${party.guilders})',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFC62828),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'ADD TO',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFE65100),
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            RadioGroup<String>(
              groupValue: _destKey,
              onChanged: (v) {
                if (v != null) setState(() => _destKey = v);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...party.adventurers.map((a) {
                    final freeSlots = maxPackSlots - a.usedPackVolume;
                    return RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: a.id,
                      title: Text(
                        a.name,
                        style: const TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        '$freeSlots pack slots free',
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  }),
                  RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: 'storage',
                    title: const Text(
                      'Storage',
                      style: TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      '${maxStorageSlots - storageUsed} slots free',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: !canAfford
              ? null
              : () => widget.onConfirm(
                    _destKey,
                    cat.toEquipmentItem(),
                    price,
                  ),
          child: Text(hasNumericPrice ? 'Buy ($price G)' : 'Add'),
        ),
      ],
    );
  }
}

// ── Sell tab ──────────────────────────────────────────────────────────────────

class _SellTab extends StatelessWidget {
  final PartyState party;
  final ValueChanged<_SellEntry> onSellTap;

  const _SellTab({required this.party, required this.onSellTap});

  @override
  Widget build(BuildContext context) {
    final entries = _buildSellList(party);

    if (entries.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No items in inventory to sell.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: entries.length,
      itemBuilder: (ctx, i) => _SellEntryTile(
        entry: entries[i],
        onTap: () => onSellTap(entries[i]),
      ),
    );
  }
}

class _SellEntryTile extends StatelessWidget {
  final _SellEntry entry;
  final VoidCallback onTap;

  const _SellEntryTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final color = kItemBorderColors[item.color]!;
    final price = int.tryParse(item.sellPrice ?? '');
    final priceLabel = price != null
        ? '$price G'
        : item.sellPrice != null
            ? item.sellPrice!
            : '—';

    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Container(
        width: 8,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      title: Text(item.name, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        entry.ownerLabel,
        style: const TextStyle(fontSize: 11, color: Colors.white38),
      ),
      trailing: _PriceBadge(
        label: priceLabel,
        isNumeric: price != null,
        color: const Color(0xFFE65100),
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

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
          const DropdownMenuItem(value: null, child: Text('All')),
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
            (r) => DropdownMenuItem(value: r, child: Text(_labels[r]!)),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _TreasuryBadge extends StatelessWidget {
  final int guilders;
  const _TreasuryBadge({required this.guilders});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFB300).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.monetization_on,
            size: 14,
            color: Color(0xFFFFB300),
          ),
          const SizedBox(width: 4),
          Text(
            '$guilders G',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFB300),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final String label;
  final bool isNumeric;
  final Color color;

  const _PriceBadge({
    required this.label,
    required this.isNumeric,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isNumeric
            ? color.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isNumeric ? color : Colors.white38,
        ),
      ),
    );
  }
}
