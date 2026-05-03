/// Configuration for AI services
class AIConfig {
  /// Google Gemini API Key
  /// Set via: flutter run --dart-define=GEMINI_API_KEY=your_key
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Check if API key is configured
  static bool get isConfigured => geminiApiKey.isNotEmpty;

  /// Gemini Pro model name (for complex operations)
  static const String geminiProModel = 'gemini-pro';

  /// Gemini Flash model name (for fast, frequent operations)
  static const String geminiFlashModel = 'gemini-1.5-flash';

  /// Maximum content length for title generation (to save costs)
  static const int maxTitleContentLength = 500;

  /// Text completion debounce duration (milliseconds)
  static const int textCompletionDebounceMs = 500;

  /// Minimum text length for completion suggestions
  static const int minTextLengthForCompletion = 10;

  /// Maximum number of completion suggestions
  static const int maxCompletionSuggestions = 3;

  /// Maximum number of tags to generate
  static const int maxTagsToGenerate = 5;

  /// Maximum number of related notes to find
  static const int maxRelatedNotes = 5;

  /// Maximum number of semantic search results
  static const int maxSemanticSearchResults = 5;
}
