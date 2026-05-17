import 'enums.dart';

const int maxGearSlots = 4;
const int maxPackSlots = 10;

class EquipmentItem {
  final String id;
  final String name;
  final ItemColor color;
  final Rarity rarity;

  // Volume this item occupies: 1–2 in gear zone, 1–4 in pack.
  final int slots;

  // Soft-locked in a gear slot; only armour (yellow) may overwrite it.
  final bool isInnate;

  const EquipmentItem({
    required this.id,
    required this.name,
    required this.color,
    required this.rarity,
    required this.slots,
    this.isInnate = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color.name,
        'rarity': rarity.name,
        'slots': slots,
        'isInnate': isInnate,
      };

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
        id: json['id'] as String,
        name: json['name'] as String,
        color: ItemColor.values.byName(json['color'] as String),
        rarity: Rarity.values.byName(json['rarity'] as String),
        slots: json['slots'] as int,
        isInnate: json['isInnate'] as bool? ?? false,
      );
}
