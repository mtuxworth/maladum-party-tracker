import 'dart:math';

enum AdventurerOutcome { survived, died, leftBehind }

class QuestParticipant {
  final String id;
  final String name;

  const QuestParticipant({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory QuestParticipant.fromJson(Map<String, dynamic> j) =>
      QuestParticipant(
        id: j['id'] as String,
        name: j['name'] as String,
      );
}

class QuestLogEntry {
  final String id;
  final String questName;
  final String? campaignQuestId;
  final bool isRescueMission;
  final List<QuestParticipant> party;
  // adventurerId → outcome; defaults to survived for anyone not listed.
  final Map<String, AdventurerOutcome> outcomes;
  final DateTime timestamp;

  const QuestLogEntry({
    required this.id,
    required this.questName,
    this.campaignQuestId,
    this.isRescueMission = false,
    required this.party,
    required this.outcomes,
    required this.timestamp,
  });

  // Convenience views.
  List<QuestParticipant> get survived => party
      .where((p) =>
          (outcomes[p.id] ?? AdventurerOutcome.survived) ==
          AdventurerOutcome.survived)
      .toList();

  List<QuestParticipant> get leftBehind => party
      .where((p) => outcomes[p.id] == AdventurerOutcome.leftBehind)
      .toList();

  List<QuestParticipant> get died =>
      party.where((p) => outcomes[p.id] == AdventurerOutcome.died).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'questName': questName,
        if (campaignQuestId != null) 'campaignQuestId': campaignQuestId,
        'isRescueMission': isRescueMission,
        'party': party.map((p) => p.toJson()).toList(),
        'outcomes': outcomes.map((k, v) => MapEntry(k, v.name)),
        'timestamp': timestamp.toIso8601String(),
      };

  factory QuestLogEntry.fromJson(Map<String, dynamic> j) => QuestLogEntry(
        id: j['id'] as String,
        questName: j['questName'] as String,
        campaignQuestId: j['campaignQuestId'] as String?,
        isRescueMission: j['isRescueMission'] as bool? ?? false,
        party: (j['party'] as List)
            .map((p) => QuestParticipant.fromJson(p as Map<String, dynamic>))
            .toList(),
        outcomes: (j['outcomes'] as Map<String, dynamic>).map(
          (k, v) =>
              MapEntry(k, AdventurerOutcome.values.byName(v as String)),
        ),
        timestamp: DateTime.parse(j['timestamp'] as String),
      );

  static String generateId() {
    final rand = Random();
    return List.generate(8, (_) => rand.nextInt(16).toRadixString(16)).join();
  }
}
