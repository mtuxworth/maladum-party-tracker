import 'adventurer.dart';

const int maxPartySize = 4;

class PartyState {
  String name;
  List<Adventurer> adventurers;

  PartyState({required this.name, List<Adventurer>? adventurers})
      : adventurers = adventurers ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'adventurers': adventurers.map((a) => a.toJson()).toList(),
      };

  factory PartyState.fromJson(Map<String, dynamic> json) => PartyState(
        name: json['name'] as String,
        adventurers: (json['adventurers'] as List)
            .map((a) => Adventurer.fromJson(a as Map<String, dynamic>))
            .toList(),
      );
}
