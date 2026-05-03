import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/ai/analyze_writing.dart';
import '../../../domain/usecases/ai/apply_smart_formatting.dart';
import '../../../domain/usecases/ai/correct_grammar.dart';
import '../../../domain/usecases/ai/extract_action_items.dart';
import '../../../domain/usecases/ai/find_related_notes.dart';
import '../../../domain/usecases/ai/generate_insights.dart';
import '../../../domain/usecases/ai/generate_meeting_notes.dart';
import '../../../domain/usecases/ai/generate_tags.dart';
import '../../../domain/usecases/ai/generate_title.dart';
import '../../../domain/usecases/ai/get_text_completion.dart';
import '../../../domain/usecases/ai/semantic_search.dart';
import '../../../domain/usecases/ai/suggest_reminders.dart';
import '../../../domain/usecases/ai/summarize_content.dart';
import 'ai_event.dart';
import 'ai_state.dart';

/// BLoC for AI features
class AIBloc extends Bloc<AIEvent, AIState> {
  final GenerateTitle generateTitle;
  final GenerateTags generateTags;
  final GetTextCompletion getTextCompletion;
  final ExtractActionItems extractActionItems;
  final SummarizeContent summarizeContent;
  final AnalyzeWriting analyzeWriting;
  final SuggestReminders suggestReminders;
  final FindRelatedNotes findRelatedNotes;
  final GenerateInsights generateInsights;
  final CorrectGrammar correctGrammar;
  final ApplySmartFormatting applySmartFormatting;
  final GenerateMeetingNotes generateMeetingNotes;
  final SemanticSearch semanticSearch;

  AIBloc({
    required this.generateTitle,
    required this.generateTags,
    required this.getTextCompletion,
    required this.extractActionItems,
    required this.summarizeContent,
    required this.analyzeWriting,
    required this.suggestReminders,
    required this.findRelatedNotes,
    required this.generateInsights,
    required this.correctGrammar,
    required this.applySmartFormatting,
    required this.generateMeetingNotes,
    required this.semanticSearch,
  }) : super(const AIInitial()) {
    on<GenerateTitleEvent>(_onGenerateTitle);
    on<GenerateTagsEvent>(_onGenerateTags);
    on<GetTextCompletionEvent>(_onGetTextCompletion);
    on<ExtractActionItemsEvent>(_onExtractActionItems);
    on<SummarizeContentEvent>(_onSummarizeContent);
    on<AnalyzeWritingEvent>(_onAnalyzeWriting);
    on<SuggestRemindersEvent>(_onSuggestReminders);
    on<FindRelatedNotesEvent>(_onFindRelatedNotes);
    on<GenerateInsightsEvent>(_onGenerateInsights);
    on<CorrectGrammarEvent>(_onCorrectGrammar);
    on<ApplySmartFormattingEvent>(_onApplySmartFormatting);
    on<GenerateMeetingNotesEvent>(_onGenerateMeetingNotes);
    on<SemanticSearchEvent>(_onSemanticSearch);
    on<ResetAIEvent>(_onResetAI);
  }

  Future<void> _onGenerateTitle(
    GenerateTitleEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await generateTitle(
      GenerateTitleParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (title) => emit(TitleGenerated(title)),
    );
  }

  Future<void> _onGenerateTags(
    GenerateTagsEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await generateTags(
      GenerateTagsParams(
        content: event.content,
        existingTags: event.existingTags,
      ),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (tags) => emit(TagsGenerated(tags)),
    );
  }

  Future<void> _onGetTextCompletion(
    GetTextCompletionEvent event,
    Emitter<AIState> emit,
  ) async {
    final result = await getTextCompletion(
      TextCompletionParams(currentText: event.currentText),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (completions) => emit(TextCompletionReady(completions)),
    );
  }

  Future<void> _onExtractActionItems(
    ExtractActionItemsEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await extractActionItems(
      ExtractActionItemsParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (items) => emit(ActionItemsExtracted(items)),
    );
  }

  Future<void> _onSummarizeContent(
    SummarizeContentEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await summarizeContent(
      SummarizeContentParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (summary) => emit(ContentSummarized(summary)),
    );
  }

  Future<void> _onAnalyzeWriting(
    AnalyzeWritingEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await analyzeWriting(
      AnalyzeWritingParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (analysis) => emit(WritingAnalyzed(analysis)),
    );
  }

  Future<void> _onSuggestReminders(
    SuggestRemindersEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await suggestReminders(
      SuggestRemindersParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (reminders) => emit(RemindersSuggested(reminders)),
    );
  }

  Future<void> _onFindRelatedNotes(
    FindRelatedNotesEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await findRelatedNotes(
      FindRelatedNotesParams(
        currentNoteId: event.currentNoteId,
        currentContent: event.currentContent,
        allNotes: event.allNotes,
      ),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (noteIds) => emit(RelatedNotesFound(noteIds)),
    );
  }

  Future<void> _onGenerateInsights(
    GenerateInsightsEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await generateInsights(
      GenerateInsightsParams(
        notes: event.notes,
        userPatterns: event.userPatterns,
      ),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (insights) => emit(InsightsGenerated(insights)),
    );
  }

  Future<void> _onCorrectGrammar(
    CorrectGrammarEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await correctGrammar(
      CorrectGrammarParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (corrected) => emit(GrammarCorrected(corrected)),
    );
  }

  Future<void> _onApplySmartFormatting(
    ApplySmartFormattingEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await applySmartFormatting(
      ApplySmartFormattingParams(content: event.content),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (formatted) => emit(FormattingApplied(formatted)),
    );
  }

  Future<void> _onGenerateMeetingNotes(
    GenerateMeetingNotesEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await generateMeetingNotes(
      GenerateMeetingNotesParams(transcript: event.transcript),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (notes) => emit(MeetingNotesGenerated(notes)),
    );
  }

  Future<void> _onSemanticSearch(
    SemanticSearchEvent event,
    Emitter<AIState> emit,
  ) async {
    emit(const AILoading());
    final result = await semanticSearch(
      SemanticSearchParams(query: event.query, notes: event.notes),
    );
    result.fold(
      (failure) => emit(AIError(failure.message)),
      (noteIds) => emit(SemanticSearchCompleted(noteIds)),
    );
  }

  Future<void> _onResetAI(ResetAIEvent event, Emitter<AIState> emit) async {
    emit(const AIInitial());
  }
}
