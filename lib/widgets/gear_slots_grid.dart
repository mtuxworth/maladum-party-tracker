import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/equipment_item.dart';
import '../providers/adventurer_notifier.dart';
import '../providers/providers.dart';
import '../views/add_item_sheet.dart';
import 'item_tile.dart';

const double _kSlotHeight = 80;

class GearSlotsGrid extends ConsumerWidget {
  final String adventurerId;

  const GearSlotsGrid({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gearSlots = ref.watch(
      adventurerProvider(adventurerId).select((a) => a.gearSlots),
    );
    final notifier = ref.read(adventurerProvider(adventurerId).notifier);

    // Each visual gear slot = 2 actual slot-units. Items are stored in
    // gear-rounded multiples of 2, so we step by that rounded count and
    // always produce exactly 2 visual cells (flex 1 each).
    final children = <Widget>[];
    int i = 0;
    while (i < maxGearSlots) {
      final slotStart = i;
      final item = gearSlots[slotStart];
      // Gear-rounded width: round item.slots up to nearest even.
      final gearN = item != null ? ((item.slots + 1) ~/ 2) * 2 : 2;
      // Visual flex: how many visual slots this cell occupies.
      final visualFlex = gearN ~/ 2;
      i += gearN;

      children.add(Expanded(
        flex: visualFlex,
        child: Padding(
          padding: EdgeInsets.only(left: children.isEmpty ? 0 : 6),
          child: DragTarget<EquipmentItem>(
            onWillAcceptWithDetails: (d) {
              final n = ((d.data.slots + 1) ~/ 2) * 2;
              return d.data.color == ItemColor.yellow &&
                  slotStart + n <= maxGearSlots;
            },
            onAcceptWithDetails: (d) {
              final ok = notifier.swapPackToGear(d.data, slotStart);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No inventory space for the swap.'),
                  ),
                );
              }
            },
            builder: (ctx, candidates, _) {
              final hovering = candidates.isNotEmpty;
              Widget cell = item != null
                  ? ItemTile(
                      item: item,
                      adventurerId: adventurerId,
                      fromGear: true,
                      slotIndex: slotStart,
                    )
                  : _EmptyGearSlot(
                      onTap: () => _addItem(context, notifier),
                    );
              if (hovering) {
                cell = Stack(
                  children: [
                    cell,
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFF9A825)
                              .withValues(alpha: 0.25),
                          border: Border.all(
                            color: const Color(0xFFF9A825),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return cell;
            },
          ),
        ),
      ));
    }

    return SizedBox(
      height: _kSlotHeight,
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
