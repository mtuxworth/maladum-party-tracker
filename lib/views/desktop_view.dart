import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/party_state.dart';
import '../providers/providers.dart';
import '../widgets/adventurer_card.dart';
import 'add_adventurer_sheet.dart';

// Each adventurer card is at least this wide. The add-slot is narrower and
// excluded from the adventurer card width calculation so it does not steal
// space from character sheets.
const double _kMinCardWidth = 480.0;
const double _kAddSlotWidth = 200.0;

class DesktopView extends ConsumerStatefulWidget {
  const DesktopView({super.key});

  @override
  ConsumerState<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends ConsumerState<DesktopView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final party = ref.watch(partyProvider);
    final canAdd = party.adventurers.length < maxPartySize;

    final n = party.adventurers.length;
    final viewWidth = MediaQuery.of(context).size.width;
    final addWidth = canAdd ? _kAddSlotWidth : 0.0;

    // Adventurer cards expand to fill available space (excluding the add slot)
    // but never shrink below the minimum.
    final cardWidth = n == 0
        ? viewWidth - addWidth
        : ((viewWidth - addWidth) / n).clamp(_kMinCardWidth, double.infinity);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
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
              SizedBox(width: _kAddSlotWidth, child: _AddAdventurerSlot()),
          ],
        ),
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
