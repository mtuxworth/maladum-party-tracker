import 'adventurer.dart';

const int maxPartySize = 4;

class PartyState {
  String name;
  int guilders;
  List<Adventurer> adventurers;

  PartyState({
    required this.name,
    this.guilders = 0,
    List<Adventurer>? adventurers,
  }) : adventurers = adventurers ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'guilders': guilders,
        'adventurers': adventurers.map((a) => a.toJson()).toList(),
      };

  factory PartyState.fromJson(Map<String, dynamic> json) => PartyState(
        name: json['name'] as String,
        guilders: json['guilders'] as int? ?? 0,
        adventurers: (json['adventurers'] as List)
            .map((a) => Adventurer.fromJson(a as Map<String, dynamic>))
            .toList(),
      );
}
