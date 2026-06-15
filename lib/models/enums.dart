enum ItemColor { blue, red, yellow, purple, grey }

enum Rarity { common, uncommon, rare, exclusive }

enum ItemSet { base, beasts, adventure, vault }

const Map<ItemSet, String> kItemSetName = {
  ItemSet.base: 'Maladum: Dungeons of Enveron',
  ItemSet.beasts: 'Maladum: Beasts of Enveron',
  ItemSet.adventure: 'Maladum: Of Ale and Adventure',
  ItemSet.vault: 'Maladum: Beyond the Vault',
};

const Map<ItemSet, String> kItemSetShortName = {
  ItemSet.base: 'Base',
  ItemSet.beasts: 'Beasts',
  ItemSet.adventure: 'Adventure',
  ItemSet.vault: 'Vault',
};

enum StatusEffect { blessed, burning, fatigued, poisoned, stunned, terrified, warded, wounded }

enum StatType { health, magic, skill, action }
