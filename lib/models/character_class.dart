class CharacterClass {
  final String id;
  final String name;
  final String description;
  // Names of skill categories this class has access to,
  // matching Skill.category values in skill_data.dart.
  final List<String> skillCategories;

  const CharacterClass({
    required this.id,
    required this.name,
    required this.description,
    required this.skillCategories,
  });
}
