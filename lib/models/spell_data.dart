import 'spell.dart';
import 'spell_school.dart';

// X in all descriptions = number of magic pegs the player spends when casting.
// Words in [square brackets] are game keywords and will receive icons later.
const List<Spell> kAllSpells = [
  // ── PROXIMATE (blue) — enhances the caster's own body ────────────────────

  // Level 1
  Spell(
    id: 'prx_healing',
    name: 'Healing',
    school: SpellSchool.proximate,
    rank: 1,
    description: '[Action]: Restore X Health (max 3).',
  ),
  Spell(
    id: 'prx_focus',
    name: 'Focus',
    school: SpellSchool.proximate,
    rank: 1,
    description: '[Effortless]: Gain X [Blessed] counters.',
  ),
  Spell(
    id: 'prx_strength',
    name: 'Strength',
    school: SpellSchool.proximate,
    rank: 1,
    description:
        '[Effortless]: Gain +X [Unarmed Combat] until the end of the round.',
  ),
  Spell(
    id: 'prx_speed',
    name: 'Speed',
    school: SpellSchool.proximate,
    rank: 1,
    description: 'Passive: Use during a Move to move an additional X+1 squares.',
  ),
  Spell(
    id: 'prx_harden_skin',
    name: 'Harden Skin',
    school: SpellSchool.proximate,
    rank: 1,
    description: '[Action]: Gain +X [Armour] until the end of the round.',
  ),
  Spell(
    id: 'prx_recover',
    name: 'Recover',
    school: SpellSchool.proximate,
    rank: 1,
    description:
        '[Effortless]: May be used when [Fatigued] to remove a [Fatigued] counter.\n'
        '[Action]: Remove a [Poisoned] counter.',
  ),

  // Level 2
  Spell(
    id: 'prx_malacyte_shield',
    name: 'Malacyte Shield',
    school: SpellSchool.proximate,
    rank: 2,
    description: '[Action]: Increase your [Warded] value by X (max 1).',
  ),
  Spell(
    id: 'prx_insight',
    name: 'Insight',
    school: SpellSchool.proximate,
    rank: 2,
    description:
        '[Effortless]: Add X automatic hits to your Persuade rolls until the end of the round.',
  ),
  Spell(
    id: 'prx_hyper_awareness',
    name: 'Hyper Awareness',
    school: SpellSchool.proximate,
    rank: 2,
    description:
        '[Action]: Place a Reminder counter on your Adventurer and become [Blessed]. '
        'At any time, including midway through an enemy\'s Move, discard the Reminder counter to take an action. '
        'Remove the Reminder counter in the Assessment Phase if not used.',
  ),
  Spell(
    id: 'prx_jump',
    name: 'Jump',
    school: SpellSchool.proximate,
    rank: 2,
    description:
        '[Effortless]: Move your character X+1 squares away, counting each square horizontally and vertically.',
  ),
  Spell(
    id: 'prx_invisibility',
    name: 'Invisibility',
    school: SpellSchool.proximate,
    rank: 2,
    description:
        '[Action]: Gain the listed effects until the end of the round.\n'
        'X=1: You cannot be targeted by enemies beyond short range.\n'
        'X=2: You cannot be targeted by non-adjacent enemies. You do not block LoS.\n'
        'X=3+: You cannot be targeted. You ignore attacks of opportunity but may still make them. '
        'You do not block LoS. You only block movement if you choose to.',
  ),

  // Level 3
  Spell(
    id: 'prx_malacyte_aura',
    name: 'Malacyte Aura',
    school: SpellSchool.proximate,
    rank: 3,
    description:
        'Passive: This character\'s level 1–3 Proximate spells may affect adjacent friendly characters. '
        'Effects may be freely split between the caster and other characters. '
        'This character may also use their magical armour to negate hits on adjacent friends.',
  ),
  Spell(
    id: 'prx_advanced_healing',
    name: 'Advanced Healing',
    school: SpellSchool.proximate,
    rank: 3,
    description:
        '[Action]: Apply these effects in any combination up to X times:\n'
        '• Restore 1 Health (max 3).\n'
        '• Restore 1 Skill peg (max 1).\n'
        '• Remove a status counter.',
  ),
  Spell(
    id: 'prx_levitation',
    name: 'Levitation',
    school: SpellSchool.proximate,
    rank: 3,
    description:
        'Passive: Use during a Move to ignore terrain or characters '
        '(including ignoring attacks of opportunity) of up to X inches in height.',
  ),
  Spell(
    id: 'prx_alter_appearance',
    name: 'Alter Appearance',
    school: SpellSchool.proximate,
    rank: 3,
    description:
        '[Action]: Temporarily distort your features to resemble any other character of the same size. '
        'Other characters in play will treat you as that character type for all purposes, '
        'and will give permission to your character where required (e.g. to move through them or take an item). '
        'Characters with a higher rank than the caster ignore these effects.\n'
        'Place X Reminder counters on your character board. Remove one counter each Assessment Phase. '
        'Effects last until the last counter is removed.',
  ),

  // Level 4
  Spell(
    id: 'prx_phasing',
    name: 'Phasing',
    school: SpellSchool.proximate,
    rank: 4,
    description:
        '[Action] [Action]: Make a Move of up to X squares, freely moving through walls and terrain '
        'and ignoring attacks of opportunity. Must end the Move in an empty square.',
  ),
  Spell(
    id: 'prx_foresight',
    name: 'Foresight',
    school: SpellSchool.proximate,
    rank: 4,
    description:
        '[Action]: Look at the top X cards of the Event Deck. Place them back in any order, '
        'but turn them 90° to mark which ones you have seen.\n'
        'When any of these rotated cards is resolved, you may spend a Magic peg to re-roll '
        'any randomised effect such as an Entry Point or chosen Adventurer.',
  ),

  // Level 5
  Spell(
    id: 'prx_rearrange_cells',
    name: 'Rearrange Cells',
    school: SpellSchool.proximate,
    rank: 5,
    description:
        '[Action]: Temporarily mutate your body into that of a beast.\n'
        'Increase the following statistics by a total of X+2 in any combination:\n'
        '• [Unarmed Combat] (max 4)\n'
        '• [Armour] (max 3)\n'
        '• [Fast] (max 2)\n'
        'Instead of increasing a statistic, you may add any of [Bludgeoning] / [Sharp] / '
        '[Quickstrike] / [Entangling] / [Vicious] to your attacks.\n'
        'Increase your size by 1, or increase it by 2 and become [Terrifying] if X is 3 or more.\n'
        'While mutated you cannot use any equipment, although you can still carry it.\n'
        'Place X Reminder counters on your character board. Remove one counter each Assessment Phase. '
        'Effects last until the last counter is removed.',
  ),

  // ── VICARIOUS (purple) — manipulates other characters ────────────────────

  // Level 1
  Spell(
    id: 'vic_bless',
    name: 'Bless',
    school: SpellSchool.vicarious,
    rank: 1,
    description: '[Action]: Target gains X [Blessed] counters.',
  ),
  Spell(
    id: 'vic_protect',
    name: 'Protect',
    school: SpellSchool.vicarious,
    rank: 1,
    description: '[Action]: Target gains +X [Armour] until the end of the round.',
  ),
  Spell(
    id: 'vic_calm',
    name: 'Calm',
    school: SpellSchool.vicarious,
    rank: 1,
    description: '[Action]: Target removes a [Terrified] counter.',
  ),
  Spell(
    id: 'vic_fortitude',
    name: 'Fortitude',
    school: SpellSchool.vicarious,
    rank: 1,
    description:
        '[Action]: Target may ignore any status counters that would be applied '
        'until the end of the round.',
  ),
  Spell(
    id: 'vic_deflection',
    name: 'Deflection',
    school: SpellSchool.vicarious,
    rank: 1,
    description:
        '[Action]: Target increases their [Warded] value by X (max 1) until the end of the round.',
  ),
  Spell(
    id: 'vic_clouded_minds',
    name: 'Clouded Minds',
    school: SpellSchool.vicarious,
    rank: 1,
    description:
        '[Action]: Place X Reminder counters on eligible targets. '
        'If a target would act outside their turn '
        '(e.g. Attacks of Opportunity, Parry, Shield Block, Reaction Skills, etc) '
        'they must discard a counter instead of acting. '
        'The counters are removed in the Assessment Phase.',
  ),

  // Level 2
  Spell(
    id: 'vic_strengthen',
    name: 'Strengthen',
    school: SpellSchool.vicarious,
    rank: 2,
    description: '[Effortless]: Target removes X [Fatigued] counters.',
  ),
  Spell(
    id: 'vic_healing_hands',
    name: 'Healing Hands',
    school: SpellSchool.vicarious,
    rank: 2,
    description: '[Action]: Target restores X Health (max 3).',
  ),
  Spell(
    id: 'vic_nausea',
    name: 'Nausea',
    school: SpellSchool.vicarious,
    rank: 2,
    description: '[Action]: Target is [Poisoned].',
  ),
  Spell(
    id: 'vic_enchantment',
    name: 'Enchantment',
    school: SpellSchool.vicarious,
    rank: 2,
    description:
        '[Action]: Target is Moved up to X squares following all normal movement rules.',
  ),
  Spell(
    id: 'vic_illusion',
    name: 'Illusion',
    school: SpellSchool.vicarious,
    rank: 2,
    description:
        '[Action]: Place an Illusion in any empty square in range and LoS of both '
        'the caster and a chosen enemy. The enemy is distracted (see Illusions).',
  ),

  // Level 3
  Spell(
    id: 'vic_malacyte_sensitivity',
    name: 'Malacyte Sensitivity',
    school: SpellSchool.vicarious,
    rank: 3,
    description:
        'Passive: This character\'s Vicarious spells may target characters in '
        'short range without LoS.',
  ),
  Spell(
    id: 'vic_stun',
    name: 'Stun',
    school: SpellSchool.vicarious,
    rank: 3,
    description: '[Action]: Target suffers X [Fatigued] counters.',
  ),
  Spell(
    id: 'vic_blood_boil',
    name: 'Blood Boil',
    school: SpellSchool.vicarious,
    rank: 3,
    description: '[Action]: Target suffers an attack with 1 die and [Piercing].',
  ),
  Spell(
    id: 'vic_rouse',
    name: 'Rouse',
    school: SpellSchool.vicarious,
    rank: 3,
    description: '[Action]: Target removes a [Stunned] counter.',
  ),

  // Level 4
  Spell(
    id: 'vic_remote_resistance',
    name: 'Remote Resistance',
    school: SpellSchool.vicarious,
    rank: 4,
    description:
        'Passive: This character may resist any spells cast within short range '
        'of themselves, using their own pegs, regardless of the target.',
  ),
  Spell(
    id: 'vic_advanced_illusion',
    name: 'Advanced Illusion',
    school: SpellSchool.vicarious,
    rank: 4,
    description:
        '[Action]: Place up to X Illusions in empty squares in range and LoS. '
        'All enemies within range and LoS of both the caster and an Illusion are '
        'distracted (see Illusions). '
        'For resistance purposes, this spell is considered to be cast with one peg.\n'
        '[Effortless]: Move an Illusion as if it were a character, '
        'ignoring attacks of opportunity.',
  ),

  // Level 5
  Spell(
    id: 'vic_advanced_enchantment',
    name: 'Advanced Enchantment',
    school: SpellSchool.vicarious,
    rank: 5,
    description:
        '[Action]: Target takes up to X actions (max 3) under your control.',
  ),

  // ── ELEMENTAL (green) — manipulates the physical environment ─────────────

  // Level 1
  Spell(
    id: 'elm_telekinesis',
    name: 'Telekinesis',
    school: SpellSchool.elemental,
    rank: 1,
    description:
        '[Effortless]: Choose one:\n'
        '• Move a loose item, an item in a friendly character\'s inventory, or a '
        'random item inside an unlocked terrain piece (whichever one you draw first) '
        'up to X+2 squares. Traps drawn are triggered against a single target in '
        'contact with the terrain piece, if any, and then discarded. If the item '
        'reaches a friendly character place it in their inventory. If the item is a '
        'weapon and it reaches an enemy, treat it as having been thrown at them.\n'
        '• Spread a fire – choose a source of fire and add a [Burning] counter to '
        'any character or terrain piece within X+2 squares of it.',
  ),
  Spell(
    id: 'elm_open_door',
    name: 'Open Door',
    school: SpellSchool.elemental,
    rank: 1,
    description:
        '[Effortless]: Open or close an unlocked door.\n'
        '[Action]: Lock or unlock a door or terrain piece.',
  ),
  Spell(
    id: 'elm_focused_energy',
    name: 'Focused Energy',
    school: SpellSchool.elemental,
    rank: 1,
    description:
        '[Action]: Make a ranged attack with X dice, [Bludgeoning] and [Sharp].',
  ),
  Spell(
    id: 'elm_extinguish',
    name: 'Extinguish',
    school: SpellSchool.elemental,
    rank: 1,
    description:
        '[Action]: Remove a [Burning] counter, Torch (even from another '
        'character\'s inventory) or Brazier.',
  ),
  Spell(
    id: 'elm_detect',
    name: 'Detect',
    school: SpellSchool.elemental,
    rank: 1,
    description:
        'Passive: Use during a General Search action to take X additional items '
        '(max. 3) from the pouch. Traps are resolved immediately. Any other '
        'additional items are scattered from the caster.',
  ),
  Spell(
    id: 'elm_refract',
    name: 'Refract',
    school: SpellSchool.elemental,
    rank: 1,
    description:
        '[Action]: Place or flip a Darkness or Light counter and add X Reminder '
        'counters. Remove one Reminder counter in each Assessment Phase. Once the '
        'last is removed, return the room to its previous state.',
  ),

  // Level 2
  Spell(
    id: 'elm_push',
    name: 'Push',
    school: SpellSchool.elemental,
    rank: 2,
    description:
        '[Action]: Move an item, character, or portable terrain piece up to X '
        'squares directly away from you, with no attacks of opportunity. You must '
        'spend at least as many pegs as a character/object\'s size to move it. '
        'If a character is moved more squares than they have actions they are '
        'knocked prone.',
  ),
  Spell(
    id: 'elm_barricade',
    name: 'Barricade',
    school: SpellSchool.elemental,
    rank: 2,
    description:
        '[Action]: Create a barricade of your choice.\n'
        'Alternatively, mark up to X squares of a pit with Reminder counters. '
        'These squares are considered solid ground. When all squares of a pit are '
        'marked, remove it. If a pit is removed while a character is inside, they '
        'are defeated and Left for Dead.',
  ),
  Spell(
    id: 'elm_advanced_detect',
    name: 'Advanced Detect',
    school: SpellSchool.elemental,
    rank: 2,
    description:
        '[Action]: Look inside a Searchable terrain piece that fills up to X '
        'squares. You may discard an additional Magic peg to remove one Trap found.',
  ),
  Spell(
    id: 'elm_advanced_telekinesis',
    name: 'Advanced Telekinesis',
    school: SpellSchool.elemental,
    rank: 2,
    description:
        '[Action]: Choose one:\n'
        '• Move any terrain piece you could normally move up to X+2 squares. '
        'If it reaches a character, stop moving and treat it as a Knockback with '
        'X+2 dice.\n'
        '• Move an item in an enemy\'s inventory up to X+2 squares. They may spend '
        'a Skill peg to scatter the item instead. Otherwise, if the item reaches a '
        'friendly character place it in their inventory. If the item is a weapon '
        'and it reaches an enemy, treat it as having been thrown at them.',
  ),
  Spell(
    id: 'elm_weaken_armour',
    name: 'Weaken Armour',
    school: SpellSchool.elemental,
    rank: 2,
    description:
        '[Action]: Reduce an enemy\'s [Armour] by X until the end of the round.',
  ),

  // Level 3
  Spell(
    id: 'elm_malacyte_perception',
    name: 'Malacyte Perception',
    school: SpellSchool.elemental,
    rank: 3,
    description:
        'Passive: This character\'s Elemental spells may target objects in '
        'short range without LoS.',
  ),
  Spell(
    id: 'elm_fireball',
    name: 'Fireball',
    school: SpellSchool.elemental,
    rank: 3,
    description:
        '[Action]: Requires a source of fire within range of the caster and the '
        'target. Make a ranged attack from the source of fire with X dice, '
        '[Blast] and [Burning].',
  ),
  Spell(
    id: 'elm_torrent',
    name: 'Torrent',
    school: SpellSchool.elemental,
    rank: 3,
    description:
        '[Action]: All targets must be in short range and LoS of a source of water.\n'
        'Choose one:\n'
        '• Remove X [Burning] counters, torches or sconces.\n'
        '• Knock X characters prone.\n'
        '• Choose a character and roll X dice. Each hit scored [Fatigues] the '
        'target. If the character becomes [Stunned], any remaining hits are '
        'treated as an attack with [Piercing].',
  ),
  Spell(
    id: 'elm_cocoon',
    name: 'Cocoon',
    school: SpellSchool.elemental,
    rank: 3,
    description:
        '[Action]: Gain the benefits of a Rest action, regardless of enemies in '
        'the room or in short range and LoS (enemies engaged with a Resting '
        'character will still prevent it as normal). Nearby characters may Rest '
        'as part of the spell – it affects up to X characters (including the '
        'caster) with a range of X squares.',
  ),

  // Level 4
  Spell(
    id: 'elm_energy_burst',
    name: 'Energy Burst',
    school: SpellSchool.elemental,
    rank: 4,
    description:
        '[Action]: Move characters or portable terrain pieces with a total size '
        'up to X up to X squares directly away from you, with no attacks of '
        'opportunity. Characters are knocked prone.',
  ),
  Spell(
    id: 'elm_rebuild',
    name: 'Rebuild',
    school: SpellSchool.elemental,
    rank: 4,
    description:
        '[Action][Action]: Choose a wall of up to X squares in length. Detach it '
        'and reconnect it anywhere else within short range. This cannot cause any '
        'room to become inaccessible from the rest of the gaming area.',
  ),

  // Level 5
  Spell(
    id: 'elm_portal',
    name: 'Portal',
    school: SpellSchool.elemental,
    rank: 5,
    description: '[Action]: Place a Portal in an empty square.',
  ),
];
