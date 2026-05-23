import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/preset_parties.dart';
import '../providers/providers.dart';

class PartyDrawer extends ConsumerWidget {
  const PartyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);
    final saved = ref.read(partyProvider.notifier).listSavedParties();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerHeader(partyName: party.name),
            const Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: saved.map((name) {
                  final isActive = name == party.name;
                  return ListTile(
                    leading: Icon(
                      Icons.shield,
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(name),
                    selected: isActive,
                    onTap: isActive
                        ? null
                        : () {
                            ref
                                .read(partyProvider.notifier)
                                .switchToParty(name);
                            Navigator.pop(context);
                          },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New Party'),
              onTap: () => _showNewPartyDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewPartyDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    void submit(BuildContext ctx, {required bool usePreset}) {
      final name = controller.text.trim();
      if (name.isEmpty) return;
      if (usePreset) {
        ref
            .read(partyProvider.notifier)
            .createPresetParty(name, buildRecommendedParty());
      } else {
        ref.read(partyProvider.notifier).createNewParty(name);
      }
      Navigator.pop(ctx);
      Navigator.pop(context);
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Party'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Party name'),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (_) => submit(ctx, usePreset: false),
            ),
            const SizedBox(height: 12),
            Text(
              'Start with the rulebook\'s recommended party, or build your '
              'own from scratch.',
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
          ],
        ),
        actions: [
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
}

class _DrawerHeader extends ConsumerStatefulWidget {
  final String partyName;

  const _DrawerHeader({required this.partyName});

  @override
  ConsumerState<_DrawerHeader> createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends ConsumerState<_DrawerHeader> {
  late final TextEditingController _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.partyName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isNotEmpty && name != widget.partyName) {
      ref.read(partyProvider.notifier).renameParty(name);
    }
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _editing
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration:
                        const InputDecoration(labelText: 'Party name'),
                    onSubmitted: (_) => _save(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  tooltip: 'Save party name',
                  onPressed: _save,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    widget.partyName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Rename party',
                  onPressed: () {
                    _controller.text = widget.partyName;
                    setState(() => _editing = true);
                  },
                ),
              ],
            ),
    );
  }
}
