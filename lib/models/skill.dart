class Skill {
  final String id;
  final String name;
  final int tier;
  // Skill category name, matching CharacterClass.skillCategories entries.
  final String category;
  final String description;

  // Higher-tier skills require the previous tier to be owned first.
  final String? prerequisiteId;

  const Skill({
    required this.id,
    required this.name,
    required this.tier,
    required this.category,
    required this.description,
    this.prerequisiteId,
  });
}
