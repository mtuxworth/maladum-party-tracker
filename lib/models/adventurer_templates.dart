import 'adventurer_template.dart';

// PLACEHOLDER NOTE: Stats marked with * are confirmed from the rulebook.
// All others are placeholders to be corrected from the physical boards.
const List<AdventurerTemplate> kAllTemplates = [
  AdventurerTemplate(
    id: 'ailah',
    name: 'Ailah',
    species: 'Human',
    healthStart: 5,
    healthPotential: 8,
    magicStart: 1,
    magicPotential: 3,
    skillStart: 2,
    skillPotential: 4,
    actionStart: 2,
    actionPotential: 3,
    rankXpCosts: [3, 4, 4, 5, 5],
    guilderCost: 50,
  ),
  AdventurerTemplate(
    id: 'greet',
    name: 'Greet',
    species: 'Grobbler',
    healthStart: 4,
    healthPotential: 7,
    magicStart: 1,
    magicPotential: 2,
    skillStart: 2,
    skillPotential: 5,
    actionStart: 2,
    actionPotential: 3,
    rankXpCosts: [3, 4, 4, 5, 5],
    guilderCost: 50,
  ),
  AdventurerTemplate(
    id: 'grogmar',
    name: 'Grogmar',
    species: 'Ormen',
    healthStart: 6,
    healthPotential: 9,
    magicStart: 1,
    magicPotential: 2,
    skillStart: 2,
    skillPotential: 4,
    actionStart: 2,
    actionPotential: 3,
    rankXpCosts: [4, 4, 5, 5, 5],
    guilderCost: 60,
  ),
  AdventurerTemplate(
    id: 'moranna',
    name: 'Moranna',
    species: 'Human',
    healthStart: 2,
    healthPotential: 4,
    magicStart: 2, // * "couple of Magic pegs"
    magicPotential: 7, // * "able to level this up to seven"
    skillStart: 1,
    skillPotential: 3,
    actionStart: 2,
    actionPotential: 3,
    rankXpCosts: [3, 4, 4, 5, 5],
    guilderCost: 50,
  ),
  AdventurerTemplate(
    id: 'nerinda',
    name: 'Nerinda',
    species: 'Human',
    healthStart: 4,
    healthPotential: 6,
    magicStart: 1,
    magicPotential: 3,
    skillStart: 3,
    skillPotential: 5,
    actionStart: 2,
    actionPotential: 3,
    rankXpCosts: [3, 4, 4, 5, 5],
    guilderCost: 55,
  ),
  AdventurerTemplate(
    id: 'syrio',
    name: 'Syrio',
    species: 'Eld',
    healthStart: 4, // *
    healthPotential: 6, // *
    magicStart: 1, // *
    magicPotential: 4, // *
    skillStart: 1, // *
    skillPotential: 4, // *
    actionStart: 2, // *
    actionPotential: 3,
    rankXpCosts: [3, 4, 4, 5, 5],
    guilderCost: 50,
  ),
];
