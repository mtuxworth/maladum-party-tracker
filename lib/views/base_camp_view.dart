import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/campaign_quests.dart';
import '../models/character_classes.dart';
import '../models/quest_log_entry.dart';
import '../models/enums.dart';
import '../models/equipment_item.dart';
import '../models/party_state.dart';
import '../models/preset_parties.dart';
import '../providers/party_notifier.dart';
import '../providers/providers.dart';
import '../widgets/renown_tracker.dart';
import '../widgets/adventurer_card.dart';
import '../utils/file_io.dart';
import 'add_adventurer_sheet.dart';
import 'add_item_sheet.dart';
import 'icon_reference_view.dart';
import 'main_scaffold.dart';
import 'market_view.dart';

class BaseCampView extends ConsumerStatefulWidget {
  const BaseCampView({super.key});

  @override
  ConsumerState<BaseCampView> createState() => _BaseCampViewState();
}

class _BaseCampViewState extends ConsumerState<BaseCampView> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: ref.read(partyProvider).notes,
    );
    // Show creation dialog on first launch before any party exists.
    if (ref.read(partyProvider).name.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showNewTeamDialog(
            context,
            ref.read(partyProvider.notifier),
            isFirstRun: true,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveNotes() {
    ref.read(partyProvider.notifier).setNotes(_notesController.text);
  }

  Future<void> _import(BuildContext context) async {
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

  void _showTeamSwitcher() {
    showDialog<void>(
      context: context,
      builder: (_) => const _TeamSwitcherDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final party = ref.watch(partyProvider);

    // Sync notes controller text when the party changes (e.g. after team switch).
    if (_notesController.text != party.notes) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notesController.text = party.notes;
      });
    }

    final isWide = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Camp'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Icon reference',
            onPressed: () => IconReferenceView.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import party',
            onPressed: () => _import(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export party',
            onPressed: () =>
                exportPartyToFile(ref.read(partyProvider)),
          ),
          IconButton(
            icon: const Icon(Icons.people_alt),
            tooltip: 'Manage teams',
            onPressed: _showTeamSwitcher,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TeamNameCard(party: party),
                const SizedBox(height: 10),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: _TreasuryCard(party: party),
                      ),
                      const SizedBox(width: 10),
                      // 50/50 on mobile, 33/66 on desktop so pegs don't wrap.
                      Flexible(
                        flex: isWide ? 2 : 1,
                        child: _RenownCard(party: party),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _NotesCard(
                  controller: _notesController,
                  onSave: _saveNotes,
                ),
                const SizedBox(height: 10),
                _RosterCard(party: party),
                const SizedBox(height: 10),
                _StorageCard(party: party),
                const SizedBox(height: 10),
                _QuestLogCard(party: party),
                const SizedBox(height: 20),
                _ActionRow(party: party, isWide: isWide),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Team name ────────────────────────────────────────────────────────────────

class _TeamNameCard extends ConsumerStatefulWidget {
  final PartyState party;
  const _TeamNameCard({required this.party});

  @override
  ConsumerState<_TeamNameCard> createState() => _TeamNameCardState();
}

class _TeamNameCardState extends ConsumerState<_TeamNameCard> {
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.party.name);
  }

  @override
  void didUpdateWidget(_TeamNameCard old) {
    super.didUpdateWidget(old);
    // Keep controller in sync when a team switch changes the party name.
    if (old.party.name != widget.party.name && !_editing) {
      _ctrl.text = widget.party.name;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _ctrl.text.trim();
    if (name.isNotEmpty && name != widget.party.name) {
      ref.read(partyProvider.notifier).renameParty(name);
    }
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Row(
        children: [
          const Icon(Icons.shield, color: Color(0xFFE65100), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: _editing
                ? TextField(
                    controller: _ctrl,
                    autofocus: true,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _save(),
                  )
                : Text(
                    widget.party.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
          ),
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit, size: 18),
            tooltip: _editing ? 'Save name' : 'Rename team',
            onPressed: () {
              if (_editing) {
                _save();
              } else {
                _ctrl.text = widget.party.name;
                setState(() => _editing = true);
              }
            },
          ),
        ],
      ),
    );
  }
}

