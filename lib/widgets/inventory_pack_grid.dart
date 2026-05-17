import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/equipment_item.dart';
import '../providers/adventurer_notifier.dart';
import '../providers/providers.dart';
import '../views/add_item_sheet.dart';
import 'item_tile.dart';

const double _kTileExtent = 72;

class InventoryPackGrid extends ConsumerWidget {
  final String adventurerId;

  const InventoryPackGrid({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packSlots = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.packSlots),
    );
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: List.generate(maxPackSlots, (i) {
        final item = packSlots[i];
        // Span based on slots: 1–2 → 1 column, 3–4 → 2 columns.
        final span = (item != null && item.slots >= 3) ? 2 : 1;
        return StaggeredGridTile.extent(
          crossAxisCellCount: span,
          mainAxisExtent: _kTileExtent,
          child: item != null
              ? ItemTile(
                  item: item,
                  adventurerId: adventurerId,
                  fromGear: false,
                  slotIndex: i,
                )
              : _EmptyPackSlot(
                  onTap: () => _addItem(context, notifier),
                ),
        );
      }),
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

class _EmptyPackSlot extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyPackSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 18,
          color: Colors.grey.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
