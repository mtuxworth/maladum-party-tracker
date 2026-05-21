import 'enums.dart';

// 2 visual gear slots, each representing 2 actual slot-units (total 4).
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

  // ID of the originating CatalogItem, null for custom items.
  final String? catalogId;

  // Comma-separated ability string, e.g. "Combat 2, Sharp, Burst".
  // Populated from the catalog for catalog items; set by the user for custom items.
  final String description;

  // Guilder prices from the catalog. Null = not listed; 'X' or '4D6' = special.
  final String? buyPrice;
  final String? sellPrice;

  const EquipmentItem({
    required this.id,
    required this.name,
    required this.color,
    required this.rarity,
    required this.slots,
    this.isInnate = false,
    this.catalogId,
    this.description = '',
    this.buyPrice,
    this.sellPrice,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color.name,
        'rarity': rarity.name,
        'slots': slots,
        'isInnate': isInnate,
        if (catalogId != null) 'catalogId': catalogId,
        if (description.isNotEmpty) 'description': description,
        if (buyPrice != null) 'buyPrice': buyPrice,
        if (sellPrice != null) 'sellPrice': sellPrice,
      };

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
        id: json['id'] as String,
        name: json['name'] as String,
        color: ItemColor.values.byName(json['color'] as String),
        rarity: Rarity.values.byName(json['rarity'] as String),
        slots: json['slots'] as int,
        isInnate: json['isInnate'] as bool? ?? false,
        catalogId: json['catalogId'] as String?,
        description: json['description'] as String? ?? '',
        buyPrice: json['buyPrice'] as String?,
        sellPrice: json['sellPrice'] as String?,
      );
}
