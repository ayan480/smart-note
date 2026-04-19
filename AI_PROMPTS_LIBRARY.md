# AI Prompts Library - Best Practices & Examples

This document contains optimized prompts for all AI features with best practices for prompt engineering.

---

## 🎯 Prompt Engineering Principles

### 1. Be Specific
❌ Bad: "Make this better"
✅ Good: "Generate a concise title (max 50 characters) that captures the main topic"

### 2. Provide Context
❌ Bad: "Suggest tags"
✅ Good: "Analyze this note and suggest 3-5 tags. Existing tags: work, personal, ideas"

### 3. Set Constraints
❌ Bad: "Complete this text"
✅ Good: "Suggest 3 completions, each 3-5 words, matching the writing style"

### 4. Give Examples
❌ Bad: "Extract action items"
✅ Good: "Extract action items like: 'Call John', 'Submit report by Friday'"

### 5. Format Output
❌ Bad: "List the tags"
✅ Good: "Return tags as comma-separated values: tag1, tag2, tag3"

---

## 📝 Title Generation Prompts

### Basic Title Generation
```
Generate a concise, descriptive title (max 50 characters) for this note:

{note_content}

Rules:
- Be specific and descriptive
- Use title case
- No quotes or special characters
- Capture the main topic
- If it's a list, start with "List:"
- If it's a meeting, start with "Meeting:"

Title:
```

### Context-Aware Title
```
Generate a title for this note based on its type:

Note: {note_content}
Type: {detected_type}
Date: {date}

Guidelines:
- For meetings: "Meeting: [Topic] - [Date]"
- For lists: "List: [Category]"
- For ideas: "Idea: [Main Concept]"
- For tasks: "Tasks: [Project/Area]"
- For journal: "Journal: [Date] - [Mood/Theme]"

Title:
```

### Multi-Language Title
```
Generate a title in {language} for this note:

{note_content}

Requirements:
- Maximum 50 characters
- Use proper {language} grammar
- Culturally appropriate
- Clear and descriptive

Title:
```

---

## 🏷️ Auto-Tagging Prompts

### Basic Tagging
```
Analyze this note and suggest 3-5 relevant tags:

Note: {note_content}

Existing tags in the system: {existing_tags}

Rules:
- Use existing tags when relevant (prefer reuse over creation)
- Create new tags only if necessary
- Tags should be lowercase, single words or short phrases
- Focus on topics, categories, and key concepts
- Avoid generic tags like "note" or "text"
- Return only the tag names, comma-separated

Tags:
```

### Hierarchical Tagging
```
Suggest tags with categories for this note:

{note_content}

Existing tags: {existing_tags}

Format as: category:tag
Examples: project:mobile-app, person:john, topic:ai

Categories to use:
- project: Project names
- person: People mentioned
- topic: Subject matter
- status: Current state (draft, done, pending)
- priority: Importance level
- location: Places mentioned

Tags:
```

### Smart Tag Suggestions
```
Analyze this note and suggest tags based on:

Content: {note_content}
User's frequent tags: {user_frequent_tags}
Similar notes' tags: {similar_notes_tags}
Time of day: {time}
Day of week: {day}

Suggest 3-5 tags that:
1. Match the content
2. Align with user's tagging patterns
3. Help with organization
4. Are searchable and meaningful

Tags:
```

---

## ✍️ Text Completion Prompts

### Basic Completion
```
Given this partial text, suggest 3 natural continuations:

Text: {current_text}

Rules:
- Suggest 3-5 word completions
- Match the writing style and tone
- Be contextually relevant
- Complete the current thought
- Each suggestion on a new line

Suggestions:
```

### Context-Aware Completion
```
Complete this text based on context:

Current text: {current_text}
Note type: {note_type}
Previous sentences: {previous_context}
User's writing style: {writing_style}

Provide 3 completions that:
1. Match the user's typical phrasing
2. Fit the note type (formal/casual)
3. Continue the logical flow
4. Are 3-7 words each

Completions:
```

### Smart Sentence Completion
```
The user is writing: "{current_sentence}"

Context from note:
{note_context}

Suggest how to complete this sentence with 3 options:
1. A factual completion
2. A descriptive completion
3. An action-oriented completion

Each completion should be 5-10 words.

Completions:
```

---

## 📋 Action Item Extraction Prompts

