import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/ai_suggestion.dart';

/// Repository interface for AI operations
abstract class AIRepository {
  /// Get AI suggestions based on current note content
  Future<Either<Failure, List<AISuggestion>>> getSuggestions({
    required String noteContent,
    required String context,
  });

  /// Get AI help for a specific query
  Future<Either<Failure, String>> getAIHelp({
    required String query,
    required String noteContext,
  });

  /// Analyze user behavior and provide suggestions
  Future<Either<Failure, List<AISuggestion>>> analyzeBehavior({
    required List<String> recentNotes,
    required Map<String, dynamic> userPatterns,
  });

  /// Complete text based on context
  Future<Either<Failure, String>> completeText({
    required String partialText,
    required String context,
  });
}
