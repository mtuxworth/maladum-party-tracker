import 'package:flutter/material.dart';

enum SpellSchool {
  proximate,
  vicarious,
  elemental;

  String get label => switch (this) {
        SpellSchool.proximate => 'Proximate',
        SpellSchool.vicarious => 'Vicarious',
        SpellSchool.elemental => 'Elemental',
      };

  // Card background colour — dark enough to read white text on.
  Color get backgroundColor => switch (this) {
        SpellSchool.proximate => const Color(0xFF1A4A8C),
        SpellSchool.vicarious => const Color(0xFF4A1E8C),
        SpellSchool.elemental => const Color(0xFF1A5C38),
      };

  // Accent colour used for borders, badges, and highlights.
  Color get accentColor => switch (this) {
        SpellSchool.proximate => const Color(0xFF1976D2),
        SpellSchool.vicarious => const Color(0xFF8E24AA),
        SpellSchool.elemental => const Color(0xFF388E3C),
      };

  IconData get icon => switch (this) {
        SpellSchool.proximate => Icons.person,
        SpellSchool.vicarious => Icons.psychology,
        SpellSchool.elemental => Icons.whatshot,
      };
}
