import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ai/ai_bloc.dart';
import '../bloc/ai/ai_event.dart';
import '../bloc/ai/ai_state.dart';

/// Widget that provides a menu of AI features
class AIFeaturesMenu extends StatelessWidget {
  final String noteContent;
  final Function(String) onTitleGenerated;
  final Function(List<String>) onTagsGenerated;
  final Function(List<Map<String, dynamic>>) onActionItemsExtracted;
  final Function(String) onSummaryGenerated;
  final Function(Map<String, dynamic>) onWritingAnalyzed;
  final Function(String) onGrammarCorrected;
  final Function(String) onFormattingApplied;

  const AIFeaturesMenu({
    super.key,
    required this.noteContent,
    required this.onTitleGenerated,
    required this.onTagsGenerated,
    required this.onActionItemsExtracted,
    required this.onSummaryGenerated,
    required this.onWritingAnalyzed,
    required this.onGrammarCorrected,
    required this.onFormattingApplied,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AIBloc, AIState>(
      listener: (context, state) {
        if (state is TitleGenerated) {
          onTitleGenerated(state.title);
          _showSuccess(context, 'Title generated!');
        } else if (state is TagsGenerated) {
          onTagsGenerated(state.tags);
          _showSuccess(context, '${state.tags.length} tags suggested!');
        } else if (state is ActionItemsExtracted) {
          onActionItemsExtracted(state.actionItems);
          _showSuccess(
            context,
            '${state.actionItems.length} action items found!',
          );
        } else if (state is ContentSummarized) {
          onSummaryGenerated(state.summary);
          _showSummaryDialog(context, state.summary);
        } else if (state is WritingAnalyzed) {
          onWritingAnalyzed(state.analysis);
          _showAnalysisDialog(context, state.analysis);
        } else if (state is GrammarCorrected) {
          onGrammarCorrected(state.correctedText);
          _showSuccess(context, 'Grammar corrected!');
        } else if (state is FormattingApplied) {
          onFormattingApplied(state.formattedText);
          _showSuccess(context, 'Formatting applied!');
        } else if (state is AIError) {
          _showError(context, state.message);
        }
      },
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.auto_awesome),
        tooltip: 'AI Features',
        onSelected: (value) => _handleMenuSelection(context, value),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'generate_title',
            child: ListTile(
              leading: Icon(Icons.title),
              title: Text('Generate Title'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'generate_tags',
            child: ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('Suggest Tags'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'extract_actions',
            child: ListTile(
              leading: Icon(Icons.checklist),
              title: Text('Find Action Items'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'summarize',
            child: ListTile(
              leading: Icon(Icons.summarize),
              title: Text('Summarize'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'analyze_writing',
            child: ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Analyze Writing'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'correct_grammar',
            child: ListTile(
              leading: Icon(Icons.spellcheck),
              title: Text('Check Grammar'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'apply_formatting',
            child: ListTile(
              leading: Icon(Icons.format_paint),
              title: Text('Smart Format'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    if (noteContent.trim().isEmpty) {
      _showError(context, 'Please add some content first');
      return;
    }

    final aiBloc = context.read<AIBloc>();

    switch (value) {
      case 'generate_title':
        aiBloc.add(GenerateTitleEvent(noteContent));
        break;
      case 'generate_tags':
        aiBloc.add(GenerateTagsEvent(noteContent, []));
        break;
      case 'extract_actions':
        aiBloc.add(ExtractActionItemsEvent(noteContent));
        break;
      case 'summarize':
        aiBloc.add(SummarizeContentEvent(noteContent));
        break;
      case 'analyze_writing':
        aiBloc.add(AnalyzeWritingEvent(noteContent));
        break;
      case 'correct_grammar':
        aiBloc.add(CorrectGrammarEvent(noteContent));
        break;
      case 'apply_formatting':
        aiBloc.add(ApplySmartFormattingEvent(noteContent));
        break;
    }
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSummaryDialog(BuildContext context, String summary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Summary'),
        content: Text(summary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAnalysisDialog(
    BuildContext context,
    Map<String, dynamic> analysis,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Writing Analysis'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Readability Score: ${analysis['readability']}/10',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (analysis['grammar'] != null &&
                  (analysis['grammar'] as List).isNotEmpty) ...[
                const Text(
                  'Grammar Issues:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...(analysis['grammar'] as List).map(
                  (issue) => Text('• $issue'),
                ),
                const SizedBox(height: 16),
              ],
              if (analysis['style'] != null &&
                  (analysis['style'] as List).isNotEmpty) ...[
                const Text(
                  'Style Suggestions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...(analysis['style'] as List).map(
                  (suggestion) => Text('• $suggestion'),
                ),
                const SizedBox(height: 16),
              ],
              if (analysis['assessment'] != null) ...[
                const Text(
                  'Overall Assessment:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(analysis['assessment'].toString()),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
