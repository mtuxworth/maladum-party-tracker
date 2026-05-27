import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/adventurer_card.dart';
import 'base_camp_view.dart';

// Each adventurer card is at least this wide.
const double _kMinCardWidth = 480.0;

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
    final activeParty = party.activeParty;

    if (activeParty.isEmpty) {
      return _EmptyQuestView();
    }

    final n = activeParty.length;
    final viewWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (viewWidth / n).clamp(_kMinCardWidth, double.infinity);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: activeParty
              .map(
                (a) => SizedBox(
                  width: cardWidth,
                  child: AdventurerCard(adventurerId: a.id),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _EmptyQuestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            'Head to Base Camp to hire adventurers and form your party.',
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
}
