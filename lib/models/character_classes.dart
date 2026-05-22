import 'character_class.dart';

const List<CharacterClass> kAllClasses = [
  CharacterClass(
    id: 'assassin',
    name: 'Assassin',
    description:
        'A deadly operative who combines martial skill with '
        'cunning to eliminate targets swiftly and silently.',
    guilderCost: 13,
    skillNames: [
      'Reflexes',
      'Combat Arts',
      'Acrobatics',
      'Hard to Hit',
      'Disarm',
      'Trick Shot',
      'Quick Recovery',
      'Malacyte Mastery',
    ],
  ),
  CharacterClass(
    id: 'barbarian',
    name: 'Barbarian',
    description:
        'An aggressive melee fighter who sacrifices defence '
        'for overwhelming offensive power.',
    guilderCost: 7,
    skillNames: [
      'Frenzy',
      'Reflexes',
      'Brutal Assault',
      'Onslaught',
      'Impervious',
      'Combat Arts',
      'Intimidating',
    ],
  ),
  CharacterClass(
    id: 'eudaemon',
    name: 'Eudaemon',
    description:
        'Proximate Maladaar whose spells augment their own '
        'speed, strength and form.',
    guilderCost: 16,
    magicPegSlots: 12,
    skillNames: [
      'Tracking',
      'Distraction',
      'One with Nature',
      'Reflexes',
      'Fortified Mind',
      'Natural Remedies',
      'Ambush',
    ],
  ),
  CharacterClass(
    id: 'guardian',
    name: 'Guardian',
    description:
        'A stalwart defender who protects allies and absorbs '
        'punishment on the front line.',
    guilderCost: 7,
    skillNames: [
      'Onslaught',
      'Quick Recovery',
      'Steady',
      'Impervious',
      'Weapons Master',
      'Frenzy',
      'Brutal Assault',
      'Ready for Anything',
    ],
  ),
  CharacterClass(
    id: 'marksman',
    name: 'Marksman',
    description:
        'A precision ranged fighter who picks off enemies '
        'from distance with lethal accuracy.',
    guilderCost: 6,
    skillNames: [
      'Trick Shot',
      'Ranged Expert',
      'Counter Shot',
      'Bullseye',
      'Ambush',
      'Duck for Cover',
      'Fleet of Foot',
      'Reflexes',
    ],
  ),
  CharacterClass(
    id: 'prymorist',
    name: 'Prymorist',
    description:
        'Elemental Maladaar specialising in fire, barriers '
        'and environmental magic.',
    guilderCost: 16,
    magicPegSlots: 12,
    skillNames: [
      'Power Manipulation',
      'Malacyte Mastery',
      'Hard to Hit',
      'Fortified Mind',
      'Natural Remedies',
      'Counter Shot',
    ],
  ),
  CharacterClass(
    id: 'ranger',
    name: 'Ranger',
    description:
        'A wilderness hunter equally deadly at range and '
        'in close quarters.',
    guilderCost: 9,
    skillNames: [
      'Ambush',
      'Camouflage',
      'Tracking',
      'Ranged Expert',
      'Reflexes',
      'Quick Recovery',
      'One with Nature',
      'Ready for Anything',
    ],
  ),
  CharacterClass(
    id: 'rogue',
    name: 'Rogue',
    description:
        'A nimble opportunist who thrives in shadow, '
        'subterfuge and close-quarters trickery.',
    guilderCost: 5,
    skillNames: [
      'Light Fingers',
      'Reflexes',
      'Tricks of the Trade',
      'Distraction',
      'Persuasion',
      'Camouflage',
      'Duck for Cover',
      'Tracking',
    ],
  ),
  CharacterClass(
    id: 'rook',
    name: 'Rook',
    description:
        'Vicarious Maladaar who bends the minds and fates '
        'of others through illusion and control.',
    guilderCost: 16,
    magicPegSlots: 12,
    skillNames: [
      'Power Manipulation',
      'Malacyte Mastery',
      'Distraction',
      'Persuasion',
      'Barter',
      'Duck for Cover',
    ],
  ),
  CharacterClass(
    id: 'scavenger',
    name: 'Scavenger',
    description:
        'A resourceful survivor who exploits every advantage '
        'the environment and their wits can offer.',
    guilderCost: 9,
    skillNames: [
      'Acrobatics',
      'Fleet of Foot',
      'Combat Arts',
      'Tricks of the Trade',
      'Light Fingers',
      'Hard to Hit',
      'Barter',
      'Ready for Anything',
    ],
  ),
  CharacterClass(
    id: 'sellsword',
    name: 'Sellsword',
    description:
        'A versatile mercenary fighter for hire, trained '
        'across a broad range of combat disciplines.',
    guilderCost: 10,
    skillNames: [
      'Reflexes',
      'Frenzy',
      'Weapons Master',
      'Counter Shot',
      'Bullseye',
      'Training',
      'Quick Recovery',
      'Ambush',
    ],
  ),
];
