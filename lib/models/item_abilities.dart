class ItemAbility {
  final String keyword;
  final String description;
  // null = boolean toggle; positive int = numeric, max value for custom form
  final int? maxValue;

  const ItemAbility({
    required this.keyword,
    required this.description,
    this.maxValue,
  });

  bool get isNumeric => maxValue != null;
}

/// Every known ability keyword, ordered for display.
const List<ItemAbility> kItemAbilities = [
  // ── Combat ──────────────────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Combat',
    description:
        'Roll N dice when attacking. Each die can deal 1 damage on a hit result.',
    maxValue: 5,
  ),

  // ── Offensive ───────────────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Burst',
    description:
        'The attack also hits all enemy models adjacent to the primary target.',
  ),
  ItemAbility(
    keyword: 'Sharp',
    description:
        'Ignores armour saves — the defender cannot roll armour dice against this attack.',
  ),
  ItemAbility(
    keyword: 'Bludgeoning',
    description:
        'Cannot be defended against with Parry or shields. Ignores blocking effects.',
  ),
  ItemAbility(
    keyword: 'Quickstrike',
    description:
        'This weapon attacks before the opponent can react, regardless of initiative.',
  ),
  ItemAbility(
    keyword: 'Vicious',
    description: 'Deals one additional point of damage on a successful hit.',
  ),
  ItemAbility(
    keyword: 'Cleave',
    description:
        'Hits every enemy model adjacent to the attacker in a single swing.',
  ),
  ItemAbility(
    keyword: 'First Strike',
    description:
        'When defending, this weapon strikes before the attacker\'s damage resolves.',
  ),
  ItemAbility(
    keyword: 'Reach',
    description:
        'Can attack targets N squares away in melee, bypassing adjacent models.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Entangling',
    description:
        'On a successful hit, the target\'s movement is halved until they free themselves.',
  ),
  ItemAbility(
    keyword: 'Disarm',
    description:
        'On a hit, force the target to drop N equipped items until end of round.',
    maxValue: 3,
  ),
  ItemAbility(
    keyword: 'Poison',
    description:
        'On a hit, the target gains a Poisoned token and takes ongoing damage each turn.',
  ),
  ItemAbility(
    keyword: 'Burning',
    description:
        'On a hit, the target gains a Burning token and takes fire damage each turn.',
  ),
  ItemAbility(
    keyword: 'Stun',
    description: 'On a hit, the target loses their next action.',
  ),
  ItemAbility(
    keyword: 'Terrifying',
    description:
        'Nearby enemies must pass a courage check or suffer a penalty to all their actions.',
  ),
  ItemAbility(
    keyword: 'Frenzy',
    description:
        'Gain N extra combat dice, but you must target the nearest enemy model.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Blast',
    description:
        'Area-effect attack. Hits all targets within N squares of the impact point.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Ignore Armour',
    description: 'Attacks completely bypass the target\'s armour protection.',
  ),
  ItemAbility(
    keyword: 'Hawkeye',
    description:
        'Grants a bonus to ranged accuracy or increases the weapon\'s effective range.',
  ),

  // ── Defensive / Reactive ────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Parry',
    description:
        'When defending, roll extra dice to cancel incoming hits before armour saves.',
  ),
  ItemAbility(
    keyword: 'Retaliation',
    description:
        'When you are hit, you may immediately make a free counter-attack against the attacker.',
  ),
  ItemAbility(
    keyword: 'Balanced',
    description: 'Provides a free re-roll on one attack die per activation.',
  ),
  ItemAbility(
    keyword: 'Re-roll',
    description: 'Allows re-rolling one or more dice on an attack or defence roll.',
  ),
  ItemAbility(
    keyword: 'Defensive Re-roll',
    description:
        'Allows re-rolling one or more defensive dice when targeted by an attack.',
  ),
  ItemAbility(
    keyword: 'Reflexes',
    description: 'Grants a bonus of N to defensive reactions and dodge attempts.',
    maxValue: 3,
  ),
  ItemAbility(
    keyword: 'Steady',
    description:
        'Grants a bonus of N against knockback, pushes, and forced movement effects.',
    maxValue: 3,
  ),
  ItemAbility(
    keyword: 'Armour',
    description: 'Provides N points of physical armour protection against attacks.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Magical Armour',
    description:
        'Provides N points of armour protection that works against both physical and magical attacks.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Impervious',
    description:
        'Provides N damage reduction that cannot be bypassed by Sharp or Bludgeoning.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Immune',
    description:
        'Provides immunity to a specific attack type or condition (stated after keyword).',
  ),
  ItemAbility(
    keyword: 'Immunity',
    description:
        'Provides immunity to a specific attack type or condition (stated after keyword).',
  ),

  // ── Special effects ─────────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Vampiric',
    description:
        'Restore one or more pegs (health, magic, or skill as noted) for each successful hit.',
  ),
  ItemAbility(
    keyword: 'Volatile',
    description:
        'Roll a die when using; on a bad result the user is also affected by the weapon\'s effect.',
  ),
  ItemAbility(
    keyword: 'Indestructable',
    description:
        'This item cannot be permanently destroyed, discarded, or lost during play.',
  ),
  ItemAbility(
    keyword: 'Regen',
    description:
        'Regenerate N pegs per rest action. The type of peg (health, magic, skill) is stated.',
    maxValue: 5,
  ),

  // ── Item properties ──────────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Preparation',
    description:
        'Requires one or more preparation actions before this weapon can be used.',
  ),
  ItemAbility(
    keyword: 'Effortless',
    description: 'Costs fewer actions than a standard attack to use.',
  ),
  ItemAbility(
    keyword: 'Cumbersome',
    description:
        'Unwieldy — may impose a movement penalty or require additional effort.',
  ),
  ItemAbility(
    keyword: 'Loud',
    description:
        'Using this item triggers a noise check, potentially alerting nearby enemies.',
  ),
  ItemAbility(
    keyword: 'Unreliable',
    description:
        'Roll a die before use; on a failure result the item does not function this activation.',
  ),
  ItemAbility(
    keyword: 'Discard',
    description: 'Single use. The item is discarded after being used once.',
  ),
  ItemAbility(
    keyword: 'Light',
    description:
        'Emits light, removing darkness penalties in the surrounding area.',
  ),
  ItemAbility(
    keyword: 'Plunderer',
    description:
        'Gain additional loot or resources when defeating enemies with this weapon.',
  ),
  ItemAbility(
    keyword: 'Relentless',
    description:
        'Can be used repeatedly without the usual penalties for sustained combat.',
  ),

  // ── Magic ────────────────────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Channel',
    description:
        'Spend magic pegs to activate an enhanced or special effect (stated after keyword).',
  ),
  ItemAbility(
    keyword: 'Spell',
    description: 'Allows casting of the named spell as an action.',
  ),
  ItemAbility(
    keyword: 'Forbidden Channel',
    description:
        'A powerful forbidden magical channel ability. Grants great power but with dark consequences.',
  ),
  ItemAbility(
    keyword: 'Forbidden Arts',
    description:
        'Access to forbidden magical arts — powerful abilities with significant dark-side consequences.',
  ),
  ItemAbility(
    keyword: 'Malacyte Enchantment',
    description:
        'A magical Malacyte enhancement that improves the weapon\'s combat effectiveness.',
  ),
  ItemAbility(
    keyword: 'Malacyte Stability',
    description:
        'Provides magical Malacyte stability, resisting conditions and knockback effects.',
  ),

  // ── Skills / Social ───────────────────────────────────────────────────────────
  ItemAbility(
    keyword: 'Camouflage',
    description:
        'Grants a bonus of N to stealth checks; enemies are less likely to detect you.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Intimidating',
    description:
        'Nearby enemies must make courage checks at difficulty N or be affected by fear.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Ambush',
    description:
        'Grants a bonus of N when attacking enemies that are unaware of your presence.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Inspiring',
    description: 'Nearby allies gain a bonus of N to their actions and checks.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Tracking',
    description:
        'Grants a bonus of N to tracking and investigation skill checks.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Persuasion',
    description:
        'Grants a bonus of N to persuasion and social interaction checks.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Purification',
    description:
        'Remove N negative status effects from yourself or a nearby ally.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Night Sight',
    description:
        'Removes all penalties from fighting or moving in areas of darkness.',
  ),
  ItemAbility(
    keyword: 'Fortified Mind',
    description:
        'Grants a bonus of N to resist mental attacks and magical influence.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Natural Remedies',
    description:
        'Knowledge of natural healing; grants a bonus of N to healing and recovery.',
    maxValue: 5,
  ),
  ItemAbility(
    keyword: 'Refract',
    description:
        'Reflects or deflects magical attacks back towards the attacker.',
  ),
  ItemAbility(
    keyword: 'Distraction',
    description:
        'Reduces an enemy\'s effectiveness for N turns through feints or misdirection.',
    maxValue: 3,
  ),
  ItemAbility(
    keyword: 'Unarmed',
    description: 'Enhances unarmed combat ability by the stated amount.',
  ),
  ItemAbility(
    keyword: 'Hawkeye',
    description:
        'Grants a bonus to ranged accuracy or increases effective range.',
  ),
  ItemAbility(
    keyword: 'Smithing',
    description:
        'Proficiency with smithing; can repair or modify items during a rest.',
    maxValue: 3,
  ),
  ItemAbility(
    keyword: 'Entertainer',
    description:
        'Grants a bonus of N to performance-based social interactions.',
    maxValue: 3,
  ),
  ItemAbility(
    keyword: 'One with Nature',
    description:
        'Bonuses to wilderness survival and interactions with natural environments.',
  ),
  ItemAbility(
    keyword: 'Summoning',
    description: 'Allows summoning of the named companion or creature.',
  ),
  ItemAbility(
    keyword: 'Ammo',
    description: 'Functions as ammunition to enhance ranged weapon attacks.',
  ),
  ItemAbility(
    keyword: 'Rough Ground',
    description:
        'Modifies movement or combat penalty amounts when on rough terrain.',
  ),
];

