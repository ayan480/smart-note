# AI Implementation Guide - Quick Start

This guide provides step-by-step implementation for the **top 4 AI features** that will give the best user experience with minimal effort.

---

## 🎯 Priority 1: Smart Title Generation (2-3 days)

### Why Start Here?
- **Easy to implement**: Single API call
- **High visibility**: Every note benefits
- **Low cost**: ~$0.0001 per generation
- **Immediate value**: Users see AI working

### Implementation Steps

#### Step 1: Create AI Service (30 mins)
```dart
// lib/data/datasources/remote/ai_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final GenerativeModel _model;
  
  AIService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
        );
  
  Future<String> generateTitle(String content) async {
    final prompt = '''
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
}
```

#### Step 2: Create Repository Implementation (20 mins)
```dart
// lib/data/repositories/ai_repository_impl.dart
class AIRepositoryImpl implements AIRepository {
  final AIService aiService;
  
  AIRepositoryImpl({required this.aiService});
  
  @override
  Future<Either<Failure, String>> generateTitle(String content) async {
    try {
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
}
```

#### Step 3: Create Use Case (15 mins)
```dart
// lib/domain/usecases/ai/generate_title.dart
class GenerateTitle implements UseCase<String, GenerateTitleParams> {
  final AIRepository repository;
  
  GenerateTitle(this.repository);
  
  @override
  Future<Either<Failure, String>> call(GenerateTitleParams params) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.generateTitle(params.content);
  }
}

class GenerateTitleParams extends Equatable {
  final String content;
  
  const GenerateTitleParams({required this.content});
  
  @override
  List<Object> get props => [content];
}
```

#### Step 4: Add to Note Editor UI (1 hour)
```dart
// lib/presentation/pages/note_editor_page.dart

// Add this to the AppBar actions:
IconButton(
  icon: const Icon(Icons.auto_awesome),
  tooltip: 'Generate Title',
  onPressed: _generateTitle,
),

// Add this method:
Future<void> _generateTitle() async {
  if (_contentController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add some content first')),
    );
    return;
  }
  
  setState(() => _isGeneratingTitle = true);
  
  final result = await sl<GenerateTitle>()(
    GenerateTitleParams(content: _contentController.text),
  );
  
  setState(() => _isGeneratingTitle = false);
  
  result.fold(
    (failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message)),
      );
    },
    (title) {
      _titleController.text = title;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title generated!'),
          duration: Duration(seconds: 1),
        ),
      );
    },
  );
}
```

#### Step 5: Add Loading Indicator (15 mins)
```dart
// Show shimmer effect while generating
if (_isGeneratingTitle)
  Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: LinearProgressIndicator(),
  ),
```

### Testing
```dart
// test/domain/usecases/ai/generate_title_test.dart
test('should generate title from content', () async {
  // arrange
  const content = 'Today I learned about Flutter BLoC pattern...';
  when(mockAIRepository.generateTitle(any))
      .thenAnswer((_) async => const Right('Learning Flutter BLoC'));
  
  // act
  final result = await usecase(GenerateTitleParams(content: content));
  
  // assert
  expect(result, const Right('Learning Flutter BLoC'));
});
```

---

## 🎯 Priority 2: Auto-Tagging (3-5 days)

### Why This Next?
- **High organization value**: Automatic categorization
- **Visible AI intelligence**: Shows understanding
- **Moderate cost**: ~$0.0002 per note
- **Scalable**: Works better over time

### Implementation Steps

#### Step 1: Enhanced AI Service (1 hour)
```dart
// Add to AIService
Future<List<String>> generateTags(String content, List<String> existingTags) async {
  final prompt = '''
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
  
  final response = await _model.generateContent([Content.text(prompt)]);
  final tagsText = response.text?.trim() ?? '';
  
  return tagsText
      .split(',')
      .map((tag) => tag.trim().toLowerCase())
      .where((tag) => tag.isNotEmpty)
      .take(5)
      .toList();
}
```

#### Step 2: Create Tag Entity (30 mins)
```dart
// lib/domain/entities/tag.dart
class Tag extends Equatable {
  final String name;
  final double confidence;
  final bool isUserCreated;
  
  const Tag({
    required this.name,
    this.confidence = 1.0,
    this.isUserCreated = false,
  });
  
  @override
  List<Object> get props => [name, confidence, isUserCreated];
}
```

#### Step 3: Update Note Entity (15 mins)
```dart
// Already has tags field, just ensure it's being used
final List<String> tags;
```

#### Step 4: Create Auto-Tag Use Case (30 mins)
```dart
// lib/domain/usecases/ai/auto_tag_note.dart
class AutoTagNote implements UseCase<List<String>, AutoTagParams> {
  final AIRepository aiRepository;
  final NoteRepository noteRepository;
  
  AutoTagNote({
    required this.aiRepository,
    required this.noteRepository,
  });
  
  @override
  Future<Either<Failure, List<String>>> call(AutoTagParams params) async {
    // Get all existing tags from all notes
    final notesResult = await noteRepository.getAllNotes();
    
    return notesResult.fold(
      (failure) => Left(failure),
      (notes) async {
        final existingTags = notes
            .expand((note) => note.tags)
            .toSet()
            .toList();
        
        return await aiRepository.generateTags(
          params.content,
          existingTags,
        );
      },
    );
  }
}
```