### Basic Action Items
```
Extract action items from this note:

{note_content}

For each action item, identify:
1. The task description (clear and actionable)
2. Priority (high/medium/low)
3. Deadline if mentioned (or "none")
4. Person responsible if mentioned (or "me")

Look for patterns like:
- "TODO:", "Action:", "Task:"
- "Need to", "Must", "Should", "Have to"
- Checkboxes: "[ ]"
- Action verbs: "Call", "Email", "Buy", "Schedule", "Send"

Format as JSON array:
[
  {
    "task": "Clear description of what to do",
    "priority": "high|medium|low",
    "deadline": "date or 'none'",
    "assignee": "name or 'me'"
  }
]

JSON:
```

### Smart Action Detection
```
Analyze this note for actionable items:

{note_content}

Extract:
1. Explicit tasks (TODO, checkboxes)
2. Implicit tasks (mentioned obligations)
3. Follow-ups (things to check later)
4. Decisions that need action

For each item, determine:
- What needs to be done
- When (if mentioned)
- Why it's important
- Dependencies (if any)

Return as structured JSON with confidence scores.

JSON:
```

### Meeting Action Items
```
This is a meeting note. Extract action items:

{meeting_note}

Identify:
1. Decisions made → Actions needed
2. Questions raised → Follow-ups needed
3. Assignments given → Tasks with owners
4. Deadlines mentioned → Time-sensitive items

Format:
{
  "decisions": ["decision 1", "decision 2"],
  "action_items": [
    {
      "task": "...",
      "owner": "...",
      "deadline": "...",
      "context": "why this is needed"
    }
  ],
  "follow_ups": ["question 1", "question 2"]
}

JSON:
```

---

## 📊 Content Summarization Prompts

### Basic Summary
```
Summarize this note in 2-3 sentences:

{note_content}

Requirements:
- Capture the main points
- Use clear, concise language
- Maintain the original meaning
- Suitable for quick scanning

Summary:
```

### Structured Summary
```
Create a structured summary of this note:

{note_content}

Format:
**Main Topic:** [One sentence]

**Key Points:**
- Point 1
- Point 2
- Point 3

**Action Items:** [If any]

**Conclusion:** [One sentence]

Summary:
```

### Executive Summary
```
Create an executive summary for:

{note_content}

Include:
1. TL;DR (one sentence)
2. Key insights (3-5 bullet points)
3. Recommendations (if applicable)
4. Next steps (if applicable)

Keep it under 100 words.

Summary:
```

---

## 🔍 Smart Search Prompts

### Semantic Search
```
User searched for: "{search_query}"

Available notes: {note_titles_and_snippets}

Task:
1. Understand the search intent
2. Find semantically related notes
3. Rank by relevance
4. Explain why each note matches

Return top 5 matches with relevance scores and reasons.

Format:
{
  "matches": [
    {
      "note_id": "...",
      "relevance": 0.95,
      "reason": "Contains information about..."
    }
  ],
  "suggested_refinements": ["try searching for...", "related: ..."]
}

JSON:
```

### Natural Language Search
```
Interpret this search query: "{user_query}"

Extract:
- Intent (find, list, show, when, who, what)
- Entities (people, places, topics)
- Time constraints (today, last week, recent)
- Filters (type, tag, status)

Convert to structured search parameters:
{
  "keywords": ["word1", "word2"],
  "date_range": {"start": "...", "end": "..."},
  "tags": ["tag1", "tag2"],
  "note_type": "meeting|list|journal|...",
  "sort_by": "relevance|date|title"
}

JSON:
```

---

## 🎨 Writing Style Analysis Prompts

### Style Analysis
```
Analyze the writing style of this text:

{text}

Evaluate:
1. Tone (formal, casual, professional, friendly)
2. Readability (Flesch-Kincaid score)
3. Sentence structure (simple, complex, varied)
4. Vocabulary level (basic, intermediate, advanced)
5. Common patterns or phrases

Provide:
- Overall assessment
- Strengths
- Areas for improvement
- Specific suggestions

Analysis:
```

### Grammar Check
```
Check this text for grammar and style issues:

{text}

Identify:
1. Grammar errors (with corrections)
2. Spelling mistakes
3. Punctuation issues
4. Style improvements (passive voice, wordiness)
5. Clarity suggestions

For each issue, provide:
- Location (sentence number)
- Type of issue
- Current text
- Suggested correction
- Explanation

Format as JSON array.

JSON:
```

---

## 🤝 Meeting Notes Processing Prompts

### Meeting Summary
```
Process this meeting note:

{meeting_note}

Extract:
1. Meeting metadata
   - Date and time
   - Attendees
   - Duration
   
2. Agenda items discussed

3. Key decisions made

4. Action items with owners

5. Open questions

6. Next meeting date/topics

Format as structured JSON.

JSON:
```

