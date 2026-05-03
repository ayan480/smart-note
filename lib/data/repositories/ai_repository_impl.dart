import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/ai_suggestion.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/remote/ai_service.dart';
import 'package:uuid/uuid.dart';

/// Implementation of AIRepository
class AIRepositoryImpl implements AIRepository {
  final AIService aiService;
  final Uuid _uuid = const Uuid();

  AIRepositoryImpl({required this.aiService});

  @override
  Future<Either<Failure, List<AISuggestion>>> getSuggestions({
    required String noteContent,
    required String context,
  }) async {
    try {
      // Get text completions as suggestions
      final completions = await aiService.getTextCompletions(noteContent);

      final suggestions = completions.map((completion) {
        return AISuggestion(
          id: _uuid.v4(),
          content: completion,
          type: SuggestionType.completion,
          confidence: 0.8,
          createdAt: DateTime.now(),
        );
      }).toList();

      return Right(suggestions);
    } catch (e) {
      return Left(AIFailure('Failed to get suggestions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> getAIHelp({
    required String query,
    required String noteContext,
  }) async {
    try {
      // Use AI service to get help based on query
      final response = await aiService.summarizeContent(
        'Query: $query\nContext: $noteContext',
      );
      return Right(response);
    } catch (e) {
      return Left(AIFailure('Failed to get AI help: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AISuggestion>>> analyzeBehavior({
    required List<String> recentNotes,
    required Map<String, dynamic> userPatterns,
  }) async {
    try {
      final notesData = recentNotes.asMap().entries.map((entry) {
        return {
          'id': entry.key.toString(),
          'title': 'Note ${entry.key}',
          'content': entry.value,
        };
      }).toList();

      final insights = await aiService.generateInsights(
        notesData,
        userPatterns,
      );

      final suggestions = <AISuggestion>[];

      // Convert insights to suggestions
      if (insights['suggestions'] != null) {
        for (final suggestion in insights['suggestions'] as List) {
          suggestions.add(
            AISuggestion(
              id: _uuid.v4(),
              content: suggestion.toString(),
              type: SuggestionType.action,
              confidence: 0.7,
              createdAt: DateTime.now(),
            ),
          );
        }
      }

      return Right(suggestions);
    } catch (e) {
      return Left(AIFailure('Failed to analyze behavior: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> completeText({
    required String partialText,
    required String context,
  }) async {
    try {
      final completions = await aiService.getTextCompletions(partialText);
      return Right(completions.isNotEmpty ? completions.first : '');
    } catch (e) {
      return Left(AIFailure('Failed to complete text: ${e.toString()}'));
    }
  }

  /// Generate smart title for note content
  Future<Either<Failure, String>> generateTitle(String content) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      // Only use first 500 characters to save costs
      final truncated = content.length > 500
          ? content.substring(0, 500)
          : content;

      final title = await aiService.generateTitle(truncated);
      return Right(title);
    } catch (e) {
      return Left(AIFailure('Failed to generate title: ${e.toString()}'));
    }
  }

  /// Generate tags for note content
  Future<Either<Failure, List<String>>> generateTags(
    String content,
    List<String> existingTags,
  ) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final tags = await aiService.generateTags(content, existingTags);
      return Right(tags);
    } catch (e) {
      return Left(AIFailure('Failed to generate tags: ${e.toString()}'));
    }
  }

  /// Extract action items from content
  Future<Either<Failure, List<Map<String, dynamic>>>> extractActionItems(
    String content,
  ) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final items = await aiService.extractActionItems(content);
      return Right(items);
    } catch (e) {
      return Left(AIFailure('Failed to extract action items: ${e.toString()}'));
    }
  }

  /// Summarize note content
  Future<Either<Failure, String>> summarizeContent(String content) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final summary = await aiService.summarizeContent(content);
      return Right(summary);
    } catch (e) {
      return Left(AIFailure('Failed to summarize content: ${e.toString()}'));
    }
  }

  /// Perform semantic search
  Future<Either<Failure, List<String>>> semanticSearch(
    String query,
    List<Map<String, String>> notes,
  ) async {
    try {
      if (query.trim().isEmpty) {
        return const Left(ValidationFailure('Query is empty'));
      }

      final noteIds = await aiService.semanticSearch(query, notes);
      return Right(noteIds);
    } catch (e) {
      return Left(
        AIFailure('Failed to perform semantic search: ${e.toString()}'),
      );
    }
  }

  /// Analyze writing
  Future<Either<Failure, Map<String, dynamic>>> analyzeWriting(
    String content,
  ) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final analysis = await aiService.analyzeWriting(content);
      return Right(analysis);
    } catch (e) {
      return Left(AIFailure('Failed to analyze writing: ${e.toString()}'));
    }
  }

  /// Suggest smart reminders
  Future<Either<Failure, List<Map<String, dynamic>>>> suggestReminders(
    String content,
  ) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final reminders = await aiService.suggestReminders(content);
      return Right(reminders);
    } catch (e) {
      return Left(AIFailure('Failed to suggest reminders: ${e.toString()}'));
    }
  }

  /// Find related notes
  Future<Either<Failure, List<String>>> findRelatedNotes(
    String currentNoteId,
    String currentContent,
    List<Map<String, String>> allNotes,
  ) async {
    try {
      if (currentContent.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final relatedIds = await aiService.findRelatedNotes(
        currentNoteId,
        currentContent,
        allNotes,
      );
      return Right(relatedIds);
    } catch (e) {
      return Left(AIFailure('Failed to find related notes: ${e.toString()}'));
    }
  }

  /// Generate productivity insights
  Future<Either<Failure, Map<String, dynamic>>> generateInsights(
    List<Map<String, dynamic>> notes,
    Map<String, dynamic> userPatterns,
  ) async {
    try {
      final insights = await aiService.generateInsights(notes, userPatterns);
      return Right(insights);
    } catch (e) {
      return Left(AIFailure('Failed to generate insights: ${e.toString()}'));
    }
  }

  /// Correct grammar and spelling
  Future<Either<Failure, String>> correctGrammarAndSpelling(
    String content,
  ) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final corrected = await aiService.correctGrammarAndSpelling(content);
      return Right(corrected);
    } catch (e) {
      return Left(AIFailure('Failed to correct grammar: ${e.toString()}'));
    }
  }

  /// Apply smart formatting
  Future<Either<Failure, String>> applySmartFormatting(String content) async {
    try {
      if (content.trim().isEmpty) {
        return const Left(ValidationFailure('Content is empty'));
      }

      final formatted = await aiService.applySmartFormatting(content);
      return Right(formatted);
    } catch (e) {
      return Left(AIFailure('Failed to apply formatting: ${e.toString()}'));
    }
  }

  /// Generate meeting notes
  Future<Either<Failure, Map<String, dynamic>>> generateMeetingNotes(
    String transcript,
  ) async {
    try {
      if (transcript.trim().isEmpty) {
        return const Left(ValidationFailure('Transcript is empty'));
      }

      final notes = await aiService.generateMeetingNotes(transcript);
      return Right(notes);
    } catch (e) {
      return Left(
        AIFailure('Failed to generate meeting notes: ${e.toString()}'),
      );
    }
  }
}
