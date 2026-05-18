import 'character_class.dart';

// PLACEHOLDER NOTE: Prymorist and Rogue are confirmed from the rulebook.
// Eudaemon and Rook are confirmed from Battle Systems blog.
// Warrior, Ranger and Berserker are placeholders — skill category mappings
// should be corrected from the physical class boards.
const List<CharacterClass> kAllClasses = [
  CharacterClass(
    id: 'prymorist',
    name: 'Prymorist',
    description:
        'Elemental Maladaar specialising in fire, barriers '
        'and environmental magic.',
    skillCategories: ['Magic', 'Endurance', 'Support'],
  ),
  CharacterClass(
    id: 'eudaemon',
    name: 'Eudaemon',
    description:
        'Proximate Maladaar whose spells augment their own '
        'speed, strength and form.',
    skillCategories: ['Magic', 'Agility', 'Survival'],
  ),
  CharacterClass(
    id: 'rook',
    name: 'Rook',
    description:
        'Vicarious Maladaar who bends the minds and fates '
        'of others through illusion and control.',
    skillCategories: ['Magic', 'Cunning', 'Support'],
  ),
  CharacterClass(
    id: 'rogue',
    name: 'Rogue',
    description:
        'A nimble opportunist who thrives in shadow, '
        'subterfuge and close-quarters trickery.',
    skillCategories: ['Cunning', 'Stealth', 'Agility'],
  ),
  CharacterClass(
    id: 'warrior',
    name: 'Warrior',
    description:
        'A stalwart frontline fighter built for sustained '
        'melee combat and enduring punishment.',
    skillCategories: ['Melee', 'Endurance', 'Support'],
  ),
  CharacterClass(
    id: 'ranger',
    name: 'Ranger',
    description:
        'A wilderness hunter equally deadly at range and '
        'in close quarters.',
    skillCategories: ['Ranged', 'Survival', 'Stealth'],
  ),
  CharacterClass(
    id: 'berserker',
    name: 'Berserker',
    description:
        'An aggressive melee fighter who sacrifices defence '
        'for overwhelming offensive power.',
    skillCategories: ['Melee', 'Agility', 'Endurance'],
  ),
];
