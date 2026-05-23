import 'spell_school.dart';

class Spell {
  final String id;
  final String name;
  final SpellSchool school;

  // Minimum character level required to cast this spell (1–5).
  final int rank;

  // Full effect text including activation type prefix, e.g.
  // "[Action]: Restore X Health (max 3)."
  // Words in [square brackets] are game keywords and will receive icons later.
  // X = number of magic pegs the player chooses to spend when casting.
  final String description;

  const Spell({
    required this.id,
    required this.name,
    required this.school,
    required this.rank,
    required this.description,
  });
}
