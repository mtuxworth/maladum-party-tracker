import 'package:flutter/material.dart';

import '../models/enums.dart';

// Maps each status effect to its game icon asset path.
const Map<StatusEffect, String> kStatusImages = {
  StatusEffect.blessed:  'assets/icons/kw_blessed.png',
  StatusEffect.burning:  'assets/icons/kw_burning.png',
  StatusEffect.fatigued: 'assets/icons/kw_fatigued.png',
  StatusEffect.poisoned: 'assets/icons/kw_poisoned.png',
  StatusEffect.stunned:  'assets/icons/kw_stunned.png',
  StatusEffect.terrified:'assets/icons/kw_terrified.png',
  StatusEffect.warded:   'assets/icons/kw_warded.png',
  StatusEffect.wounded:  'assets/icons/kw_wounded.png',
};

// Display name with correct capitalisation.
String _statusLabel(StatusEffect e) => switch (e) {
      StatusEffect.blessed   => 'Blessed',
      StatusEffect.burning   => 'Burning',
      StatusEffect.fatigued  => 'Fatigued',
      StatusEffect.poisoned  => 'Poisoned',
      StatusEffect.stunned   => 'Stunned',
      StatusEffect.terrified => 'Terrified',
      StatusEffect.warded    => 'Warded',
      StatusEffect.wounded   => 'Wounded',
    };

class StatusSlot extends StatelessWidget {
  final int slotIndex;
  final StatusEffect? effect;
  final void Function(StatusEffect?) onChanged;

  const StatusSlot({
    required this.slotIndex,
    required this.effect,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: effect != null
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
          color: effect != null
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: effect != null
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  kStatusImages[effect!]!,
                  filterQuality: FilterQuality.medium,
                ),
              )
            : Icon(
                Icons.add,
                color: Colors.grey.withValues(alpha: 0.5),
                size: 22,
              ),
      ),
    );
  }

  void _openPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: _StatusPicker(current: effect, onSelected: onChanged),
        ),
      ),
    );
  }
}

class _StatusPicker extends StatelessWidget {
  final StatusEffect? current;
  final void Function(StatusEffect?) onSelected;

  const _StatusPicker({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              'Select Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...StatusEffect.values.map((e) {
                  final isSelected = e == current;
                  return InkWell(
                    onTap: () {
                      onSelected(e);
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            kStatusImages[e]!,
                            width: 28,
                            height: 28,
                            filterQuality: FilterQuality.medium,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _statusLabel(e),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.85),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              size: 18,
                              color: Color(0xFFE65100),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                if (current != null) ...[
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      onSelected(null);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.clear,
                            size: 22,
                            color: Color(0xFFC62828),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
