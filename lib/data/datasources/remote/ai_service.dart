import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Service for AI operations using Google Gemini
class AIService {
  final GenerativeModel _model;
  final GenerativeModel _flashModel;

  AIService({required String apiKey})
    : _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey),
      _flashModel = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  /// Generate a smart title from note content
  Future<String> generateTitle(String content) async {
    final prompt =
        '''
Generate a concise, descriptive title (max 50 characters) for this note:

$content

Rules:
- Be specific and descriptive
- Use title case
- No quotes or special characters
- Capture the main topic

Title:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text?.trim() ?? 'Untitled';
  }

  /// Generate tags for note content
  Future<List<String>> generateTags(
    String content,
    List<String> existingTags,
  ) async {
    final prompt =
        '''
Analyze this note and suggest 3-5 relevant tags:

Note: $content

Existing tags in the system: ${existingTags.join(', ')}

Rules:
- Use existing tags when relevant
- Create new tags only if necessary
- Tags should be lowercase, single words or short phrases
- Focus on topics, categories, and key concepts
- Return only the tag names, comma-separated

Tags:''';

    final response = await _flashModel.generateContent([Content.text(prompt)]);
    final tagsText = response.text?.trim() ?? '';

    return tagsText
        .split(',')
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .take(5)
        .toList();
  }

  /// Get text completion suggestions
  Future<List<String>> getTextCompletions(String text) async {
    if (text.length < 10) return [];

    final prompt =
        '''
Given this partial text, suggest 3 natural continuations (3-5 words each):

Text: $text

Rules:
- Suggest 3-5 word completions
- Match the writing style
- Be contextually relevant
- Each suggestion on a new line

Suggestions:''';

    final response = await _flashModel.generateContent([Content.text(prompt)]);
    final suggestions = response.text?.trim().split('\n') ?? [];

    return suggestions
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .take(3)
        .toList();
  }

  /// Extract action items from note content
  Future<List<Map<String, dynamic>>> extractActionItems(String content) async {
    final prompt =
        '''
Extract action items from this note:

$content

For each action item, provide:
1. The task description
2. Priority (high/medium/low)
3. Deadline if mentioned (or "none")

Format as JSON array:
[{"task": "...", "priority": "...", "deadline": "..."}]

JSON:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonText = response.text?.trim() ?? '[]';

    try {
      // Extract JSON from markdown code blocks if present
      String cleanJson = jsonText;
      if (jsonText.contains('```json')) {
        cleanJson = jsonText.split('```json')[1].split('```')[0].trim();
      } else if (jsonText.contains('```')) {
        cleanJson = jsonText.split('```')[1].split('```')[0].trim();
      }

      final List<dynamic> items = jsonDecode(cleanJson);
      return items.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Generate content summary
  Future<String> summarizeContent(String content) async {
    final prompt =
        '''
Summarize this note in 2-3 sentences:

$content

Rules:
- Be concise and clear
- Capture key points
- Use simple language

Summary:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text?.trim() ?? 'Unable to generate summary';
  }

  /// Perform semantic search
  Future<List<String>> semanticSearch(
    String query,
    List<Map<String, String>> notes,
  ) async {
    final notesText = notes
        .map(
          (n) =>
              'ID: ${n['id']}\nTitle: ${n['title']}\nContent: ${n['content']}',
        )
        .join('\n\n---\n\n');

    final prompt =
        '''
Find notes most relevant to this query: "$query"

Available notes:
$notesText

Return only the IDs of the most relevant notes (up to 5), comma-separated.

IDs:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final idsText = response.text?.trim() ?? '';

    return idsText
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();
  }

  /// Analyze writing and provide suggestions
  Future<Map<String, dynamic>> analyzeWriting(String content) async {
    final prompt =
        '''
Analyze this text for grammar, style, and readability:

$content

Provide:
1. Grammar issues (if any)
2. Style suggestions
3. Readability score (1-10)
4. Overall assessment

Format as JSON:
{
  "grammar": ["issue1", "issue2"],
  "style": ["suggestion1", "suggestion2"],
  "readability": 7,
  "assessment": "overall comment"
}

JSON:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonText = response.text?.trim() ?? '{}';

    try {
      String cleanJson = jsonText;
      if (jsonText.contains('```json')) {
        cleanJson = jsonText.split('```json')[1].split('```')[0].trim();
      } else if (jsonText.contains('```')) {
        cleanJson = jsonText.split('```')[1].split('```')[0].trim();
      }

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      return {
        'grammar': [],
        'style': [],
        'readability': 5,
        'assessment': 'Unable to analyze',
      };
    }
  }

  /// Suggest smart reminders based on content
  Future<List<Map<String, dynamic>>> suggestReminders(String content) async {
    final prompt =
        '''
Analyze this note and suggest appropriate reminders:

$content

Look for:
- Dates and times mentioned
- Deadlines
- Events
- Time-sensitive tasks

Format as JSON array:
[{"title": "...", "datetime": "YYYY-MM-DD HH:MM", "reason": "..."}]

JSON:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonText = response.text?.trim() ?? '[]';

    try {
      String cleanJson = jsonText;
      if (jsonText.contains('```json')) {
        cleanJson = jsonText.split('```json')[1].split('```')[0].trim();
      } else if (jsonText.contains('```')) {
        cleanJson = jsonText.split('```')[1].split('```')[0].trim();
      }

      final List<dynamic> items = jsonDecode(cleanJson);
      return items.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Find related notes
  Future<List<String>> findRelatedNotes(
    String currentNoteId,
    String currentContent,
    List<Map<String, String>> allNotes,
  ) async {
    final notesText = allNotes
        .where((n) => n['id'] != currentNoteId)
        .map(
          (n) =>
              'ID: ${n['id']}\nTitle: ${n['title']}\nContent: ${n['content']}',
        )
        .join('\n\n---\n\n');

    final prompt =
        '''
Find notes related to this note:

Current note: $currentContent

Available notes:
$notesText

Return IDs of the most related notes (up to 5), comma-separated.

IDs:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final idsText = response.text?.trim() ?? '';

    return idsText
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();
  }

  /// Generate productivity insights
  Future<Map<String, dynamic>> generateInsights(
    List<Map<String, dynamic>> notes,
    Map<String, dynamic> userPatterns,
  ) async {
    final notesCount = notes.length;
    final recentNotes = notes.take(10).map((n) => n['title']).join(', ');

    final prompt =
        '''
Analyze these note-taking patterns and provide insights:

Total notes: $notesCount
Recent notes: $recentNotes
User patterns: ${jsonEncode(userPatterns)}

Provide:
1. Most productive times
2. Common topics
3. Suggestions for improvement
4. Productivity score (1-10)

Format as JSON:
{
  "productiveTimes": ["morning", "evening"],
  "commonTopics": ["work", "personal"],
  "suggestions": ["suggestion1", "suggestion2"],
  "productivityScore": 7
}

JSON:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonText = response.text?.trim() ?? '{}';

    try {
      String cleanJson = jsonText;
      if (jsonText.contains('```json')) {
        cleanJson = jsonText.split('```json')[1].split('```')[0].trim();
      } else if (jsonText.contains('```')) {
        cleanJson = jsonText.split('```')[1].split('```')[0].trim();
      }

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      return {
        'productiveTimes': [],
        'commonTopics': [],
        'suggestions': [],
        'productivityScore': 5,
      };
    }
  }

  /// Correct grammar and spelling
  Future<String> correctGrammarAndSpelling(String content) async {
    final prompt =
        '''
Correct grammar and spelling in this text:

$content

Return only the corrected text, no explanations.

Corrected text:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text?.trim() ?? content;
  }

  /// Apply smart formatting
  Future<String> applySmartFormatting(String content) async {
    final prompt =
        '''
Apply smart formatting to this text:

$content

Rules:
- Add proper headings
- Format lists
- Add emphasis where appropriate
- Improve structure

Return the formatted text in markdown.

Formatted text:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text?.trim() ?? content;
  }

  /// Generate meeting notes assistant suggestions
  Future<Map<String, dynamic>> generateMeetingNotes(String transcript) async {
    final prompt =
        '''
Analyze this meeting transcript and generate structured notes:

$transcript

Provide:
1. Meeting summary
2. Key points discussed
3. Action items
4. Decisions made
5. Next steps

Format as JSON:
{
  "summary": "...",
  "keyPoints": ["point1", "point2"],
  "actionItems": ["action1", "action2"],
  "decisions": ["decision1", "decision2"],
  "nextSteps": ["step1", "step2"]
}

JSON:''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final jsonText = response.text?.trim() ?? '{}';

    try {
      String cleanJson = jsonText;
      if (jsonText.contains('```json')) {
        cleanJson = jsonText.split('```json')[1].split('```')[0].trim();
      } else if (jsonText.contains('```')) {
        cleanJson = jsonText.split('```')[1].split('```')[0].trim();
      }

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      return {
        'summary': 'Unable to generate meeting notes',
        'keyPoints': [],
        'actionItems': [],
        'decisions': [],
        'nextSteps': [],
      };
    }
  }
}
