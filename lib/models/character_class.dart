class CharacterClass {
  final String id;
  final String name;
  final String description;
  final int guilderCost;
  // Slot count for the magic peg track; 0 means no magic track.
  final int magicPegSlots;
  // Exact skill names available to this class (matches Skill.name).
  final List<String> skillNames;

  const CharacterClass({
    required this.id,
    required this.name,
    required this.description,
    required this.guilderCost,
    this.magicPegSlots = 0,
    required this.skillNames,
  });
}
