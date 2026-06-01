import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/enums.dart';
import '../models/quest_log_entry.dart';
import '../providers/providers.dart';
import '../utils/file_io.dart';
import '../widgets/guilder_bar.dart';
import '../widgets/responsive_layout.dart';
import 'icon_reference_view.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(party.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Icon reference',
            onPressed: () => IconReferenceView.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import party',
            onPressed: () => _import(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export party',
            onPressed: () => exportPartyToFile(ref.read(partyProvider)),
          ),
          IconButton(
            icon: const Icon(Icons.nightlight_round),
            tooltip: 'End quest',
            onPressed: () => _confirmEndQuest(context, ref),
          ),
        ],
      ),
      body: const Column(
        children: [
          GuilderBar(),
          Expanded(child: ResponsiveLayout()),
        ],
      ),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final imported = await importPartyFromFile();
    if (!context.mounted) return;
    if (imported == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read party file.')),
      );
      return;
    }
    ref.read(partyProvider.notifier).importState(imported);
  }

  void _confirmEndQuest(BuildContext context, WidgetRef ref) {
    final questName =
        ref.read(partyProvider).activeQuestName ?? 'this quest';
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Quest'),
        content: Text(
          'Returning from $questName?\n'
          'You will record each adventurer\'s fate, then survivors '
          'choose +1 Health Max or +1 Skill Max.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              ref.read(partyProvider.notifier).endQuestReset();
              if (!context.mounted) return;

              final active = ref.read(partyProvider).activeParty;
              final outcomes = <String, AdventurerOutcome>{};

              // Record fate for each party member.
              for (final adventurer in active) {
                if (!context.mounted) break;
                final outcome =
                    await _showOutcomeDialog(context, adventurer);
                outcomes[adventurer.id] = outcome;
              }

              // Stat boost only for survivors.
              for (final adventurer in active) {
                if (!context.mounted) break;
                if (outcomes[adventurer.id] == AdventurerOutcome.survived) {
                  await _showStatBoostDialog(context, ref, adventurer);
                }
              }

              // Persist quest log and return to Base Camp.
              if (context.mounted) {
                ref
                    .read(partyProvider.notifier)
                    .recordQuestComplete(outcomes);
                Navigator.pop(context);
              }
            },
            child: const Text('End Quest'),
          ),
        ],
      ),
    );
  }
}

Future<AdventurerOutcome> _showOutcomeDialog(
  BuildContext context,
  Adventurer adventurer,
) async {
  return await showDialog<AdventurerOutcome>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(adventurer.name),
          content: const Text('What happened on this quest?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(ctx, AdventurerOutcome.leftBehind),
              child: const Text('Left Behind'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFC62828)),
              onPressed: () => Navigator.pop(ctx, AdventurerOutcome.died),
              child: const Text('Died'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(ctx, AdventurerOutcome.survived),
              child: const Text('Survived'),
            ),
          ],
        ),
      ) ??
      AdventurerOutcome.survived;
}

Future<void> _showStatBoostDialog(
  BuildContext context,
  WidgetRef ref,
  Adventurer adventurer,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(adventurer.name),
      content: const Text('Choose a permanent stat increase:'),
      actions: [
        TextButton(
          onPressed: () {
            ref
                .read(adventurerProvider(adventurer.id).notifier)
                .increaseStatMax(StatType.health);
            Navigator.pop(ctx);
          },
          child: const Text('+1 Health Max'),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(adventurerProvider(adventurer.id).notifier)
                .increaseStatMax(StatType.skill);
            Navigator.pop(ctx);
          },
          child: const Text('+1 Skill Max'),
        ),
      ],
    ),
  );
}
