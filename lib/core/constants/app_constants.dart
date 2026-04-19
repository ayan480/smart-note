class AppConstants {
  // Database
  static const String databaseName = 'smart_note.db';
  static const int databaseVersion = 1;

  // Reminder intervals (in minutes)
  static const int reminder5Min = 5;
  static const int reminder15Min = 15;
  static const int reminder30Min = 30;
  static const int reminder1Hour = 60;
  static const int reminder1Day = 1440;

  // AI
  static const String aiModelName = 'gemini-pro';
  static const int aiMaxTokens = 1000;

  // File limits
  static const int maxAttachmentSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
  ];
  static const List<String> supportedDocFormats = ['pdf', 'doc', 'docx', 'txt'];

  // Voice
  static const Duration voiceRecordingMaxDuration = Duration(minutes: 30);

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double borderRadius = 12.0;
  static const double spacing = 16.0;
}
