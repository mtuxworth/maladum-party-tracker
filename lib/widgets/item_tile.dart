import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/enums.dart';
import '../models/equipment_item.dart';
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
    final others = ref
        .watch(partyProvider)
        .adventurers
        .where((a) => a.id != adventurerId)
        .toList();

    return GestureDetector(
      onLongPress: () => _showContextMenu(context, ref, others),
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

  void _showContextMenu(
    BuildContext context,
    WidgetRef ref,
    List<Adventurer> others,
  ) {
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                item.name,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            if (others.isNotEmpty) ...[
              const Divider(height: 0),
              ...others.map(
                (target) => ListTile(
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
                          content: Text("${target.name}'s pack is full."),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
            // Innate items cannot be freely removed — only armour can displace them.
            if (!item.isInnate) ...[
              const Divider(height: 0),
              ListTile(
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
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
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
