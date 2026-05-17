import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/equipment_item.dart';
import '../providers/adventurer_notifier.dart';
import '../providers/providers.dart';
import '../views/add_item_sheet.dart';
import 'item_tile.dart';

const double _kTileExtent = 80;

class GearSlotsGrid extends ConsumerWidget {
  final String adventurerId;

  const GearSlotsGrid({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gearSlots = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.gearSlots),
    );
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: List.generate(maxGearSlots, (i) {
        final item = gearSlots[i];
        // 2-slot items span both columns; 1-slot items take one column.
        final span = (item?.slots ?? 1).clamp(1, 2);
        return StaggeredGridTile.extent(
          crossAxisCellCount: span,
          mainAxisExtent: _kTileExtent,
          child: item != null
              ? ItemTile(
                  item: item,
                  adventurerId: adventurerId,
                  fromGear: true,
                  slotIndex: i,
                )
              : _EmptyGearSlot(
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
    final item = await showAddItemSheet(context, forGear: true);
    if (item == null || !context.mounted) return;
    final ok = notifier.addGearItem(item);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough gear space.')),
      );
    }
  }
}

class _EmptyGearSlot extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyGearSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.add,
          color: Colors.grey.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
