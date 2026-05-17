import 'package:flutter/material.dart';

class APCircle extends StatelessWidget {
  final bool isSpent;
  final VoidCallback onTap;

  const APCircle({required this.isSpent, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isSpent ? 0.3 : 1.0,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primary, width: 2),
            color: isSpent ? Colors.transparent : primary.withValues(alpha: 0.25),
          ),
          child: const Icon(Icons.bolt, size: 22),
        ),
      ),
    );
  }
}
