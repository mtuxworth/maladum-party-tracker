import 'adventurer.dart';
import 'adventurer_templates.dart';
import 'character_classes.dart';
import 'maladum_stat.dart';

// Recommended starting party as described in the rulebook.
List<Adventurer> buildRecommendedParty() => [
      _build('callan', 'sellsword', ['mel_weapons_master_1']),
      _build('greet', 'rogue', ['cun_distraction_1', 'ste_duck_for_cover_1']),
      _build('moranna', 'prymorist', []),
      _build('syrio', 'ranger', [
        'ran_ranged_expert_1',
        'end_quick_recovery_1',
        'sur_ready_for_anything_1',
      ]),
    ];

// Total guilder cost for the recommended party (templates + classes).
int recommendedPartyCost() {
  const pairs = [
    ('callan', 'sellsword'),
    ('greet', 'rogue'),
    ('moranna', 'prymorist'),
    ('syrio', 'ranger'),
  ];
  var total = 0;
  for (final (tid, cid) in pairs) {
    final tmpl = kAllTemplates.firstWhere((t) => t.id == tid);
    final cls = kAllClasses.firstWhere((c) => c.id == cid);
    total += tmpl.guilderCost + cls.guilderCost;
  }
  return total;
}

Adventurer _build(
  String templateId,
  String classId,
  List<String> ownedSkillIds,
) {
  final tmpl = kAllTemplates.firstWhere((t) => t.id == templateId);
  return Adventurer(
    name: tmpl.name,
    templateId: tmpl.id,
    characterClass: classId,
    health: MaladumStat(
      starting: tmpl.healthStart,
      potential: tmpl.healthPotential,
    ),
    magic: MaladumStat(
      starting: tmpl.magicStart,
      potential: tmpl.magicPotential,
    ),
    skill: MaladumStat(
      starting: tmpl.skillStart,
      potential: tmpl.skillPotential,
    ),
    action: MaladumStat(
      starting: tmpl.actionStart,
      potential: tmpl.actionPotential,
    ),
    xpPegs: tmpl.startingXp,
    skillPegs: tmpl.skillStart,
    rankXpCosts: List.of(tmpl.rankXpCosts),
    ownedSkillIds: ownedSkillIds,
  );
}
