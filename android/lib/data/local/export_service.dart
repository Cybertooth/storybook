import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants.dart';
import '../../domain/models/story.dart';
import '../../domain/models/character.dart';
import '../../domain/models/location.dart';
import '../../domain/models/plot_event.dart';
import '../../domain/models/chapter.dart';
import '../../domain/models/note.dart';
import '../../domain/models/unresolved_question.dart';
import '../../domain/models/relationship.dart';

class ExportService {
  /// Builds a ProjectBundle JSON matching the web app's export format.
  Map<String, dynamic> buildBundle({
    required Story story,
    required List<Character> characters,
    required List<Location> locations,
    required List<PlotEvent> events,
    required List<Chapter> chapters,
    required List<Note> notes,
    required List<UnresolvedQuestion> questions,
    required List<Relationship> relationships,
  }) {
    return {
      'version': AppConstants.projectBundleVersion,
      'appName': AppConstants.appBundleName,
      'savedAt': DateTime.now().millisecondsSinceEpoch,
      'story': story.toJson(),
      'characters': characters.map((c) => c.toJson()).toList(),
      'locations': locations.map((l) => l.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'chapters': chapters.map((c) => c.toJson()).toList(),
      'notes': notes.map((n) => n.toJson()).toList(),
      'unresolvedQuestions': questions.map((q) => q.toJson()).toList(),
      'relationships': relationships.map((r) => r.toJson()).toList(),
    };
  }

  /// Writes bundle to a temp file and opens the system share sheet.
  Future<void> exportToFile(Map<String, dynamic> bundle) async {
    final json = const JsonEncoder.withIndent('  ').convert(bundle);
    final dir = await getTemporaryDirectory();
    final storyTitle = (bundle['story']['title'] as String)
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final file = File('${dir.path}/${storyTitle}_backup.json');
    await file.writeAsString(json);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Storybook backup: ${bundle['story']['title']}',
    );
  }

  /// Opens a file picker and returns the parsed JSON map, or null if cancelled.
  Future<Map<String, dynamic>?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return null;
    final content = utf8.decode(result.files.single.bytes!);
    final json = jsonDecode(content) as Map<String, dynamic>;
    // Basic validation
    if (json['appName'] != AppConstants.appBundleName) {
      throw const FormatException('Not a valid Storybook backup file.');
    }
    return json;
  }
}