// ── Treasury ─────────────────────────────────────────────────────────────────

class _TreasuryCard extends ConsumerWidget {
  final PartyState party;
  const _TreasuryCard({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(partyProvider.notifier);

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Treasury'),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: Color(0xFFFFB300),
                size: 18,
              ),
              const SizedBox(width: 8),
              _PegButton(
                icon: Icons.remove,
                onTap: party.guilders > 0
                    ? () => notifier.setGuilders(party.guilders - 1)
                    : null,
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _showGuilderDialog(context, ref, party.guilders),
                child: Text(
                  '${party.guilders}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFFFB300),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 6),
              _PegButton(
                icon: Icons.add,
                onTap: () => notifier.setGuilders(party.guilders + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGuilderDialog(BuildContext context, WidgetRef ref, int current) {
    final ctrl = TextEditingController(text: current == 0 ? '' : '$current');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Treasury'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Guilders',
            prefixText: 'G ',
          ),
          onSubmitted: (_) {
            ref
                .read(partyProvider.notifier)
                .setGuilders(int.tryParse(ctrl.text) ?? current);
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(partyProvider.notifier)
                  .setGuilders(int.tryParse(ctrl.text) ?? current);
              Navigator.pop(ctx);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }
}

// ── Renown ───────────────────────────────────────────────────────────────────

class _RenownCard extends ConsumerWidget {
  final PartyState party;
  const _RenownCard({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SectionLabel('Renown'),
              const Spacer(),
              Text(
                '${party.renown} / $maxRenown',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFC62828),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RenownTracker(
            value: party.renown,
            onChanged: (v) =>
                ref.read(partyProvider.notifier).setRenown(v),
          ),
        ],
      ),
    );
  }
}

// ── Storage ───────────────────────────────────────────────────────────────────

class _StorageCard extends ConsumerWidget {
  final PartyState party;
  const _StorageCard({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Storage'),
          const SizedBox(height: 10),
          Row(
            children: List.generate(maxStorageSlots, (i) {
              final item = party.storageSlots[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: i < maxStorageSlots - 1 ? 6 : 0,
                  ),
                  child: _StorageSlot(
                    item: item,
                    onTap: item != null
                        ? null
                        : () async {
                            final picked = await showAddItemSheet(
                              context,
                              forGear: false,
                            );
                            if (picked != null) {
                              ref
                                  .read(partyProvider.notifier)
                                  .updateStorageSlot(i, picked);
                            }
                          },
                    onLongPress: item != null
                        ? () => ref
                            .read(partyProvider.notifier)
                            .updateStorageSlot(i, null)
                        : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StorageSlot extends StatelessWidget {
  final EquipmentItem? item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _StorageSlot({
    required this.item,
    required this.onTap,
    required this.onLongPress,
  });

  static const Map<ItemColor, Color> _borderColors = {
    ItemColor.blue: Color(0xFF1565C0),
    ItemColor.red: Color(0xFFB71C1C),
    ItemColor.yellow: Color(0xFFF9A825),
    ItemColor.purple: Color(0xFF6A1B9A),
    ItemColor.grey: Color(0xFF546E7A),
  };

  @override
  Widget build(BuildContext context) {
    final borderColor =
        item != null ? (_borderColors[item!.color] ?? Colors.grey) : Colors.white24;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: borderColor,
              width: item != null ? 1.5 : 1,
            ),
            color: item != null
                ? borderColor.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: item != null
              ? Padding(
                  padding: const EdgeInsets.all(4),
                  child: Center(
                    child: Text(
                      item!.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: borderColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
        ),
      ),
    );
  }
}

// ── Notes ────────────────────────────────────────────────────────────────────

class _NotesCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;

  const _NotesCard({required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Notes'),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              hintText: 'Session notes, quest progress, reminders…',
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(10),
            ),
            onTapOutside: (_) => onSave(),
          ),
        ],
      ),
    );
  }
}

// ── Roster ────────────────────────────────────────────────────────────────────

class _RosterCard extends ConsumerWidget {
  final PartyState party;
  const _RosterCard({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SectionLabel('Roster'),
              const Spacer(),
              TextButton.icon(
                onPressed: () => showAddAdventurerSheet(context),
                icon: const Icon(Icons.person_add, size: 16),
                label: const Text('Hire'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFE65100),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          if (party.adventurers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No adventurers hired yet.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white38,
                      ),
                ),
              ),
            )
          else ...[
            const SizedBox(height: 8),
            ...party.adventurers.map(
              (a) => _RosterTile(
                adventurer: a,
                isActive: party.activePartyIds.contains(a.id),
                onRemove: () =>
                    ref.read(partyProvider.notifier).removeAdventurer(a.id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RosterTile extends StatelessWidget {
  final Adventurer adventurer;
  final bool isActive;
  final VoidCallback onRemove;

  const _RosterTile({
    required this.adventurer,
    required this.isActive,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cls = kAllClasses
        .where((c) => c.id == adventurer.characterClass)
        .firstOrNull;
    final className = cls?.name ?? adventurer.characterClass;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => _openCard(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Icon(
                isActive ? Icons.shield : Icons.shield_outlined,
                size: 16,
                color: isActive ? const Color(0xFFE65100) : Colors.white38,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adventurer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '$className · Rank ${adventurer.currentRank + 1}'
                      '  ·  '
                      'H ${adventurer.health.current}/${adventurer.health.potential}'
                      '  M ${adventurer.magic.current}/${adventurer.magic.potential}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFFE65100).withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                tooltip: 'Remove from roster',
                color: Colors.white38,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => _confirmRemove(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCard(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: MediaQuery.of(ctx).size.height * 0.88,
          ),
          child: AdventurerCard(adventurerId: adventurer.id),
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${adventurer.name}?'),
        content: const Text(
          'This will permanently remove the adventurer from your roster.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRemove();
            },
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFFC62828)),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

// ── Quest Log card ────────────────────────────────────────────────────────────

class _QuestLogCard extends StatelessWidget {
  final PartyState party;
  const _QuestLogCard({required this.party});

  @override
  Widget build(BuildContext context) {
    final entries = party.questLog.reversed.toList();
    final strandedCount = party.leftBehindIds.length;

    // Campaign quests run at least once (derived from log).
    final doneCampaignIds = party.questLog
        .where((e) => e.campaignQuestId != null)
        .map((e) => e.campaignQuestId!)
        .toSet();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: EdgeInsets.zero,
        shape: const Border(),
        collapsedShape: const Border(),
        leading: const Icon(
          Icons.menu_book_outlined,
          color: Color(0xFFE65100),
          size: 18,
        ),
        title: Text(
          'QUEST LOG',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFFE65100),
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: strandedCount > 0
            ? Text(
                '⚠ $strandedCount stranded',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFC62828),
                ),
              )
            : null,
        trailing: Text(
          '${entries.length}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: entries.isEmpty
                    ? Colors.white38
                    : const Color(0xFFE65100),
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          const Divider(height: 1),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No quests recorded yet.\nStart a quest to begin tracking.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white38),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 14, endIndent: 14),
              itemBuilder: (ctx, i) =>
                  _QuestLogEntryTile(entry: entries[i]),
            ),
          // Campaign progress footer.
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF3A3A3A)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.map_outlined,
                    size: 14, color: Colors.white38),
                const SizedBox(width: 8),
                Text(
                  'Campaign: ${doneCampaignIds.length} / '
                  '${kCampaignQuests.length} quests played',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestLogEntryTile extends StatelessWidget {
  final QuestLogEntry entry;
  const _QuestLogEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final partyNames = entry.party.map((p) => p.name).join(', ');
    final hasLeft = entry.leftBehind.isNotEmpty;
    final hasDied = entry.died.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (entry.isRescueMission) ...[
                const Icon(Icons.shield,
                    size: 13, color: Color(0xFF1565C0)),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  entry.questName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _fmtDate(entry.timestamp),
                style: const TextStyle(
                    fontSize: 11, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            partyNames,
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
          if (hasLeft || hasDied) ...[
            const SizedBox(height: 5),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (hasLeft)
                  _OutcomeBadge(
                    label:
                        'Left behind: ${entry.leftBehind.map((p) => p.name).join(', ')}',
                    color: const Color(0xFFF9A825),
                  ),
                if (hasDied)
                  _OutcomeBadge(
                    label:
                        'Died: ${entry.died.map((p) => p.name).join(', ')}',
                    color: const Color(0xFFC62828),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year % 100}';
}

class _OutcomeBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _OutcomeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _ActionRow extends ConsumerWidget {
  final PartyState party;
  final bool isWide;
  const _ActionRow({required this.party, required this.isWide});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restBtn = OutlinedButton.icon(
      onPressed: () => _showRestDialog(context, ref, party),
      icon: const Icon(Icons.hotel, size: 18),
      label: const Text('Rest'),
    );
    final marketBtn = OutlinedButton.icon(
      onPressed: () => showMarketDialog(context),
      icon: const Icon(Icons.storefront, size: 18),
      label: const Text('Market'),
    );
    final questBtn = FilledButton(
      onPressed: party.adventurers.isEmpty
          ? null
          : () => _showFormPartyDialog(context, ref, party),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⚔', style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Text('Start Quest'),
        ],
      ),
    );

    if (isWide) {
      // Desktop: all three buttons in one row.
      return Row(
        children: [
          Expanded(child: restBtn),
          const SizedBox(width: 12),
          Expanded(child: marketBtn),
          const SizedBox(width: 12),
          Expanded(child: questBtn),
        ],
      );
    }

    // Mobile: Rest + Market on top row, Start Quest full-width below.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: restBtn),
            const SizedBox(width: 12),
            Expanded(child: marketBtn),
          ],
        ),
        const SizedBox(height: 10),
        questBtn,
      ],
    );
  }

  void _showRestDialog(
    BuildContext context,
    WidgetRef ref,
    PartyState party,
  ) {
    final innCost = party.adventurers.length * 2;
    final canAffordInn = party.guilders >= innCost;

    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rest', style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  'Clears all status effects and resets Action Points '
                  'for the whole roster.',
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: Colors.white54,
                      ),
                ),
                const SizedBox(height: 20),
                _RestOption(
                  icon: Icons.hotel,
                  title: 'Rest at Inn',
                  subtitle:
                      '$innCost Guilders (2 × ${party.adventurers.length} '
                      'adventurer${party.adventurers.length == 1 ? '' : 's'})',
                  enabled: canAffordInn,
                  disabledReason: canAffordInn
                      ? null
                      : 'Not enough Guilders (have ${party.guilders})',
                  onTap: () {
                    Navigator.pop(ctx);
                    ref.read(partyProvider.notifier).restInn();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Rested at Inn — $innCost Guilders spent.'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _RestOption(
                  icon: Icons.forest,
                  title: 'Rest in Wilderness',
                  subtitle: 'Free',
                  enabled: true,
                  onTap: () {
                    Navigator.pop(ctx);
                    ref.read(partyProvider.notifier).restWilderness();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rested in the wilderness.'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFormPartyDialog(
    BuildContext context,
    WidgetRef ref,
    PartyState party,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _FormPartyDialog(
        party: party,
        // After confirming, push the quest view from the Base Camp context.
        onConfirmed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const MainScaffold()),
        ),
      ),
    );
  }
}

class _RestOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final String? disabledReason;
  final VoidCallback? onTap;

  const _RestOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.disabledReason,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.06),
          ),
          color: enabled
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: enabled ? Colors.white70 : Colors.white24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: enabled ? Colors.white : Colors.white38,
                    ),
                  ),
                  Text(
                    disabledReason ?? subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: enabled
                          ? Colors.white54
                          : const Color(0xFFC62828).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form Party dialog ─────────────────────────────────────────────────────────

const String _kQuestCustom = '_custom';
const String _kQuestRescue = '_rescue';

class _FormPartyDialog extends ConsumerStatefulWidget {
  final PartyState party;
  final VoidCallback onConfirmed;

  const _FormPartyDialog({
    required this.party,
    required this.onConfirmed,
  });

  @override
  ConsumerState<_FormPartyDialog> createState() => _FormPartyDialogState();
}

class _FormPartyDialogState extends ConsumerState<_FormPartyDialog> {
  late Set<String> _selected;
  String? _questPickerValue;
  final _customNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.party.activePartyIds);
  }

  @override
  void dispose() {
    _customNameCtrl.dispose();
    super.dispose();
  }

  bool get _hasStranded => widget.party.leftBehindIds.isNotEmpty;

  // Resolved display name for the chosen quest, null if incomplete.
  String? get _resolvedQuestName {
    if (_questPickerValue == null) return null;
    if (_questPickerValue == _kQuestRescue) return 'Rescue Mission';
    if (_questPickerValue == _kQuestCustom) {
      final n = _customNameCtrl.text.trim();
      return n.isEmpty ? null : n;
    }
    final q =
        kCampaignQuests.firstWhere((q) => q.id == _questPickerValue);
    return q.name.isNotEmpty ? '${q.label} – ${q.name}' : q.label;
  }

  String? get _resolvedCampaignQuestId =>
      (_questPickerValue == null ||
              _questPickerValue == _kQuestCustom ||
              _questPickerValue == _kQuestRescue)
          ? null
          : _questPickerValue;

  bool get _canSubmit =>
      _selected.isNotEmpty && _resolvedQuestName != null;

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < maxPartySize) {
        _selected.add(id);
      }
    });
  }

  void _confirm() {
    if (!_canSubmit) return;
    ref.read(partyProvider.notifier).startQuest(
          questName: _resolvedQuestName!,
          campaignQuestId: _resolvedCampaignQuestId,
          isRescueMission: _questPickerValue == _kQuestRescue,
          partyIds: _selected.toList(),
        );
    Navigator.pop(context);
    widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final roster = widget.party.adventurers;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Form Party',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    '${_selected.length} / $maxPartySize',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _selected.length == maxPartySize
                          ? const Color(0xFFE65100)
                          : Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Quest selection ────────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 14, 16, 4),
                      child: _SectionLabel('Quest'),
                    ),
                    if (_hasStranded)
                      _StrandedBanner(
                        leftBehindIds: widget.party.leftBehindIds,
                        adventurers: roster,
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        initialValue: _questPickerValue,
                        isExpanded: true,
                        hint: const Text('Select quest…'),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        items: [
                          if (_hasStranded)
                            const DropdownMenuItem(
                              value: _kQuestRescue,
                              child: Text('🏃 Rescue Mission'),
                            ),
                          ...kCampaignQuests.map(
                            (q) => DropdownMenuItem(
                              value: q.id,
                              child: Text(
                                q.name.isNotEmpty
                                    ? '${q.label} – ${q.name}'
                                    : q.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const DropdownMenuItem(
                            value: _kQuestCustom,
                            child: Text('Custom Mission…'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _questPickerValue = v),
                      ),
                    ),
                    if (_questPickerValue == _kQuestCustom)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: TextField(
                          controller: _customNameCtrl,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Mission name',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    // ── Party selection ────────────────────────────────
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: _SectionLabel('Party'),
                    ),
                    ...roster.map((a) {
                      final checked = _selected.contains(a.id);
                      final isStranded =
                          widget.party.leftBehindIds.contains(a.id);
                      final canSelect =
                          checked || _selected.length < maxPartySize;
                      final cls = kAllClasses
                          .where((c) => c.id == a.characterClass)
                          .firstOrNull;
                      return InkWell(
                        onTap: canSelect ? () => _toggle(a.id) : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                checked
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 20,
                                color: checked
                                    ? const Color(0xFFE65100)
                                    : canSelect
                                        ? Colors.white54
                                        : Colors.white24,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          a.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: canSelect
                                                ? Colors.white
                                                : Colors.white38,
                                          ),
                                        ),
                                        if (isStranded) ...[
                                          const SizedBox(width: 6),
                                          const _StrandedChip(),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      '${cls?.name ?? a.characterClass}'
                                      ' · Rank ${a.currentRank + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: canSelect
                                            ? Colors.white54
                                            : Colors.white24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _canSubmit ? _confirm : null,
                    child: const Text('Start Quest'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrandedBanner extends StatelessWidget {
  final List<String> leftBehindIds;
  final List<Adventurer> adventurers;
  const _StrandedBanner({
    required this.leftBehindIds,
    required this.adventurers,
  });

  @override
  Widget build(BuildContext context) {
    final names = adventurers
        .where((a) => leftBehindIds.contains(a.id))
        .map((a) => a.name)
        .join(', ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFC62828).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFC62828).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber,
                size: 15, color: Color(0xFFC62828)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Stranded: $names',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFC62828),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrandedChip extends StatelessWidget {
  const _StrandedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFC62828).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Stranded',
        style: TextStyle(fontSize: 9, color: Color(0xFFC62828)),
      ),
    );
  }
}

// ── Team switcher dialog ──────────────────────────────────────────────────────

class _TeamSwitcherDialog extends ConsumerWidget {
  const _TeamSwitcherDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);
    final notifier = ref.read(partyProvider.notifier);
    final saved = notifier.listSavedParties();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Text(
                'Teams',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: saved.map((name) {
                  final isActive = name == party.name;
                  return ListTile(
                    leading: Icon(
                      isActive ? Icons.shield : Icons.shield_outlined,
                      color: isActive
                          ? const Color(0xFFE65100)
                          : Colors.white54,
                      size: 20,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isActive
                            ? const Color(0xFFE65100)
                            : Colors.white,
                      ),
                    ),
                    trailing: isActive
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFFE65100),
                            size: 18,
                          )
                        : null,
                    onTap: isActive
                        ? null
                        : () {
                            notifier.switchToParty(name);
                            Navigator.pop(context);
                          },
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.add, color: Color(0xFFE65100)),
              title: const Text(
                'New Team',
                style: TextStyle(color: Color(0xFFE65100)),
              ),
              onTap: () {
                // Capture notifier before this widget is disposed by the pop.
                final notifier = ref.read(partyProvider.notifier);
                Navigator.pop(context);
                showNewTeamDialog(context, notifier);
              },
            ),
          ],
        ),
      ),
    );
  }

}

