import 'package:flutter/material.dart';

import '../models/enums.dart';

const Map<StatusEffect, Color> kStatusColors = {
  StatusEffect.poison: Color(0xFF4CAF50),
  StatusEffect.bless: Color(0xFFFFD700),
  StatusEffect.stun: Color(0xFFFFEB3B),
  StatusEffect.curse: Color(0xFF9C27B0),
  StatusEffect.burn: Color(0xFFFF5722),
  StatusEffect.slow: Color(0xFF2196F3),
  StatusEffect.shield: Color(0xFF9E9E9E),
  StatusEffect.haste: Color(0xFF00BCD4),
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
    final color = effect != null ? kStatusColors[effect!] : null;

    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color ?? Colors.grey.withValues(alpha: 0.4),
            width: 2,
          ),
          color: color?.withValues(alpha: 0.15),
        ),
        child: effect != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    effect!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : Icon(
                Icons.add,
                color: Colors.grey.withValues(alpha: 0.6),
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
          ...StatusEffect.values.map(
            (e) => ListTile(
              leading: CircleAvatar(
                radius: 10,
                backgroundColor: kStatusColors[e],
              ),
              title: Text(e.name),
              selected: e == current,
              onTap: () {
                onSelected(e);
                Navigator.pop(context);
              },
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
