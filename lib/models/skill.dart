class Skill {
  final String id;
  final String name;
  final int tier;
  final String characterClass;
  final String description;

  // Tier-2 skills require their prerequisite tier-1 skill to be owned first.
  final String? prerequisiteId;

  const Skill({
    required this.id,
    required this.name,
    required this.tier,
    required this.characterClass,
    required this.description,
    this.prerequisiteId,
  });
}
