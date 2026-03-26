import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:second_hand_electronics_marketplace/features/listing/data/models/add_listing_draft.dart';

class ListingDraftStorage {
  static const String _fileName = 'listing_draft.json';

  Future<File> _getDraftFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<AddListingDraft?> readDraft() async {
    try {
      final file = await _getDraftFile();
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      if (content.trim().isEmpty) return null;
      final map = jsonDecode(content) as Map<String, dynamic>;
      return AddListingDraft.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeDraft(AddListingDraft draft) async {
    final file = await _getDraftFile();
    final payload = jsonEncode(draft.toMap());
    await file.writeAsString(payload, flush: true);
  }

  Future<void> clearDraft() async {
    try {
      final file = await _getDraftFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
