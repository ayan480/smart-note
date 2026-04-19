import 'package:equatable/equatable.dart';

enum SuggestionType { completion, correction, formatting, related, action }

/// AI Suggestion entity for real-time AI assistance
class AISuggestion extends Equatable {
  final String id;
  final String content;
  final SuggestionType type;
  final double confidence;
  final DateTime createdAt;

  const AISuggestion({
    required this.id,
    required this.content,
    required this.type,
    required this.confidence,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, type, confidence, createdAt];
}
