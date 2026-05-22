import 'package:flutter/material.dart';

import '../models/enums.dart';
import 'stat_counter.dart';

class StatGrid extends StatelessWidget {
  final String adventurerId;

  const StatGrid({required this.adventurerId, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.spaceEvenly,
        runSpacing: 8,
        children: [
          StatCounter(
            adventurerId: adventurerId,
            statType: StatType.health,
            label: 'Health',
          ),
          StatCounter(
            adventurerId: adventurerId,
            statType: StatType.magic,
            label: 'Magic',
          ),
          StatCounter(
            adventurerId: adventurerId,
            statType: StatType.skill,
            label: 'Skill',
          ),
        ],
      ),
    );
  }
}
