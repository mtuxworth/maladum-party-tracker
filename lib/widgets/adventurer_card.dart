import 'package:flutter/material.dart';

import 'action_point_tracker.dart';
import 'character_header.dart';
import 'gear_slots_grid.dart';
import 'inventory_pack_grid.dart';
import 'skill_tree.dart';
import 'stat_grid.dart';
import 'status_tray.dart';

class AdventurerCard extends StatelessWidget {
  final String adventurerId;

  const AdventurerCard({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CharacterHeader(adventurerId: adventurerId),
            const Divider(height: 24),
            StatGrid(adventurerId: adventurerId),
            const Divider(height: 24),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionPointTracker(adventurerId: adventurerId),
                  const VerticalDivider(),
                  StatusTray(adventurerId: adventurerId),
                ],
              ),
            ),
            const Divider(height: 24),
            SkillTree(adventurerId: adventurerId),
            const Divider(height: 24),
            Text(
              'Gear',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            GearSlotsGrid(adventurerId: adventurerId),
            const SizedBox(height: 16),
            Text(
              'Pack',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            InventoryPackGrid(adventurerId: adventurerId),
          ],
        ),
      ),
    );
  }
}
