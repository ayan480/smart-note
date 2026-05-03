import 'package:equatable/equatable.dart';

/// Base class for AI events
abstract class AIEvent extends Equatable {
  const AIEvent();

  @override
  List<Object?> get props => [];
}

/// Event to generate title
class GenerateTitleEvent extends AIEvent {
  final String content;

  const GenerateTitleEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to generate tags
class GenerateTagsEvent extends AIEvent {
  final String content;
  final List<String> existingTags;

  const GenerateTagsEvent(this.content, this.existingTags);

  @override
  List<Object> get props => [content, existingTags];
}

/// Event to get text completion
class GetTextCompletionEvent extends AIEvent {
  final String currentText;

  const GetTextCompletionEvent(this.currentText);

  @override
  List<Object> get props => [currentText];
}

/// Event to extract action items
class ExtractActionItemsEvent extends AIEvent {
  final String content;

  const ExtractActionItemsEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to summarize content
class SummarizeContentEvent extends AIEvent {
  final String content;

  const SummarizeContentEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to analyze writing
class AnalyzeWritingEvent extends AIEvent {
  final String content;

  const AnalyzeWritingEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to suggest reminders
class SuggestRemindersEvent extends AIEvent {
  final String content;

  const SuggestRemindersEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to find related notes
class FindRelatedNotesEvent extends AIEvent {
  final String currentNoteId;
  final String currentContent;
  final List<Map<String, String>> allNotes;

  const FindRelatedNotesEvent(
    this.currentNoteId,
    this.currentContent,
    this.allNotes,
  );

  @override
  List<Object> get props => [currentNoteId, currentContent, allNotes];
}

/// Event to generate insights
class GenerateInsightsEvent extends AIEvent {
  final List<Map<String, dynamic>> notes;
  final Map<String, dynamic> userPatterns;

  const GenerateInsightsEvent(this.notes, this.userPatterns);

  @override
  List<Object> get props => [notes, userPatterns];
}

/// Event to correct grammar
class CorrectGrammarEvent extends AIEvent {
  final String content;

  const CorrectGrammarEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to apply smart formatting
class ApplySmartFormattingEvent extends AIEvent {
  final String content;

  const ApplySmartFormattingEvent(this.content);

  @override
  List<Object> get props => [content];
}

/// Event to generate meeting notes
class GenerateMeetingNotesEvent extends AIEvent {
  final String transcript;

  const GenerateMeetingNotesEvent(this.transcript);

  @override
  List<Object> get props => [transcript];
}

/// Event to perform semantic search
class SemanticSearchEvent extends AIEvent {
  final String query;
  final List<Map<String, String>> notes;

  const SemanticSearchEvent(this.query, this.notes);

  @override
  List<Object> get props => [query, notes];
}

/// Event to reset AI state
class ResetAIEvent extends AIEvent {
  const ResetAIEvent();
}
