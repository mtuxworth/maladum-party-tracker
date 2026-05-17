import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/party_state.dart';
import '../providers/providers.dart';
import '../widgets/adventurer_card.dart';
import 'add_adventurer_sheet.dart';

// Cards never shrink below this so content isn't crushed on wide screens with
// 4 adventurers.
const double _kMinCardWidth = 400.0;

class DesktopView extends ConsumerWidget {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);
    final canAdd = party.adventurers.length < maxPartySize;

    // Divide viewport width by the number of actually visible slots so cards
    // expand naturally on wide screens, but never shrink below the minimum.
    final visibleSlots = party.adventurers.length + (canAdd ? 1 : 0);
    final viewWidth = MediaQuery.of(context).size.width;
    final cardWidth = (viewWidth / visibleSlots)
        .clamp(_kMinCardWidth, double.infinity);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...party.adventurers.map(
            (a) => SizedBox(
              width: cardWidth,
              child: AdventurerCard(adventurerId: a.id),
            ),
          ),
          if (canAdd)
            SizedBox(width: cardWidth, child: _AddAdventurerSlot()),
        ],
      ),
    );
  }
}

class _AddAdventurerSlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => showAddAdventurerSheet(context),
        borderRadius: BorderRadius.circular(12),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_add, size: 48),
              SizedBox(height: 8),
              Text('Add Adventurer'),
            ],
          ),
        ),
      ),
    );
  }
}
