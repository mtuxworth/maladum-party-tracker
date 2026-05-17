// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:async';
import 'dart:convert';

import '../models/party_state.dart';

/// Triggers a browser download of the party state as a JSON file.
void exportPartyToFile(PartyState party) {
  final json = jsonEncode(party.toJson());
  final blob = html.Blob([json], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final filename = '${party.name.replaceAll(' ', '_')}_party.json';

  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  html.Url.revokeObjectUrl(url);
}

/// Opens a file picker and returns the parsed [PartyState], or null on
/// cancel or parse failure.
Future<PartyState?> importPartyFromFile() {
  final completer = Completer<PartyState?>();
  final input = html.FileUploadInputElement()..accept = '.json';

  input.onChange.listen((_) {
    final file = input.files?.first;
    if (file == null) {
      completer.complete(null);
      return;
    }

    final reader = html.FileReader();

    reader.onLoad.listen((_) {
      input.remove();
      try {
        final decoded =
            jsonDecode(reader.result as String) as Map<String, dynamic>;
        completer.complete(PartyState.fromJson(decoded));
      } catch (_) {
        completer.complete(null);
      }
    });

    reader.onError.listen((_) {
      input.remove();
      completer.complete(null);
    });

    reader.readAsText(file);
  });

  html.document.body!.append(input);
  input.click();

  return completer.future;
}