/// Fast lookup map from keyword → ability.
final Map<String, ItemAbility> kAbilityByKeyword = {
  for (final a in kItemAbilities) a.keyword: a,
};

/// Parses a comma-separated description string into (raw token, matched ability)
/// pairs. Tokens that don't match any known keyword still appear — with a null
/// ability — so they are always shown.
List<(String token, ItemAbility? ability)> parseAbilityTokens(
    String description) {
  return description
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .map((token) => (token, _matchAbility(token)))
      .toList();
}

ItemAbility? _matchAbility(String token) {
  // Exact match first (handles multi-word keywords like "Magical Armour").
  final exact = kAbilityByKeyword[token];
  if (exact != null) return exact;

  final parts = token.split(' ');

  // Two-word match: "Ignore Armour 1" → keyword "Ignore Armour".
  if (parts.length >= 2) {
    final two = '${parts[0]} ${parts[1]}';
    final m = kAbilityByKeyword[two];
    if (m != null) return m;
  }

  // One-word match: "Combat 2" → keyword "Combat".
  return kAbilityByKeyword[parts[0]];
}

/// Subset of abilities shown as selectable chips in the custom item form.
/// Split into boolean (toggle) and numeric (stepped value) groups.
const List<String> kFormBooleanAbilities = [
  'Burst', 'Sharp', 'Bludgeoning', 'Quickstrike', 'Balanced', 'Parry',
  'Vicious', 'Cleave', 'First Strike', 'Entangling', 'Retaliation',
  'Poison', 'Burning', 'Stun', 'Terrifying', 'Volatile', 'Re-roll',
  'Effortless', 'Cumbersome', 'Preparation', 'Loud', 'Unreliable',
  'Discard', 'Indestructable', 'Light', 'Ignore Armour', 'Hawkeye',
  'Plunderer', 'Relentless', 'Night Sight', 'Vampiric', 'Refract',
];

const List<String> kFormNumericAbilities = [
  'Reach', 'Disarm', 'Frenzy', 'Blast', 'Armour', 'Magical Armour',
  'Camouflage', 'Intimidating', 'Reflexes', 'Steady', 'Tracking',
  'Purification', 'Ambush', 'Inspiring', 'Regen', 'Persuasion',
  'Impervious', 'Fortified Mind',
];
