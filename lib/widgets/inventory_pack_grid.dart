import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/equipment_item.dart';
import '../providers/adventurer_notifier.dart';
import '../providers/providers.dart';
import '../views/add_item_sheet.dart';
import 'item_tile.dart';

const double _kSlotSize = 52;

class InventoryPackGrid extends ConsumerWidget {
  final String adventurerId;

  const InventoryPackGrid({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packSlots = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.packSlots),
    );
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    // Build children, skipping continuation indices (same item stored at
    // consecutive slots for multi-slot items). Use flex=slots so multi-slot
    // items occupy proportionally more width in the row.
    final children = <Widget>[];
    String? lastItemId;
    for (int i = 0; i < maxPackSlots; i++) {
      final item = packSlots[i];
      if (item != null && item.id == lastItemId) continue;
      lastItemId = item?.id;
      final flex = item?.slots ?? 1;
      children.add(Expanded(
        flex: flex,
        child: Padding(
          padding: EdgeInsets.only(left: children.isEmpty ? 0 : 4),
          child: item != null
              ? _CompactItemTile(
                  item: item,
                  adventurerId: adventurerId,
                  slotIndex: i,
                )
              : _EmptyPackSlot(
                  onTap: () => _addItem(context, notifier),
                ),
        ),
      ));
    }
    return SizedBox(
      height: _kSlotSize,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Future<void> _addItem(
    BuildContext context,
    AdventurerNotifier notifier,
  ) async {
    final item = await showAddItemSheet(context, forGear: false);
    if (item == null || !context.mounted) return;
    final ok = notifier.addPackItem(item);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough inventory space.')),
      );
    }
  }
}

// Compact single-slot tile for the pack row.
class _CompactItemTile extends ConsumerWidget {
  final EquipmentItem item;
  final String adventurerId;
  final int slotIndex;

  const _CompactItemTile({
    required this.item,
    required this.adventurerId,
    required this.slotIndex,
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
        fromGear: false,
        slotIndex: slotIndex,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 2),
          color: borderColor.withValues(alpha: 0.15),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (item.isInnate)
              const Positioned(
                bottom: 2,
                right: 2,
                child: Icon(Icons.lock, size: 8, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }

}

class _EmptyPackSlot extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyPackSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 14,
          color: Colors.grey.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
