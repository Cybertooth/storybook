abstract class AiService {
  /// Returns 3 story continuations for the given seed text.
  Future<List<String>> suggestContinuations(String seed);

  /// Returns critique objects with keys: 'text', 'severity' ("Small"|"Medium"|"Major").
  Future<List<Map<String, dynamic>>> critique(String draft, String context);

  /// Returns a revised draft addressing the given critique strings.
  Future<String> reviseDraft(String draft, List<String> selectedCritiques);

  /// Returns consistency issue objects with keys: 'issue', 'severity', 'suggestion'.
  Future<List<Map<String, dynamic>>> checkPlotHoles(String storyContext);

  /// Returns trope objects with keys: 'trope', 'risk' ("Low"|"Medium"|"High"), 'description', 'suggestion'.
  Future<List<Map<String, dynamic>>> analyzeTropes(String storyContext);

  /// Returns show-don't-tell suggestions with keys: 'original', 'suggestion'.
  Future<List<Map<String, dynamic>>> showDontTell(String prose);

  /// Returns 3 next-sentence continuations given prior text and plot context.
  Future<List<String>> suggestNext(String priorText, String plotContext);

  /// Returns an image URL or null if not supported.
  Future<String?> generatePortrait(String characterDescription);
}
