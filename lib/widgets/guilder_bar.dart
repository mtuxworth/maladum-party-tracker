import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/character_classes.dart';
import '../models/adventurer_templates.dart';
import '../models/equipment_item.dart';
import '../providers/providers.dart';

class GuilderBar extends ConsumerWidget {
  const GuilderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final party = ref.watch(partyProvider);
    final notifier = ref.read(partyProvider.notifier);
    final worth = _partyWorth(party.adventurers);

    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.55),
        );
    final valueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
    const accent = Color(0xFFFFB300);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: accent, size: 18),
          const SizedBox(width: 6),
          Text('Guilders', style: labelStyle),
          const SizedBox(width: 10),
          _AdjustButton(
            icon: Icons.remove,
            onTap: () => notifier.setGuilders(party.guilders - 1),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showEditDialog(context, ref, party.guilders),
            child: Text(
              '${party.guilders}',
              style: valueStyle?.copyWith(color: accent),
            ),
          ),
          const SizedBox(width: 4),
          _AdjustButton(
            icon: Icons.add,
            onTap: () => notifier.setGuilders(party.guilders + 1),
          ),
          const SizedBox(width: 20),
          Container(
            width: 1,
            height: 20,
            color: Theme.of(context).dividerColor,
          ),
          const SizedBox(width: 20),
          const Icon(Icons.balance, size: 18, color: Colors.white54),
          const SizedBox(width: 6),
          Text('Party Worth', style: labelStyle),
          const SizedBox(width: 8),
          Text(
            'G${worth.total}${worth.hasSpecial ? '+' : ''}',
            style: valueStyle,
          ),
          if (worth.hasSpecial) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: 'Some items have non-numeric prices (e.g. 4D6)',
              child: Icon(
                Icons.info_outline,
                size: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, int current) {
    final controller =
        TextEditingController(text: current == 0 ? '' : '$current');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Guilders'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: 'G ',
          ),
          onSubmitted: (_) => _commit(ctx, ref, controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _commit(ctx, ref, controller),
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _commit(
    BuildContext ctx,
    WidgetRef ref,
    TextEditingController controller,
  ) {
    final value = int.tryParse(controller.text) ?? 0;
    ref.read(partyProvider.notifier).setGuilders(value);
    Navigator.pop(ctx);
  }
}

class _AdjustButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AdjustButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

// ─── Party worth calculation ─────────────────────────────────────────────────

({int total, bool hasSpecial}) _partyWorth(List<Adventurer> adventurers) {
  int total = 0;
  bool hasSpecial = false;

  for (final a in adventurers) {
    // Adventurer template cost.
    final tmpl =
        kAllTemplates.where((t) => t.id == a.templateId).firstOrNull;
    if (tmpl != null) total += tmpl.guilderCost;

    // Class cost.
    final cls =
        kAllClasses.where((c) => c.id == a.characterClass).firstOrNull;
    if (cls != null) total += cls.guilderCost;

    // Item costs — unique items across gear and pack.
    final seen = <String>{};
    final allItems = [
      ...a.gearSlots.whereType<EquipmentItem>(),
      ...a.packSlots.whereType<EquipmentItem>(),
    ];
    for (final item in allItems) {
      if (!seen.add(item.id)) continue;
      final price = item.buyPrice;
      if (price == null) continue;
      final parsed = int.tryParse(price);
      if (parsed != null) {
        total += parsed;
      } else {
        // Non-numeric price (e.g. "4D6", "X").
        hasSpecial = true;
      }
    }
  }

  return (total: total, hasSpecial: hasSpecial);
}
