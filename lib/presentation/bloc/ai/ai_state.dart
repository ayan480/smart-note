import 'package:equatable/equatable.dart';

/// Base class for AI states
abstract class AIState extends Equatable {
  const AIState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AIInitial extends AIState {
  const AIInitial();
}

/// Loading state
class AILoading extends AIState {
  const AILoading();
}

/// Title generated state
class TitleGenerated extends AIState {
  final String title;

  const TitleGenerated(this.title);

  @override
  List<Object> get props => [title];
}

/// Tags generated state
class TagsGenerated extends AIState {
  final List<String> tags;

  const TagsGenerated(this.tags);

  @override
  List<Object> get props => [tags];
}

/// Text completion state
class TextCompletionReady extends AIState {
  final List<String> completions;

  const TextCompletionReady(this.completions);

  @override
  List<Object> get props => [completions];
}

/// Action items extracted state
class ActionItemsExtracted extends AIState {
  final List<Map<String, dynamic>> actionItems;

  const ActionItemsExtracted(this.actionItems);

  @override
  List<Object> get props => [actionItems];
}

/// Content summarized state
class ContentSummarized extends AIState {
  final String summary;

  const ContentSummarized(this.summary);

  @override
  List<Object> get props => [summary];
}

/// Writing analyzed state
class WritingAnalyzed extends AIState {
  final Map<String, dynamic> analysis;

  const WritingAnalyzed(this.analysis);

  @override
  List<Object> get props => [analysis];
}

/// Reminders suggested state
class RemindersSuggested extends AIState {
  final List<Map<String, dynamic>> reminders;

  const RemindersSuggested(this.reminders);

  @override
  List<Object> get props => [reminders];
}

/// Related notes found state
class RelatedNotesFound extends AIState {
  final List<String> noteIds;

  const RelatedNotesFound(this.noteIds);

  @override
  List<Object> get props => [noteIds];
}

/// Insights generated state
class InsightsGenerated extends AIState {
  final Map<String, dynamic> insights;

  const InsightsGenerated(this.insights);

  @override
  List<Object> get props => [insights];
}

/// Grammar corrected state
class GrammarCorrected extends AIState {
  final String correctedText;

  const GrammarCorrected(this.correctedText);

  @override
  List<Object> get props => [correctedText];
}

/// Formatting applied state
class FormattingApplied extends AIState {
  final String formattedText;

  const FormattingApplied(this.formattedText);

  @override
  List<Object> get props => [formattedText];
}

/// Meeting notes generated state
class MeetingNotesGenerated extends AIState {
  final Map<String, dynamic> meetingNotes;

  const MeetingNotesGenerated(this.meetingNotes);

  @override
  List<Object> get props => [meetingNotes];
}

/// Semantic search completed state
class SemanticSearchCompleted extends AIState {
  final List<String> noteIds;

  const SemanticSearchCompleted(this.noteIds);

  @override
  List<Object> get props => [noteIds];
}

/// Error state
class AIError extends AIState {
  final String message;

  const AIError(this.message);

  @override
  List<Object> get props => [message];
}