#### Step 5: Add to Note Editor (2 hours)
```dart
// Add auto-tag button
ElevatedButton.icon(
  icon: const Icon(Icons.local_offer),
  label: const Text('Suggest Tags'),
  onPressed: _suggestTags,
),

// Add suggested tags display
if (_suggestedTags.isNotEmpty)
  Wrap(
    spacing: 8,
    children: _suggestedTags.map((tag) {
      final isSelected = _selectedTags.contains(tag);
      return FilterChip(
        label: Text(tag),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedTags.add(tag);
            } else {
              _selectedTags.remove(tag);
            }
          });
        },
      );
    }).toList(),
  ),

// Method to suggest tags
Future<void> _suggestTags() async {
  if (_contentController.text.trim().isEmpty) {
    return;
  }
  
  setState(() => _isLoadingTags = true);
  
  final result = await sl<AutoTagNote>()(
    AutoTagParams(content: _contentController.text),
  );
  
  setState(() => _isLoadingTags = false);
  
  result.fold(
    (failure) => _showError(failure.message),
    (tags) {
      setState(() {
        _suggestedTags = tags;
      });
    },
  );
}
```

#### Step 6: Add Tag Filter to Notes Page (1 hour)
```dart
// Add tag filter chips at top of notes page
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      FilterChip(
        label: const Text('All'),
        selected: _selectedTag == null,
        onSelected: (_) => setState(() => _selectedTag = null),
      ),
      ..._allTags.map((tag) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: FilterChip(
          label: Text(tag),
          selected: _selectedTag == tag,
          onSelected: (_) => setState(() => _selectedTag = tag),
        ),
      )),
    ],
  ),
),
```

---

## 🎯 Priority 3: Smart Auto-Complete (3-4 days)

### Why This?
- **Speeds up typing**: Real productivity boost
- **Feels magical**: Predictive intelligence
- **Moderate cost**: Only when typing
- **High engagement**: Used constantly

### Implementation Steps

#### Step 1: Debounced Text Completion (2 hours)
```dart
// lib/presentation/widgets/smart_text_field.dart
class SmartTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSuggestionAccepted;
  
  const SmartTextField({
    required this.controller,
    required this.onSuggestionAccepted,
  });
  
  @override
  State<SmartTextField> createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  Timer? _debounce;
  List<String> _suggestions = [];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }
  
  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _getSuggestions();
    });
  }
  
  Future<void> _getSuggestions() async {
    final text = widget.controller.text;
    if (text.length < 10) return; // Wait for some context
    
    setState(() => _isLoading = true);
    
    final result = await sl<GetTextCompletion>()(
      TextCompletionParams(
        currentText: text,
        maxSuggestions: 3,
      ),
    );
    
    setState(() {
      _isLoading = false;
      result.fold(
        (_) => _suggestions = [],
        (suggestions) => _suggestions = suggestions,
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Suggestion chips
        if (_suggestions.isNotEmpty)
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(_suggestions[index]),
                    onPressed: () {
                      widget.onSuggestionAccepted(_suggestions[index]);
                      setState(() => _suggestions = []);
                    },
                  ),
                );
              },
            ),
          ),
        
        // Text field
        TextField(
          controller: widget.controller,
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Start typing...',
            suffixIcon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }
}
```

#### Step 2: AI Completion Service (1 hour)
```dart
// Add to AIService
Future<List<String>> getTextCompletions(String text) async {
  final prompt = '''
Given this partial text, suggest 3 natural continuations:

Text: $text

Rules:
- Suggest 3-5 word completions
- Match the writing style
- Be contextually relevant
- Each suggestion on a new line

Suggestions:''';
  
  final response = await _model.generateContent([Content.text(prompt)]);
  final suggestions = response.text?.trim().split('\n') ?? [];
  
  return suggestions
      .where((s) => s.trim().isNotEmpty)
      .take(3)
      .toList();
}
```

---

## 🎯 Priority 4: Action Item Detection (2-3 days)

### Why This?
- **Practical utility**: Converts notes to tasks
- **Easy to implement**: Pattern matching + AI
- **Low cost**: Only on demand
- **Clear value**: Actionable insights

### Implementation Steps

#### Step 1: Pattern-Based Detection (1 hour)
```dart
// lib/core/utils/action_item_detector.dart
class ActionItemDetector {
  static final _patterns = [
    RegExp(r'(?:TODO|To do|Action|Task):\s*(.+)', caseSensitive: false),
    RegExp(r'(?:Need to|Must|Should|Have to)\s+(.+)', caseSensitive: false),
    RegExp(r'\[\s*\]\s*(.+)'), // Checkbox pattern
    RegExp(r'(?:Call|Email|Contact|Schedule|Buy|Send)\s+(.+)', caseSensitive: false),
  ];
  
  static List<String> detectActionItems(String text) {
    final items = <String>[];
    
    for (final pattern in _patterns) {
      final matches = pattern.allMatches(text);
      for (final match in matches) {
        if (match.groupCount > 0) {
          items.add(match.group(1)!.trim());
        }
      }
    }
    
    return items;
  }
}
```

