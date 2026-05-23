class CharacterClass {
  final String id;
  final String name;
  final String description;
  final int guilderCost;
  // Slot count for the magic peg track; 0 means no magic track.
  final int magicPegSlots;
  // IDs of spells available to this class (empty for non-magic classes).
  final List<String> spellIds;
  // Exact skill names available to this class (matches Skill.name).
  final List<String> skillNames;

  const CharacterClass({
    required this.id,
    required this.name,
    required this.description,
    required this.guilderCost,
    this.magicPegSlots = 0,
    this.spellIds = const [],
    required this.skillNames,
  });
}
