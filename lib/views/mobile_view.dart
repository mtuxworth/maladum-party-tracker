import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/adventurer_card.dart';
import 'base_camp_view.dart';

class MobileView extends ConsumerWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);
    final activeParty = party.activeParty;

    if (activeParty.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield_outlined, size: 64, color: Colors.white38),
            const SizedBox(height: 16),
            const Text(
              'No active party.',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              'Head to Base Camp to hire adventurers\nand form your party.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const BaseCampView(),
                ),
              ),
              icon: const Icon(Icons.cabin),
              label: const Text('Go to Base Camp'),
            ),
          ],
        ),
      );
    }

    // Key on length so TabController resets cleanly when party changes.
    return DefaultTabController(
      key: ValueKey(activeParty.length),
      length: activeParty.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: activeParty.map((a) => Tab(text: a.name)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: activeParty
                  .map((a) => AdventurerCard(adventurerId: a.id))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