// Shared helper — called from first-run (isFirstRun: true) and team-switcher.
void showNewTeamDialog(
  BuildContext context,
  PartyNotifier notifier, {
  bool isFirstRun = false,
}) {
  final ctrl = TextEditingController();

  void submit(BuildContext ctx, {required bool usePreset}) {
    final name = ctrl.text.trim();
    if (name.isEmpty) return;
    if (usePreset) {
      notifier.createPresetParty(
        name,
        buildRecommendedParty(),
        cost: recommendedPartyCost(),
      );
    } else {
      notifier.createNewParty(name);
    }
    Navigator.pop(ctx);
  }

  showDialog<void>(
    context: context,
    // Prevent dismissal on first launch — a party name is required.
    barrierDismissible: !isFirstRun,
    builder: (ctx) => AlertDialog(
      title: const Text('New Team'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Team name'),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => submit(ctx, usePreset: false),
          ),
          const SizedBox(height: 12),
          Text(
            'Start with the recommended party, or build your own.',
            style: Theme.of(ctx).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Recommended: Callan (Sellsword) · Greet (Rogue) · '
            'Moranna (Prymorist) · Syrio (Ranger)',
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFE65100),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'All new teams start with 350 Guilders.',
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFFFB300),
                ),
          ),
        ],
      ),
      actions: [
        if (!isFirstRun)
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        TextButton(
          onPressed: () => submit(ctx, usePreset: false),
          child: const Text('Start Fresh'),
        ),
        FilledButton(
          onPressed: () => submit(ctx, usePreset: true),
          child: const Text('Recommended'),
        ),
      ],
    ),
  );
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: const Color(0xFFE65100),
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _PegButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _PegButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? Colors.white70 : Colors.white24,
        ),
      ),
    );
  }
}
