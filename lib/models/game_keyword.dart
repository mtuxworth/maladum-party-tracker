enum KeywordCategory {
  activation,
  status,
  combat,
  damageType,
  ability,
}

class GameKeyword {
  final String keyword;
  // Asset path for the real game icon (e.g. 'assets/icons/kw_blast.png').
  final String imagePath;
  final KeywordCategory category;
  final String description;

  const GameKeyword({
    required this.keyword,
    required this.imagePath,
    required this.category,
    required this.description,
  });
}

const List<GameKeyword> kAllKeywords = [
  // ── ACTIVATION TYPES ─────────────────────────────────────────────────────

  GameKeyword(
    keyword: 'Action',
    imagePath: 'assets/icons/kw_action.png',
    category: KeywordCategory.activation,
    description:
        'A standard action. Uses one of the character\'s available '
        'actions for the turn.',
  ),
  GameKeyword(
    keyword: 'Effortless',
    imagePath: 'assets/icons/kw_effortless.png',
    category: KeywordCategory.activation,
    description:
        'This ability can be used as an effortless action — free, '
        'does not count as one of the character\'s actions. One '
        'effortless action can be taken per turn in addition to '
        'normal actions.',
  ),

  // ── STATUS EFFECTS ────────────────────────────────────────────────────────

  GameKeyword(
    keyword: 'Blessed',
    imagePath: 'assets/icons/kw_blessed.png',
    category: KeywordCategory.status,
    description:
        'A blessed character may remove a blessed counter to '
        're-roll any die used for any action or effect on their '
        'behalf, or force a re-roll from any attack or effect '
        'targeting them.',
  ),
  GameKeyword(
    keyword: 'Burning',
    imagePath: 'assets/icons/kw_burning.png',
    category: KeywordCategory.status,
    description:
        'In each assessment phase, this character loses 1 Health. '
        'While burning, they are a source of fire, all their '
        'attacks have the fire rule, and they cannot rest. '
        'Spend 2 consecutive actions to remove a burning counter.',
  ),
  GameKeyword(
    keyword: 'Fatigued',
    imagePath: 'assets/icons/kw_fatigued.png',
    category: KeywordCategory.status,
    description:
        'A character can have any number of fatigued counters. '
        'When fatigued counters equal or exceed their actions, '
        'the character is stunned.',
  ),
  GameKeyword(
    keyword: 'Poisoned',
    imagePath: 'assets/icons/kw_poisoned.png',
    category: KeywordCategory.status,
    description:
        'In each assessment phase, roll the magic die. On 1–2 '
        'the character loses 1 Health. On 3–4 they lose 1 Skill '
        'peg (or Health if no skill pegs remain). On 5 they are '
        'fatigued. On 6 remove the counter.',
  ),
  GameKeyword(
    keyword: 'Stunned',
    imagePath: 'assets/icons/kw_stunned.png',
    category: KeywordCategory.status,
    description:
        'A stunned character cannot take actions, use skills, '
        'spend magic pegs, or voluntarily do anything, and will '
        'miss their next turn. On their turn, instead remove the '
        'stunned counter and mark them as activated.',
  ),
  GameKeyword(
    keyword: 'Terrified',
    imagePath: 'assets/icons/kw_terrified.png',
    category: KeywordCategory.status,
    description:
        'When a terrified character takes their turn, they spend '
        'all available actions moving as far as possible from '
        'enemies. They will not engage enemies but will run '
        'through hazards.',
  ),
  GameKeyword(
    keyword: 'Warded',
    imagePath: 'assets/icons/kw_warded.png',
    category: KeywordCategory.status,
    description:
        'The warded counter\'s value is its magical armour '
        '(forcefield), maintained in the assessment phase. '
        'If an unwarded character must increase their warded '
        'value, give them the appropriate counter.',
  ),
  GameKeyword(
    keyword: 'Wounded',
    imagePath: 'assets/icons/kw_wounded.png',
    category: KeywordCategory.status,
    description:
        'This character moves 1 square fewer. Also, in each '
        'assessment phase, roll the magic die. On 1–3 the '
        'character loses 1 Health.',
  ),
  GameKeyword(
    keyword: 'Cursed',
    imagePath: 'assets/icons/kw_cursed.png',
    category: KeywordCategory.status,
    description:
        'If this weapon rolls a critical hit, the target is '
        'cursed, even if no damage was caused.',
  ),

  // ── COMBAT STATS ─────────────────────────────────────────────────────────

  GameKeyword(
    keyword: 'Armour',
    imagePath: 'assets/icons/kw_armour.png',
    category: KeywordCategory.combat,
    description:
        'Physical armour reduces the number of hits suffered by '
        'the value shown each time the wearer is attacked.',
  ),
  GameKeyword(
    keyword: 'Unarmed Combat',
    imagePath: 'assets/icons/kw_unarmed_combat.png',
    category: KeywordCategory.combat,
    description:
        'This value is found on a character\'s board. They may '
        'use this value to make melee attacks, even without a weapon.',
  ),
  GameKeyword(
    keyword: 'Fast',
    imagePath: 'assets/icons/kw_fast.png',
    category: KeywordCategory.combat,
    description:
        'This character can move X additional squares when making '
        'a move action. If they have this ability from multiple '
        'sources, use the highest value.',
  ),
  GameKeyword(
    keyword: 'Terrifying',
    imagePath: 'assets/icons/kw_terrifying.png',
    category: KeywordCategory.combat,
    description:
        'If this character rolls a critical hit when attacking, '
        'the target is terrified. If an enemy ends their turn '
        'within short range, roll the magic die — on a 1, '
        'that character becomes terrified.',
  ),

  // ── DAMAGE TYPES ─────────────────────────────────────────────────────────

  GameKeyword(
    keyword: 'Bludgeoning',
    imagePath: 'assets/icons/kw_bludgeoning.png',
    category: KeywordCategory.damageType,
    description:
        'If this attack rolls a critical hit, the target is '
        'fatigued, even if no damage was caused. The target '
        'suffers 1 additional fatigued counter for each damage '
        'caused. Rolls 1 extra die when attacking terrain.',
  ),
  GameKeyword(
    keyword: 'Sharp',
    imagePath: 'assets/icons/kw_sharp.png',
    category: KeywordCategory.damageType,
    description:
        'If this weapon rolls a critical hit, the target is '
        'wounded, even if no damage was caused.',
  ),
  GameKeyword(
    keyword: 'Piercing',
    imagePath: 'assets/icons/kw_piercing.png',
    category: KeywordCategory.damageType,
    description: 'Physical armour cannot negate hits from this weapon.',
  ),
  GameKeyword(
    keyword: 'Entangling',
    imagePath: 'assets/icons/kw_entangling.png',
    category: KeywordCategory.damageType,
    description:
        'If this attack causes any hits, the target is fatigued. '
        'On a critical hit, the target is knocked prone. These '
        'effects apply even if no damage was caused.',
  ),
  GameKeyword(
    keyword: 'Blast',
    imagePath: 'assets/icons/kw_blast.png',
    category: KeywordCategory.damageType,
    description:
        'Blast attacks are aimed at a target square. If 2 or more '
        'hits are rolled, characters in the 8 adjacent squares '
        'also suffer the first attack that reaches them.',
  ),
  GameKeyword(
    keyword: 'Vicious',
    imagePath: 'assets/icons/kw_vicious.png',
    category: KeywordCategory.damageType,
    description:
        'Skull results on the blue die on attacks made with this '
        'weapon are critical hits.',
  ),

  // ── ABILITIES ────────────────────────────────────────────────────────────

  GameKeyword(
    keyword: 'Quickstrike',
    imagePath: 'assets/icons/kw_quickstrike.png',
    category: KeywordCategory.ability,
    description:
        'If this weapon rolls a critical hit during a melee '
        'attack, you may dash or make an attack with this (or any '
        'other weapon) for free after the initial attack resolves.',
  ),
  GameKeyword(
    keyword: 'Cleave',
    imagePath: 'assets/icons/kw_cleave.png',
    category: KeywordCategory.ability,
    description:
        'If this melee attack defeats an enemy, you may resolve '
        'the same attack against another eligible enemy, removing '
        '1 hit. Continue as long as each hit defeats an enemy.',
  ),
  GameKeyword(
    keyword: 'First Strike',
    imagePath: 'assets/icons/kw_first_strike.png',
    category: KeywordCategory.ability,
    description:
        'When this character enters melee range of an enemy '
        '(including when placed or when a door opens), it gets '
        'an immediate free melee attack action.',
  ),
  GameKeyword(
    keyword: 'Hawkeye',
    imagePath: 'assets/icons/kw_hawkeye.png',
    category: KeywordCategory.ability,
    description:
        'This attack ignores partial cover and can fire at '
        'engaged characters at any range without randomisation.',
  ),
  GameKeyword(
    keyword: 'Reach',
    imagePath: 'assets/icons/kw_reach.png',
    category: KeywordCategory.ability,
    description:
        'You may make a melee attack against an enemy up to X '
        'squares away, including diagonally. Unless in contact, '
        'the characters are not considered engaged otherwise.',
  ),
  GameKeyword(
    keyword: 'Reactive',
    imagePath: 'assets/icons/kw_reactive.png',
    category: KeywordCategory.ability,
    description:
        'Once per turn, if another character starts their action '
        'within melee range of this character\'s attacks, this '
        'character immediately makes a free attack against them.',
  ),
  GameKeyword(
    keyword: 'Relentless',
    imagePath: 'assets/icons/kw_relentless.png',
    category: KeywordCategory.ability,
    description:
        'A character attacked multiple times in 1 round by '
        'relentless characters has their physical armour reduced '
        'by 1 for each attack after the first, to a minimum of 0.',
  ),
  GameKeyword(
    keyword: 'Regeneration',
    imagePath: 'assets/icons/kw_regeneration.png',
    category: KeywordCategory.ability,
    description:
        'In the assessment phase, restore X pegs of the type '
        'shown. If from multiple sources, they are cumulative.',
  ),
  GameKeyword(
    keyword: 'Immunity',
    imagePath: 'assets/icons/kw_immunity.png',
    category: KeywordCategory.ability,
    description:
        'This character does not suffer any counters or effects '
        'from the ability shown alongside this icon.',
  ),
];

// Fast lookup map — build once.
final Map<String, GameKeyword> kKeywordMap = {
  for (final k in kAllKeywords) k.keyword: k,
};
