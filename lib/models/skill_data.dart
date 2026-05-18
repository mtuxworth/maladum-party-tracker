import 'skill.dart';

const List<Skill> kAllSkills = [
  // ── AGILITY ──────────────────────────────────────────────────────────────
  Skill(
    id: 'agi_acrobatics_1',
    name: 'Acrobatics',
    tier: 1,
    category: 'Agility',
    description: 'Stand Up as an effortless action.',
  ),
  Skill(
    id: 'agi_acrobatics_2',
    name: 'Acrobatics',
    tier: 2,
    category: 'Agility',
    description:
        'Reaction: Roll 3 combat dice when targeted; each hit '
        'negates one hit from the attacker.',
    prerequisiteId: 'agi_acrobatics_1',
  ),
  Skill(
    id: 'agi_acrobatics_3',
    name: 'Acrobatics',
    tier: 3,
    category: 'Agility',
    description:
        'Push all engaged enemies back, dealing a 2-die attack '
        'to each; then make a Move action.',
    prerequisiteId: 'agi_acrobatics_2',
  ),
  Skill(
    id: 'agi_combat_arts_1',
    name: 'Combat Arts',
    tier: 1,
    category: 'Agility',
    description:
        'Melee attacks gain Quickstrike; with a Quickstrike '
        'weapon you may Dash AND Attack.',
  ),
  Skill(
    id: 'agi_combat_arts_2',
    name: 'Combat Arts',
    tier: 2,
    category: 'Agility',
    description:
        'Reaction: When attacked in melee, swap position with '
        'the enemy and make a Move or Knock Back +1 die.',
    prerequisiteId: 'agi_combat_arts_1',
  ),
  Skill(
    id: 'agi_combat_arts_3',
    name: 'Combat Arts',
    tier: 3,
    category: 'Agility',
    description:
        'Jump from higher ground; knock prone all same-or-smaller '
        'characters at landing; make a Melee Attack at full distance.',
    prerequisiteId: 'agi_combat_arts_2',
  ),
  Skill(
    id: 'agi_fleet_of_foot_1',
    name: 'Fleet of Foot',
    tier: 1,
    category: 'Agility',
    description: 'Make a Move action.',
  ),
  Skill(
    id: 'agi_fleet_of_foot_2',
    name: 'Fleet of Foot',
    tier: 2,
    category: 'Agility',
    description: 'Passive: Gain Fast.',
    prerequisiteId: 'agi_fleet_of_foot_1',
  ),
  Skill(
    id: 'agi_fleet_of_foot_3',
    name: 'Fleet of Foot',
    tier: 3,
    category: 'Agility',
    description:
        'Move action; all Move actions this turn ignore attacks '
        'of opportunity and knock enemies prone on contact.',
    prerequisiteId: 'agi_fleet_of_foot_2',
  ),
  Skill(
    id: 'agi_reflexes_1',
    name: 'Reflexes',
    tier: 1,
    category: 'Agility',
    description:
        'Reaction: When engaged by an enemy, make a Move '
        'ignoring opportunity attacks, then an Attack.',
  ),
  Skill(
    id: 'agi_reflexes_2',
    name: 'Reflexes',
    tier: 2,
    category: 'Agility',
    description:
        'Reaction: When engaged, make a Move and Attack action '
        'ignoring attacks of opportunity.',
    prerequisiteId: 'agi_reflexes_1',
  ),
  Skill(
    id: 'agi_reflexes_3',
    name: 'Reflexes',
    tier: 3,
    category: 'Agility',
    description:
        'Reaction: When engaged, the attacker is Stunned; make '
        'two Moves ignoring opportunity and an Attack.',
    prerequisiteId: 'agi_reflexes_2',
  ),

  // ── CUNNING ──────────────────────────────────────────────────────────────
  Skill(
    id: 'cun_distraction_1',
    name: 'Distraction',
    tier: 1,
    category: 'Cunning',
    description:
        'A character in medium range and LoS becomes Fatigued.',
  ),
  Skill(
    id: 'cun_distraction_2',
    name: 'Distraction',
    tier: 2,
    category: 'Cunning',
    description:
        'Ranged Attack or Throw at target; another enemy in '
        'short range and LoS suffers two Fatigued counters.',
    prerequisiteId: 'cun_distraction_1',
  ),
  Skill(
    id: 'cun_distraction_3',
    name: 'Distraction',
    tier: 3,
    category: 'Cunning',
    description:
        'Move into contact with any enemy; act freely without '
        'suffering damage that round; then make another Move.',
    prerequisiteId: 'cun_distraction_2',
  ),
  Skill(
    id: 'cun_light_fingers_1',
    name: 'Light Fingers',
    tier: 1,
    category: 'Cunning',
    description:
        'Reaction: After suffering a melee attack with no damage, '
        'take one item from the attacker\'s inventory.',
  ),
  Skill(
    id: 'cun_light_fingers_2',
    name: 'Light Fingers',
    tier: 2,
    category: 'Cunning',
    description:
        'Move into contact; make a Pickpocket action — roll a '
        'combat die to steal an item or knock the target prone.',
    prerequisiteId: 'cun_light_fingers_1',
  ),
  Skill(
    id: 'cun_light_fingers_3',
    name: 'Light Fingers',
    tier: 3,
    category: 'Cunning',
    description: 'Passive: The Pickpocket action is always available.',
    prerequisiteId: 'cun_light_fingers_2',
  ),
  Skill(
    id: 'cun_persuasion_1',
    name: 'Persuasion',
    tier: 1,
    category: 'Cunning',
    description:
        'Make a Persuade action against a friendly Adventurer '
        'to try to recruit them to assist.',
  ),
  Skill(
    id: 'cun_persuasion_2',
    name: 'Persuasion',
    tier: 2,
    category: 'Cunning',
    description: 'Passive: Add one extra die to all Persuade rolls.',
    prerequisiteId: 'cun_persuasion_1',
  ),
  Skill(
    id: 'cun_persuasion_3',
    name: 'Persuasion',
    tier: 3,
    category: 'Cunning',
    description:
        'Make a Persuade action against any character with '
        'three automatic hits.',
    prerequisiteId: 'cun_persuasion_2',
  ),
  Skill(
    id: 'cun_tricks_1',
    name: 'Tricks of the Trade',
    tier: 1,
    category: 'Cunning',
    description:
        'Lock or unlock a door or terrain piece in contact; '
        'or ignore tokens drawn during a Search action.',
  ),
  Skill(
    id: 'cun_tricks_2',
    name: 'Tricks of the Trade',
    tier: 2,
    category: 'Cunning',
    description:
        'Reaction: When a trap card is drawn targeting this '
        'character, discard it with no effect.',
    prerequisiteId: 'cun_tricks_1',
  ),
  Skill(
    id: 'cun_tricks_3',
    name: 'Tricks of the Trade',
    tier: 3,
    category: 'Cunning',
    description:
        'Passive: Attacks gain Piercing; draw one extra token '
        'when Searching terrain.',
    prerequisiteId: 'cun_tricks_2',
  ),

  // ── ENDURANCE ────────────────────────────────────────────────────────────
  Skill(
    id: 'end_impervious_1',
    name: 'Impervious',
    tier: 1,
    category: 'Endurance',
    description: 'Discard any status counter with no effect.',
  ),
  Skill(
    id: 'end_impervious_2',
    name: 'Impervious',
    tier: 2,
    category: 'Endurance',
    description: 'Gain +2 Health until end of round.',
    prerequisiteId: 'end_impervious_1',
  ),
  Skill(
    id: 'end_impervious_3',
    name: 'Impervious',
    tier: 3,
    category: 'Endurance',
    description:
        'Restore 1 Health (may exceed starting); discard all '
        'status counters and resist all spells and damage.',
    prerequisiteId: 'end_impervious_2',
  ),
  Skill(
    id: 'end_onslaught_1',
    name: 'Onslaught',
    tier: 1,
    category: 'Endurance',
    description: 'Make another Melee Attack action.',
  ),
  Skill(
    id: 'end_onslaught_2',
    name: 'Onslaught',
    tier: 2,
    category: 'Endurance',
    description:
        'Reaction: After scoring one or more hits on any attack, '
        'make an additional Melee Attack.',
    prerequisiteId: 'end_onslaught_1',
  ),
  Skill(
    id: 'end_onslaught_3',
    name: 'Onslaught',
    tier: 3,
    category: 'Endurance',
    description:
        'Use during a Move; make a melee attack against each '
        'enemy engaged during that movement.',
    prerequisiteId: 'end_onslaught_2',
  ),
  Skill(
    id: 'end_quick_recovery_1',
    name: 'Quick Recovery',
    tier: 1,
    category: 'Endurance',
    description: 'Restore 1 Health.',
  ),
  Skill(
    id: 'end_quick_recovery_2',
    name: 'Quick Recovery',
    tier: 2,
    category: 'Endurance',
    description:
        'After being defeated, restore 1 Health, Stand Up, '
        'and remove Stunned, Poisoned or Wounded counters.',
    prerequisiteId: 'end_quick_recovery_1',
  ),
  Skill(
    id: 'end_quick_recovery_3',
    name: 'Quick Recovery',
    tier: 3,
    category: 'Endurance',
    description:
        'Passive: At the start of your turn you may remove '
        'one Fatigued counter.',
    prerequisiteId: 'end_quick_recovery_2',
  ),
  Skill(
    id: 'end_steady_1',
    name: 'Steady',
    tier: 1,
    category: 'Endurance',
    description:
        'Cannot be Stunned, Knocked Back or knocked prone '
        'until end of round.',
  ),
  Skill(
    id: 'end_steady_2',
    name: 'Steady',
    tier: 2,
    category: 'Endurance',
    description:
        'Passive: Ignore Cumbersome on turns you do not Move; '
        'gain one extra die on attacks and Knock Backs.',
    prerequisiteId: 'end_steady_1',
  ),
  Skill(
    id: 'end_steady_3',
    name: 'Steady',
    tier: 3,
    category: 'Endurance',
    description:
        'Cannot become Fatigued, Stunned, Knocked Back or prone; '
        'enemies cannot leave contact; free Knock Back action.',
    prerequisiteId: 'end_steady_2',
  ),

  // ── MAGIC ────────────────────────────────────────────────────────────────
  Skill(
    id: 'mag_fortified_mind_1',
    name: 'Fortified Mind',
    tier: 1,
    category: 'Magic',
    description: 'Cast a spell while engaged in melee combat.',
  ),
  Skill(
    id: 'mag_fortified_mind_2',
    name: 'Fortified Mind',
    tier: 2,
    category: 'Magic',
    description:
        'Reaction: When a friendly character\'s magical armour is '
        'attacked, use this character\'s Magic to boost it.',
    prerequisiteId: 'mag_fortified_mind_1',
  ),
  Skill(
    id: 'mag_fortified_mind_3',
    name: 'Fortified Mind',
    tier: 3,
    category: 'Magic',
    description:
        'Until end of round, all friendly spells resist '
        'automatically; lower-rank spells do not cause Fatigue.',
    prerequisiteId: 'mag_fortified_mind_2',
  ),
  Skill(
    id: 'mag_malacyte_mastery_1',
    name: 'Malacyte Mastery',
    tier: 1,
    category: 'Magic',
    description: 'Cast any level-1 spell without spending an action.',
  ),
  Skill(
    id: 'mag_malacyte_mastery_2',
    name: 'Malacyte Mastery',
    tier: 2,
    category: 'Magic',
    description:
        'Reaction: After rolling the Magic Die, immediately cast '
        'any accessible spell at casting value 2 for free.',
    prerequisiteId: 'mag_malacyte_mastery_1',
  ),
  Skill(
    id: 'mag_malacyte_mastery_3',
    name: 'Malacyte Mastery',
    tier: 3,
    category: 'Magic',
    description:
        'Passive: Gain Regeneration; restore 1 Magic peg in '
        'the Assessment Phase.',
    prerequisiteId: 'mag_malacyte_mastery_2',
  ),
  Skill(
    id: 'mag_power_manipulation_1',
    name: 'Power Manipulation',
    tier: 1,
    category: 'Magic',
    description:
        'Reaction: Cast any accessible spell you have access to.',
  ),
  Skill(
    id: 'mag_power_manipulation_2',
    name: 'Power Manipulation',
    tier: 2,
    category: 'Magic',
    description:
        'Passive: Spend any number of Skill pegs when casting a '
        'spell to increase its casting value beyond your rank.',
    prerequisiteId: 'mag_power_manipulation_1',
  ),
  Skill(
    id: 'mag_power_manipulation_3',
    name: 'Power Manipulation',
    tier: 3,
    category: 'Magic',
    description:
        'Channel weapon: make a ranged attack with dice equal '
        'to Magic pegs spent; Mental Overload results ignored.',
    prerequisiteId: 'mag_power_manipulation_2',
  ),

  // ── MELEE ────────────────────────────────────────────────────────────────
  Skill(
    id: 'mel_brutal_assault_1',
    name: 'Brutal Assault',
    tier: 1,
    category: 'Melee',
    description:
        'Melee Attack with one extra combat die; lay target '
        'prone if it survives.',
  ),
  Skill(
    id: 'mel_brutal_assault_2',
    name: 'Brutal Assault',
    tier: 2,
    category: 'Melee',
    description:
        'Throw an adjacent character up to short range; roll '
        'an extra die and trigger Knock Back on terrain.',
    prerequisiteId: 'mel_brutal_assault_1',
  ),
  Skill(
    id: 'mel_brutal_assault_3',
    name: 'Brutal Assault',
    tier: 3,
    category: 'Melee',
    description:
        'Make up to three Melee actions using only your O die +1; '
        'each hit target is laid prone.',
    prerequisiteId: 'mel_brutal_assault_2',
  ),
  Skill(
    id: 'mel_disarm_1',
    name: 'Disarm',
    tier: 1,
    category: 'Melee',
    description:
        'Reaction: After taking no damage from a melee attack, '
        'remove the attacker\'s weapon and place it on the floor.',
  ),
  Skill(
    id: 'mel_disarm_2',
    name: 'Disarm',
    tier: 2,
    category: 'Melee',
    description:
        'Reaction: As tier 1, and also pick up or drop another '
        'item from the attacker\'s inventory.',
    prerequisiteId: 'mel_disarm_1',
  ),
  Skill(
    id: 'mel_disarm_3',
    name: 'Disarm',
    tier: 3,
    category: 'Melee',
    description:
        'As tier 2, and also make an additional Melee Attack '
        'with no attacks of opportunity.',
    prerequisiteId: 'mel_disarm_2',
  ),
  Skill(
    id: 'mel_frenzy_1',
    name: 'Frenzy',
    tier: 1,
    category: 'Melee',
    description: 'Use before a melee attack to add two dice.',
  ),
  Skill(
    id: 'mel_frenzy_2',
    name: 'Frenzy',
    tier: 2,
    category: 'Melee',
    description: 'Use before a melee attack to add three dice.',
    prerequisiteId: 'mel_frenzy_1',
  ),
  Skill(
    id: 'mel_frenzy_3',
    name: 'Frenzy',
    tier: 3,
    category: 'Melee',
    description:
        'Add four dice; split hits between any number of enemies '
        'in range; gain First Strike.',
    prerequisiteId: 'mel_frenzy_2',
  ),
  Skill(
    id: 'mel_weapons_master_1',
    name: 'Weapons Master',
    tier: 1,
    category: 'Melee',
    description: 'Make a Melee Attack with a weapon; re-roll one die.',
  ),
  Skill(
    id: 'mel_weapons_master_2',
    name: 'Weapons Master',
    tier: 2,
    category: 'Melee',
    description:
        'Passive: Use Shield Block as an effortless action; '
        'you still become Fatigued if used outside your turn.',
    prerequisiteId: 'mel_weapons_master_1',
  ),
  Skill(
    id: 'mel_weapons_master_3',
    name: 'Weapons Master',
    tier: 3,
    category: 'Melee',
    description:
        'After rolling for melee, re-roll for a different weapon '
        'and apply separately; make a Knock Back +1 die.',
    prerequisiteId: 'mel_weapons_master_2',
  ),

  // ── RANGED ───────────────────────────────────────────────────────────────
  Skill(
    id: 'ran_bullseye_1',
    name: 'Bullseye',
    tier: 1,
    category: 'Ranged',
    description:
        'Ranged Attack at short range scoring 1 automatic hit, '
        'ignoring cover.',
  ),
  Skill(
    id: 'ran_bullseye_2',
    name: 'Bullseye',
    tier: 2,
    category: 'Ranged',
    description:
        'Ranged Attack at medium range scoring 1 automatic hit, '
        'ignoring cover. Passive: ignore cover at short range.',
    prerequisiteId: 'ran_bullseye_1',
  ),
  Skill(
    id: 'ran_bullseye_3',
    name: 'Bullseye',
    tier: 3,
    category: 'Ranged',
    description:
        'Ranged Attack at medium range scoring 2 automatic hits, '
        'ignoring cover and physical armour.',
    prerequisiteId: 'ran_bullseye_2',
  ),
  Skill(
    id: 'ran_counter_shot_1',
    name: 'Counter Shot',
    tier: 1,
    category: 'Ranged',
    description:
        'Reaction: After being targeted by a ranged attack or '
        'spell, make a Ranged Attack or cast a spell.',
  ),
  Skill(
    id: 'ran_counter_shot_2',
    name: 'Counter Shot',
    tier: 2,
    category: 'Ranged',
    description:
        'Reaction: As tier 1, but usable at any time after the '
        'targeting enemy has taken its first action.',
    prerequisiteId: 'ran_counter_shot_1',
  ),
  Skill(
    id: 'ran_counter_shot_3',
    name: 'Counter Shot',
    tier: 3,
    category: 'Ranged',
    description:
        'Reaction: As tier 2; spend a Skill peg to shoot back '
        'with a Ranged Attack or spell at any time.',
    prerequisiteId: 'ran_counter_shot_2',
  ),
  Skill(
    id: 'ran_ranged_expert_1',
    name: 'Ranged Expert',
    tier: 1,
    category: 'Ranged',
    description:
        'Throw any melee weapon rolling two extra dice; or throw '
        'any other item rolling two dice.',
  ),
  Skill(
    id: 'ran_ranged_expert_2',
    name: 'Ranged Expert',
    tier: 2,
    category: 'Ranged',
    description:
        'Passive: May treat any item as a thrown weapon with two '
        'extra dice; throwing an item is an effortless action.',
    prerequisiteId: 'ran_ranged_expert_1',
  ),
  Skill(
    id: 'ran_ranged_expert_3',
    name: 'Ranged Expert',
    tier: 3,
    category: 'Ranged',
    description:
        'Ranged Attack ignoring Unreliable; apply Bludgeoning, '
        'Sharp and Piercing; critical hits on O result.',
    prerequisiteId: 'ran_ranged_expert_2',
  ),
  Skill(
    id: 'ran_trick_shot_1',
    name: 'Trick Shot',
    tier: 1,
    category: 'Ranged',
    description: 'Make a Ranged Attack; re-roll one die.',
  ),
  Skill(
    id: 'ran_trick_shot_2',
    name: 'Trick Shot',
    tier: 2,
    category: 'Ranged',
    description:
        'Ranged Attack to steal an item from an enemy\'s hand; '
        'on a hit the item is knocked up to 6 squares away.',
    prerequisiteId: 'ran_trick_shot_1',
  ),
  Skill(
    id: 'ran_trick_shot_3',
    name: 'Trick Shot',
    tier: 3,
    category: 'Ranged',
    description:
        'Ranged Attack with three extra combat dice; split hits '
        'between any eligible targets within range.',
    prerequisiteId: 'ran_trick_shot_2',
  ),

  // ── STEALTH ──────────────────────────────────────────────────────────────
  Skill(
    id: 'ste_ambush_1',
    name: 'Ambush',
    tier: 1,
    category: 'Stealth',
    description:
        'Reaction: When an enemy ends a move within 4 squares '
        'while you are in cover, make a Ranged Attack.',
  ),
  Skill(
    id: 'ste_ambush_2',
    name: 'Ambush',
    tier: 2,
    category: 'Stealth',
    description:
        'Reaction: As tier 1, but also make a Move before or '
        'after the attack.',
    prerequisiteId: 'ste_ambush_1',
  ),
  Skill(
    id: 'ste_ambush_3',
    name: 'Ambush',
    tier: 3,
    category: 'Stealth',
    description:
        'Reaction: Move + Ranged Attack + another Move; any '
        'of these may interleave with the triggering enemy\'s actions.',
    prerequisiteId: 'ste_ambush_2',
  ),
  Skill(
    id: 'ste_camouflage_1',
    name: 'Camouflage',
    tier: 1,
    category: 'Stealth',
    description:
        'While in contact with any terrain, cannot be targeted '
        'by ranged attacks or spells.',
  ),
  Skill(
    id: 'ste_camouflage_2',
    name: 'Camouflage',
    tier: 2,
    category: 'Stealth',
    description:
        'Move or Ranged Attack while camouflaged; enemies cannot '
        'engage you while in this state.',
    prerequisiteId: 'ste_camouflage_1',
  ),
  Skill(
    id: 'ste_camouflage_3',
    name: 'Camouflage',
    tier: 3,
    category: 'Stealth',
    description:
        'Passive Reaction: While camouflaged, make a Ranged '
        'Attack at any time; you then become Fatigued.',
    prerequisiteId: 'ste_camouflage_2',
  ),
  Skill(
    id: 'ste_duck_for_cover_1',
    name: 'Duck for Cover',
    tier: 1,
    category: 'Stealth',
    description:
        'Reaction: After being targeted within 4 squares, '
        'move into cover and ignore all effects of the attack.',
  ),
  Skill(
    id: 'ste_duck_for_cover_2',
    name: 'Duck for Cover',
    tier: 2,
    category: 'Stealth',
    description:
        'Reaction: After being targeted at any range, move '
        'into cover and ignore all effects of the attack.',
    prerequisiteId: 'ste_duck_for_cover_1',
  ),
  Skill(
    id: 'ste_duck_for_cover_3',
    name: 'Duck for Cover',
    tier: 3,
    category: 'Stealth',
    description:
        'Reaction: Make a Move into cover at any time; ignore '
        'all ranged attacks for the rest of the round.',
    prerequisiteId: 'ste_duck_for_cover_2',
  ),
  Skill(
    id: 'ste_hard_to_hit_1',
    name: 'Hard to Hit',
    tier: 1,
    category: 'Stealth',
    description:
        'While in cover, ranged attacks cannot affect this '
        'character until end of round.',
  ),
  Skill(
    id: 'ste_hard_to_hit_2',
    name: 'Hard to Hit',
    tier: 2,
    category: 'Stealth',
    description:
        'While in cover or beyond short range, ranged attacks '
        'cannot affect this character until end of round.',
    prerequisiteId: 'ste_hard_to_hit_1',
  ),
  Skill(
    id: 'ste_hard_to_hit_3',
    name: 'Hard to Hit',
    tier: 3,
    category: 'Stealth',
    description:
        'Make a Move ignoring opportunity attacks; cannot be '
        'affected by ranged attacks for the rest of the round.',
    prerequisiteId: 'ste_hard_to_hit_2',
  ),

  // ── SUPPORT ──────────────────────────────────────────────────────────────
  Skill(
    id: 'sup_barter_1',
    name: 'Barter',
    tier: 1,
    category: 'Support',
    description:
        'Market Phase: Purchase any item plus one additional '
        'random rare item; buy up to 10×rank Guilders of items.',
  ),
  Skill(
    id: 'sup_barter_2',
    name: 'Barter',
    tier: 2,
    category: 'Support',
    description:
        'Market Phase: Deduct up to 2G from the cost of up to '
        'three items; reduce upkeep cost of one item or Adventurer.',
    prerequisiteId: 'sup_barter_1',
  ),
  Skill(
    id: 'sup_barter_3',
    name: 'Barter',
    tier: 3,
    category: 'Support',
    description:
        'Market Phase: Increase Guilders gained from any quest '
        'objectives by 50%, rounding up.',
    prerequisiteId: 'sup_barter_2',
  ),
  Skill(
    id: 'sup_dispelling_1',
    name: 'Dispelling',
    tier: 1,
    category: 'Support',
    description:
        'Remove a Terrified counter from a friendly character '
        'in short range.',
  ),
  Skill(
    id: 'sup_dispelling_2',
    name: 'Dispelling',
    tier: 2,
    category: 'Support',
    description:
        'Reaction: After defeating an enemy, all friendly '
        'characters in short range may remove a Terrified counter.',
    prerequisiteId: 'sup_dispelling_1',
  ),
  Skill(
    id: 'sup_dispelling_3',
    name: 'Dispelling',
    tier: 3,
    category: 'Support',
    description:
        'All friendly characters in short range remove all '
        'Terrified and Fatigued counters.',
    prerequisiteId: 'sup_dispelling_2',
  ),
  Skill(
    id: 'sup_intimidating_1',
    name: 'Intimidating',
    tier: 1,
    category: 'Support',
    description:
        'When an enemy in LoS activates, choose its target '
        'for the round from any eligible character it can see.',
  ),
  Skill(
    id: 'sup_intimidating_2',
    name: 'Intimidating',
    tier: 2,
    category: 'Support',
    description:
        'Reaction: When an enemy enters LoS or starts its turn '
        'in LoS, immediately Stun it.',
    prerequisiteId: 'sup_intimidating_1',
  ),
  Skill(
    id: 'sup_intimidating_3',
    name: 'Intimidating',
    tier: 3,
    category: 'Support',
    description:
        'All enemies of this character\'s rank or lower within '
        'short range and LoS are Stunned and Terrified.',
    prerequisiteId: 'sup_intimidating_2',
  ),
  Skill(
    id: 'sup_trading_1',
    name: 'Trading',
    tier: 1,
    category: 'Support',
    description:
        'A friendly Adventurer in short range and LoS may '
        'immediately make the same action you just made.',
  ),
  Skill(
    id: 'sup_trading_2',
    name: 'Trading',
    tier: 2,
    category: 'Support',
    description:
        'Advancement Phase: Add Experience to any other Adventurer '
        'in party (Agility, Endurance, Melee, Ranged or Stealth).',
    prerequisiteId: 'sup_trading_1',
  ),
  Skill(
    id: 'sup_trading_3',
    name: 'Trading',
    tier: 3,
    category: 'Support',
    description:
        'Advancement Phase: Add Experience to up to two '
        'Adventurers in your party.',
    prerequisiteId: 'sup_trading_2',
  ),

  // ── SURVIVAL ─────────────────────────────────────────────────────────────
  Skill(
    id: 'sur_natural_remedies_1',
    name: 'Natural Remedies',
    tier: 1,
    category: 'Survival',
    description:
        'Rest: You and friendly characters who also Rest this '
        'round restore an extra Health peg and Magic peg.',
  ),
  Skill(
    id: 'sur_natural_remedies_2',
    name: 'Natural Remedies',
    tier: 2,
    category: 'Survival',
    description:
        'Rest: Remove a Wounded or Poisoned counter from a '
        'character you are in contact with.',
    prerequisiteId: 'sur_natural_remedies_1',
  ),
  Skill(
    id: 'sur_natural_remedies_3',
    name: 'Natural Remedies',
    tier: 3,
    category: 'Survival',
    description:
        'Rest: You and all friendly characters in contact are '
        'Blessed; remove a Wounded, Poisoned or Burning counter.',
    prerequisiteId: 'sur_natural_remedies_2',
  ),
  Skill(
    id: 'sur_one_with_nature_1',
    name: 'One with Nature',
    tier: 1,
    category: 'Survival',
    description:
        'Rest: Look at the top three Event Deck cards; choose '
        'one non-Adversary card to be drawn next.',
  ),
  Skill(
    id: 'sur_one_with_nature_2',
    name: 'One with Nature',
    tier: 2,
    category: 'Survival',
    description:
        'Start of turn: Choose a Wandering Beast of rank 1–3 '
        'to control for the round.',
    prerequisiteId: 'sur_one_with_nature_1',
  ),
  Skill(
    id: 'sur_one_with_nature_3',
    name: 'One with Nature',
    tier: 3,
    category: 'Survival',
    description:
        'Summon a random Wandering Beast of rank 1–3 at an '
        'Entry Point of your choice; it is yours for the campaign.',
    prerequisiteId: 'sur_one_with_nature_2',
  ),
  Skill(
    id: 'sur_ready_for_anything_1',
    name: 'Ready for Anything',
    tier: 1,
    category: 'Survival',
    description: 'Reaction: Use at any time. Take an action.',
  ),
  Skill(
    id: 'sur_ready_for_anything_2',
    name: 'Ready for Anything',
    tier: 2,
    category: 'Survival',
    description: 'Passive: May use Ready for Anything once per round.',
    prerequisiteId: 'sur_ready_for_anything_1',
  ),
  Skill(
    id: 'sur_ready_for_anything_3',
    name: 'Ready for Anything',
    tier: 3,
    category: 'Survival',
    description:
        'Reaction: At any time, make a Move + Attack action; '
        'you then become Fatigued.',
    prerequisiteId: 'sur_ready_for_anything_2',
  ),
  Skill(
    id: 'sur_tracking_1',
    name: 'Tracking',
    tier: 1,
    category: 'Survival',
    description: 'Look at the top three cards of the Event Deck.',
  ),
  Skill(
    id: 'sur_tracking_2',
    name: 'Tracking',
    tier: 2,
    category: 'Survival',
    description:
        'Reaction: When an NPC arrives at this character\'s '
        'position, double the distance or redirect it elsewhere.',
    prerequisiteId: 'sur_tracking_1',
  ),
  Skill(
    id: 'sur_tracking_3',
    name: 'Tracking',
    tier: 3,
    category: 'Survival',
    description:
        'Reaction: Before or after an enemy enters LoS, '
        'reposition this character in an adjacent square.',
    prerequisiteId: 'sur_tracking_2',
  ),
];
