import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/adventurer_card.dart';
import 'add_adventurer_sheet.dart';

class MobileView extends ConsumerWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);

    if (party.adventurers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined, size: 64),
            const SizedBox(height: 16),
            const Text('No adventurers yet.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => showAddAdventurerSheet(context),
              icon: const Icon(Icons.person_add),
              label: const Text('Add First Adventurer'),
            ),
          ],
        ),
      );
    }

    // Key on length so TabController resets cleanly when adventurers are added.
    return DefaultTabController(
      key: ValueKey(party.adventurers.length),
      length: party.adventurers.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: party.adventurers
                .map((a) => Tab(text: a.name))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: party.adventurers
                  .map((a) => AdventurerCard(adventurerId: a.id))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
