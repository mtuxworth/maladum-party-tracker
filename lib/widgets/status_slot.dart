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
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _StatusPicker(current: effect, onSelected: onChanged),
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
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Flexible(
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: StatusEffect.values.map((e) {
                final isSelected = e == current;
                return GestureDetector(
                  onTap: () {
                    onSelected(e);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          kStatusImages[e]!,
                          width: 40,
                          height: 40,
                          filterQuality: FilterQuality.medium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _statusLabel(e),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (current != null)
            ListTile(
              leading: const Icon(Icons.clear, color: Color(0xFFC62828)),
              title: const Text('Clear'),
              onTap: () {
                onSelected(null);
                Navigator.pop(context);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
