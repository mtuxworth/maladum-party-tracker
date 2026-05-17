import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/adventurer.dart';
import '../models/party_state.dart';
import 'adventurer_notifier.dart';
import 'party_notifier.dart';

final partyProvider = NotifierProvider<PartyNotifier, PartyState>(
  PartyNotifier.new,
);

final adventurerProvider = NotifierProvider.autoDispose
    .family<AdventurerNotifier, Adventurer, String>(
  AdventurerNotifier.new,
);
