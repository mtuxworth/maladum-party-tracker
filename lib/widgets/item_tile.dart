import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/equipment_data.dart';
import '../models/equipment_item.dart';
import '../models/item_abilities.dart';
import '../providers/providers.dart';

const Map<ItemColor, Color> kItemBorderColors = {
  ItemColor.blue: Color(0xFF1565C0),
  ItemColor.red: Color(0xFFB71C1C),
  ItemColor.yellow: Color(0xFFF9A825),
  ItemColor.purple: Color(0xFF6A1B9A),
  ItemColor.grey: Color(0xFF546E7A),
};

const Map<Rarity, String> _kRarityLabel = {
  Rarity.common: 'C',
  Rarity.uncommon: 'U',
  Rarity.rare: 'R',
  Rarity.exclusive: 'E',
};

const Map<Rarity, String> _kRarityFull = {
  Rarity.common: 'Common',
  Rarity.uncommon: 'Uncommon',
  Rarity.rare: 'Rare',
  Rarity.exclusive: 'Exclusive',
};

const Map<ItemColor, String> _kColorType = {
  ItemColor.blue: 'Weapon',
  ItemColor.red: 'Gear',
  ItemColor.yellow: 'Armour',
  ItemColor.purple: 'Gem',
  ItemColor.grey: 'Trap',
};

CatalogItem? _catalogItemById(String? catalogId) {
  if (catalogId == null) return null;
  final matches = kEquipmentCatalog.where((c) => c.id == catalogId);
  return matches.isEmpty ? null : matches.first;
}

// Shows a detail sheet for any equipment item. Handles both gear and pack.
void showItemDetailSheet(
  BuildContext context,
  WidgetRef ref, {
  required EquipmentItem item,
  required String adventurerId,
  required bool fromGear,
  required int slotIndex,
}) {
  final notifier = ref.read(adventurerProvider(adventurerId).notifier);
  final others = ref
      .read(partyProvider)
      .adventurers
      .where((a) => a.id != adventurerId)
      .toList();
  final catalog = _catalogItemById(item.catalogId);
  final borderColor = kItemBorderColors[item.color]!;

  showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.of(ctx).size.width * 0.9).clamp(0.0, 380.0),
          maxHeight: MediaQuery.of(ctx).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Close button ──────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ),
              const SizedBox(height: 4),
              // ── Detail header ──────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 48,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: ctx.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (catalog != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 4),
                            child: Text(
                              catalog.category,
                              style: ctx.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _InfoChip(
                              label: _kColorType[item.color]!,
                              color: borderColor,
                            ),
                            _InfoChip(
                              label: _kRarityFull[item.rarity]!,
                              color: Colors.grey,
                            ),
                            _InfoChip(
                              label:
                                  '${item.slots} slot${item.slots == 1 ? '' : 's'}',
                              color: Colors.grey,
                            ),
                            if (catalog != null)
                              _InfoChip(
                                label: catalog.rank == 0
                                    ? 'Exclusive'
                                    : 'Rank ${catalog.rank}',
                                color: catalog.rank == 0
                                    ? const Color(0xFF6A1B9A)
                                    : Colors.grey,
                              ),
                            if (item.isInnate)
                              _InfoChip(
                                label: 'Innate',
                                color: const Color(0xFF6A1B9A),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // ── Prices ────────────────────────────────────────────────
              if (item.buyPrice != null || item.sellPrice != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (item.buyPrice != null)
                      _PriceChip(
                        label: 'Buy',
                        value: item.buyPrice!,
                        color: const Color(0xFF2E7D32),
                      ),
                    if (item.buyPrice != null && item.sellPrice != null)
                      const SizedBox(width: 8),
                    if (item.sellPrice != null)
                      _PriceChip(
                        label: 'Sell',
                        value: item.sellPrice!,
                        color: const Color(0xFFE65100),
                      ),
                  ],
                ),
              ],
              // ── Abilities ──────────────────────────────────────────────
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...parseAbilityTokens(item.description).map(
                  (entry) => _AbilityRow(
                    token: entry.$1,
                    ability: entry.$2,
                  ),
                ),
              ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            // ── Actions ──────────────────────────────────────────────────
            if (others.isNotEmpty) ...[
              ...others.map(
                (target) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person),
                  title: Text('Give to ${target.name}'),
                  onTap: () {
                    Navigator.pop(ctx);
                    final ok = fromGear
                        ? notifier.giveGearItem(slotIndex, target.id)
                        : notifier.givePackItem(slotIndex, target.id);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("${target.name}'s inventory is full."),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Divider(height: 1),
            ],
            if (!item.isInnate)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFC62828),
                ),
                title: const Text('Remove'),
                onTap: () {
                  Navigator.pop(ctx);
                  if (fromGear) {
                    notifier.setGearSlot(slotIndex, null);
                  } else {
                    notifier.setPackSlot(slotIndex, null);
                  }
                },
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Innate items can only be removed by equipping armour.',
                  style: ctx.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    ),
  ),
);
}

class ItemTile extends ConsumerWidget {
  final EquipmentItem item;
  final String adventurerId;
  final bool fromGear;
  final int slotIndex;

  const ItemTile({
    required this.item,
    required this.adventurerId,
    required this.fromGear,
    required this.slotIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final borderColor = kItemBorderColors[item.color]!;

    return GestureDetector(
      onTap: () => showItemDetailSheet(
        context,
        ref,
        item: item,
        adventurerId: adventurerId,
        fromGear: fromGear,
        slotIndex: slotIndex,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
          color: borderColor.withValues(alpha: 0.12),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _RarityBadge(rarity: item.rarity, color: borderColor),
            ),
            if (item.isInnate)
              const Positioned(
                bottom: 4,
                left: 4,
                child: Icon(Icons.lock, size: 12, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _PriceChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value == 'X' || value == 'x' ? 'varies' : '${value}g',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AbilityRow extends StatelessWidget {
  final String token;
  final ItemAbility? ability;

  const _AbilityRow({required this.token, required this.ability});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            token,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (ability != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                ability!.description,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}

class _RarityBadge extends StatelessWidget {
  final Rarity rarity;
  final Color color;

  const _RarityBadge({required this.rarity, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: Text(
        _kRarityLabel[rarity]!,
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

extension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
