class AdventurerTemplate {
  final String id;
  final String name;
  final String species;
  final int healthStart;
  final int healthPotential;
  final int magicStart;
  final int magicPotential;
  final int skillStart;
  final int skillPotential;
  final int actionStart;
  final int actionPotential;
  // XP cost to complete each rank row, in order (up to 5 ranks).
  final List<int> rankXpCosts;
  final int guilderCost;
  final int startingXp;

  const AdventurerTemplate({
    required this.id,
    required this.name,
    required this.species,
    required this.healthStart,
    required this.healthPotential,
    required this.magicStart,
    required this.magicPotential,
    required this.skillStart,
    required this.skillPotential,
    required this.actionStart,
    required this.actionPotential,
    required this.rankXpCosts,
    required this.guilderCost,
    this.startingXp = 0,
  });
}
