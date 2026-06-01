enum QuestType { intro, main, interlude, epilogue }

class CampaignQuest {
  final String id;
  final String label; // "Quest A", "Interlude", etc.
  final String name;
  final QuestType type;

  const CampaignQuest({
    required this.id,
    required this.label,
    required this.name,
    required this.type,
  });
}

const List<CampaignQuest> kCampaignQuests = [
  CampaignQuest(
    id: 'intro',
    label: 'Intro',
    name: 'Of Coin and Glory',
    type: QuestType.intro,
  ),
  CampaignQuest(
    id: 'a',
    label: 'Quest A',
    name: 'Secrets in the Dark',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'b',
    label: 'Quest B',
    name: 'The Heirloom',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'c',
    label: 'Quest C',
    name: 'A New Power Rising',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'd',
    label: 'Quest D',
    name: 'Resurrectionists',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'e',
    label: 'Quest E',
    name: 'Eclipse of the Scholars',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'f',
    label: 'Quest F',
    name: 'The Darkness Beneath',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'interlude_1',
    label: 'Interlude',
    name: 'Necrotic Knowledge',
    type: QuestType.interlude,
  ),
  CampaignQuest(
    id: 'g',
    label: 'Quest G',
    name: 'Caverns of the Forsaken',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'h',
    label: 'Quest H',
    name: 'The Exile',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'i',
    label: 'Quest I',
    name: 'Secrets of Cape Feere',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'j',
    label: 'Quest J',
    name: 'Beneath the Manor',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'k',
    label: 'Quest K',
    name: 'Curses Undone',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'l',
    label: 'Quest L',
    name: 'Flight from the Necropolis',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'm',
    label: 'Quest M',
    name: 'Save Our Souls',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'n',
    label: 'Quest N',
    name: 'The Unwilling Apprentice',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'o',
    label: 'Quest O',
    name: 'A Fresh Awakening',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'interlude_2',
    label: 'Interlude',
    name: 'Torches and Pitchforks',
    type: QuestType.interlude,
  ),
  CampaignQuest(
    id: 'p',
    label: 'Quest P',
    name: "Twilight's Gaol",
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'q',
    label: 'Quest Q',
    name: 'The Gloom that Binds Us',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'r',
    label: 'Quest R',
    name: "Undeath's Door",
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 's',
    label: 'Quest S',
    name: "Undeath's Door, Part II",
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 't',
    label: 'Quest T',
    name: 'Heart of Darkness',
    type: QuestType.main,
  ),
  CampaignQuest(
    id: 'epilogue',
    label: 'Epilogue',
    name: '',
    type: QuestType.epilogue,
  ),
];