### Meeting Insights
```
Analyze this meeting note for insights:

{meeting_note}

Provide:
1. Meeting effectiveness score (1-10)
2. Key outcomes
3. Participation analysis
4. Decision quality
5. Follow-up requirements
6. Suggestions for next meeting

Insights:
```

---

## 🔗 Related Notes Discovery Prompts

### Find Related Notes
```
Find notes related to this one:

Current note: {current_note}

Available notes: {all_notes_metadata}

Analyze:
1. Topic similarity
2. Shared entities (people, places, projects)
3. Temporal relationships
4. Referenced connections

Return top 5 related notes with:
- Similarity score (0-1)
- Relationship type
- Common elements
- Why it's related

JSON:
```

### Smart Linking
```
Suggest links between these notes:

Note A: {note_a}
Note B: {note_b}

Determine:
1. Are they related? (yes/no)
2. Relationship type (continuation, reference, contrast, support)
3. Confidence score (0-1)
4. Suggested link text
5. Bidirectional or one-way?

If related, suggest how to link them.

Analysis:
```

---

## 🎯 Personalization Prompts

### User Profile Analysis
```
Analyze this user's note-taking patterns:

Notes: {user_notes_sample}
Tags used: {user_tags}
Writing times: {time_patterns}
Note types: {type_distribution}

Create a user profile:
1. Preferred note structure
2. Common topics
3. Writing style
4. Organization preferences
5. Productivity patterns

Use this profile to personalize future suggestions.

Profile:
```

### Adaptive Suggestions
```
Generate personalized suggestions for this user:

User profile: {user_profile}
Current note: {current_note}
Context: {context}

Suggest:
1. Relevant tags (based on their patterns)
2. Related past notes
3. Useful templates
4. Productivity tips
5. Organization improvements

Tailor suggestions to their style and needs.

Suggestions:
```

---

## 💡 Best Practices

### 1. Prompt Versioning
Keep track of prompt versions and their performance:
```dart
class PromptVersion {
  final String id;
  final String prompt;
  final double successRate;
  final DateTime createdAt;
}
```

### 2. A/B Testing
Test different prompts:
```dart
final promptA = "Generate a title...";
final promptB = "Create a concise title...";

// Track which performs better
```

### 3. Fallback Prompts
Always have a simpler fallback:
```dart
try {
  result = await complexPrompt();
} catch (e) {
  result = await simplePrompt();
}
```

### 4. Prompt Caching
Cache prompts for common operations:
```dart
final cachedPrompt = PromptCache.get('title_generation');
```

### 5. User Feedback Loop
Learn from user interactions:
```dart
if (userAcceptedSuggestion) {
  PromptOptimizer.recordSuccess(promptId);
} else {
  PromptOptimizer.recordFailure(promptId);
}
```

---

## 📈 Prompt Performance Metrics

Track these for each prompt:

1. **Success Rate**: % of accepted suggestions
2. **Response Time**: Average API response time
3. **Token Usage**: Average tokens per request
4. **Cost**: Average cost per request
5. **User Satisfaction**: Rating/feedback
6. **Error Rate**: Failed requests

---

## 🔧 Prompt Optimization Tips

### 1. Reduce Token Usage
❌ Long: "Please analyze this note and provide suggestions..."
✅ Short: "Analyze note, suggest improvements:"

### 2. Use Examples
```
Extract dates from text.

Examples:
"meeting tomorrow" → {date: "2024-01-16"}
"next Monday" → {date: "2024-01-15"}

Text: {input}
```

### 3. Structured Output
```
Return as JSON:
{
  "title": "...",
  "tags": ["...", "..."],
  "confidence": 0.95
}
```

### 4. Chain of Thought
```
Let's think step by step:
1. Identify the main topic
2. Extract key concepts
3. Generate relevant tags
4. Rank by relevance

Tags:
```

---

## 🎉 Quick Reference

| Feature | Prompt Type | Avg Tokens | Cost | Priority |
|---------|-------------|------------|------|----------|
| Title Gen | Simple | 100 | $0.0001 | High |
| Auto-Tag | Medium | 200 | $0.0002 | High |
| Completion | Simple | 150 | $0.00015 | Medium |
| Summary | Medium | 300 | $0.0003 | Medium |
| Actions | Complex | 400 | $0.0004 | High |
| Search | Complex | 500 | $0.0005 | Medium |
| Analysis | Complex | 600 | $0.0006 | Low |

---

Use these prompts as starting points and iterate based on your specific needs and user feedback!
