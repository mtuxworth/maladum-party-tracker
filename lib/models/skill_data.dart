import 'skill.dart';

const List<Skill> kAllSkills = [
  // ── Maladaar ─────────────────────────────────────────────────────────────
  Skill(
    id: 'mld_shadow_strike',
    name: 'Shadow Strike',
    tier: 1,
    characterClass: 'Maladaar',
    description: 'A swift strike from the shadows. Costs 1 Skill Peg.',
  ),
  Skill(
    id: 'mld_fade',
    name: 'Fade',
    tier: 1,
    characterClass: 'Maladaar',
    description: 'Melt into the darkness and avoid the next attack.',
  ),
  Skill(
    id: 'mld_death_blow',
    name: 'Death Blow',
    tier: 2,
    characterClass: 'Maladaar',
    description: 'A finishing strike that deals double damage. Costs 1 Skill Peg.',
    prerequisiteId: 'mld_shadow_strike',
  ),
  Skill(
    id: 'mld_phantom_step',
    name: 'Phantom Step',
    tier: 2,
    characterClass: 'Maladaar',
    description: 'Move through enemies undetected. Costs 1 Skill Peg.',
    prerequisiteId: 'mld_fade',
  ),

  // ── Berserker ─────────────────────────────────────────────────────────────
  Skill(
    id: 'ber_rage',
    name: 'Rage',
    tier: 1,
    characterClass: 'Berserker',
    description: 'Channel fury into your next attack. Costs 1 Skill Peg.',
  ),
  Skill(
    id: 'ber_iron_hide',
    name: 'Iron Hide',
    tier: 1,
    characterClass: 'Berserker',
    description: 'Toughen your skin to shrug off a blow.',
  ),
  Skill(
    id: 'ber_rampage',
    name: 'Rampage',
    tier: 2,
    characterClass: 'Berserker',
    description: 'Charge through enemies in a devastating sweep. Costs 1 Skill Peg.',
    prerequisiteId: 'ber_rage',
  ),
  Skill(
    id: 'ber_fortress',
    name: 'Fortress',
    tier: 2,
    characterClass: 'Berserker',
    description: 'Become immovable; reduce all incoming damage this turn.',
    prerequisiteId: 'ber_iron_hide',
  ),
];
