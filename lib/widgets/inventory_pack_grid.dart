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

    return SizedBox(
      height: _kSlotSize,
      child: Row(
        children: List.generate(maxPackSlots, (i) {
          final item = packSlots[i];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
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
          );
        }),
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
        const SnackBar(content: Text('Not enough pack space.')),
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
    final others = ref
        .watch(partyProvider)
        .adventurers
        .where((a) => a.id != adventurerId)
        .toList();

    return GestureDetector(
      onLongPress: () => _showContextMenu(context, ref, others),
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

  void _showContextMenu(
    BuildContext context,
    WidgetRef ref,
    List others,
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
                style: ctx.textTheme.titleMedium,
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
                    final ok = notifier.givePackItem(slotIndex, target.id);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("${target.name}'s pack is full.")),
                      );
                    }
                  },
                ),
              ),
            ],
            if (!item.isInnate) ...[
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.delete_outline,
                    color: Color(0xFFC62828)),
                title: const Text('Remove'),
                onTap: () {
                  Navigator.pop(ctx);
                  notifier.setPackSlot(slotIndex, null);
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

extension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