#### Step 2: AI Enhancement (1 hour)
```dart
// Add to AIService
Future<List<ActionItem>> extractActionItems(String content) async {
  final prompt = '''
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
    final List<dynamic> items = jsonDecode(jsonText);
    return items.map((item) => ActionItem.fromJson(item)).toList();
  } catch (e) {
    return [];
  }
}
```

#### Step 3: UI Integration (1 hour)
```dart
// Add to note editor
FloatingActionButton.extended(
  onPressed: _extractActionItems,
  icon: const Icon(Icons.checklist),
  label: const Text('Find Tasks'),
),

// Show action items in bottom sheet
void _showActionItems(List<ActionItem> items) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${items.length} Action Items Found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Checkbox(
                    value: false,
                    onChanged: (_) {},
                  ),
                  title: Text(item.task),
                  subtitle: Text('Priority: ${item.priority}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.alarm_add),
                    onPressed: () => _createReminder(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## 🔧 Configuration & Setup

### 1. Add API Key (5 mins)
```dart
// lib/core/config/ai_config.dart
class AIConfig {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'your-api-key-here',
  );
}

// Or use flutter_dotenv
// .env file:
// GEMINI_API_KEY=your-key-here
```

### 2. Update Dependency Injection (15 mins)
```dart
// lib/injection_container.dart
Future<void> init() async {
  // ... existing code ...
  
  // AI Services
  sl.registerLazySingleton(() => AIService(
    apiKey: AIConfig.geminiApiKey,
  ));
  
  sl.registerLazySingleton<AIRepository>(
    () => AIRepositoryImpl(aiService: sl()),
  );
  
  // AI Use Cases
  sl.registerLazySingleton(() => GenerateTitle(sl()));
  sl.registerLazySingleton(() => AutoTagNote(
    aiRepository: sl(),
    noteRepository: sl(),
  ));
  sl.registerLazySingleton(() => GetTextCompletion(sl()));
  sl.registerLazySingleton(() => ExtractActionItems(sl()));
}
```

### 3. Add Permissions (if needed)
```yaml
# android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 📊 Testing Strategy

### Unit Tests
```dart
group('AI Features', () {
  test('should generate title from content', () async {
    // Test title generation
  });
  
  test('should suggest relevant tags', () async {
    // Test auto-tagging
  });
  
  test('should provide text completions', () async {
    // Test auto-complete
  });
  
  test('should extract action items', () async {
    // Test action detection
  });
});
```

### Integration Tests
```dart
testWidgets('AI title generation flow', (tester) async {
  // 1. Enter note content
  // 2. Tap generate title button
  // 3. Verify title appears
  // 4. Verify title is saved
});
```

---

## 🎯 Success Metrics

Track these metrics for each feature:

1. **Usage Rate**: % of notes using the feature
2. **Acceptance Rate**: % of AI suggestions accepted
3. **Time Saved**: Average time reduction
4. **User Satisfaction**: Rating/feedback
5. **API Cost**: Cost per user per month
6. **Error Rate**: Failed API calls

---

## 🚀 Launch Checklist

- [ ] API key configured
- [ ] All dependencies added
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Error handling implemented
- [ ] Loading states added
- [ ] Offline fallback ready
- [ ] Cost monitoring set up
- [ ] User feedback mechanism
- [ ] Analytics tracking
- [ ] Privacy policy updated
- [ ] Feature flags enabled

---

## 💡 Pro Tips

1. **Start Small**: Launch with title generation only
2. **Gather Feedback**: Use analytics to see what works
3. **Iterate Fast**: Improve prompts based on results
4. **Cache Aggressively**: Reduce API costs
5. **Fail Gracefully**: Always have fallbacks
6. **Monitor Costs**: Set up billing alerts
7. **A/B Test**: Try different prompts
8. **User Control**: Let users disable features

---

## 🎉 Quick Win Timeline

**Week 1**: Smart Title Generation
- Day 1-2: Implementation
- Day 3: Testing
- Day 4-5: Polish & deploy

**Week 2**: Auto-Tagging
- Day 1-3: Implementation
- Day 4: Testing
- Day 5: Deploy

**Week 3**: Auto-Complete
- Day 1-3: Implementation
- Day 4: Testing
- Day 5: Deploy

**Week 4**: Action Items
- Day 1-2: Implementation
- Day 3: Testing
- Day 4-5: Polish & deploy

**Total: 4 weeks to 4 powerful AI features!**

---

Start with **Smart Title Generation** today - it's the easiest win and will validate your AI integration setup for all future features!
