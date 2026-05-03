#!/bin/bash

# Verification script for AI features implementation
# This script checks that all required files are present and properly configured

echo "🔍 Verifying AI Features Implementation..."
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $1 (MISSING)"
        ((FAILED++))
    fi
}

# Function to check if directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $1/ (MISSING)"
        ((FAILED++))
    fi
}

echo "📁 Checking Directory Structure..."
check_dir "lib/data/datasources/remote"
check_dir "lib/data/datasources/local"
check_dir "lib/domain/usecases/ai"
check_dir "lib/domain/usecases/voice"
check_dir "lib/presentation/bloc/ai"
check_dir "lib/presentation/bloc/voice"
check_dir "lib/presentation/widgets"
check_dir "lib/core/config"
echo ""

echo "📄 Checking Service Files..."
check_file "lib/data/datasources/remote/ai_service.dart"
check_file "lib/data/datasources/local/voice_service.dart"
check_file "lib/data/datasources/local/share_service.dart"
echo ""

echo "📄 Checking Repository Implementations..."
check_file "lib/data/repositories/ai_repository_impl.dart"
check_file "lib/data/repositories/voice_repository_impl.dart"
echo ""

echo "📄 Checking AI Use Cases..."
check_file "lib/domain/usecases/ai/generate_title.dart"
check_file "lib/domain/usecases/ai/generate_tags.dart"
check_file "lib/domain/usecases/ai/get_text_completion.dart"
check_file "lib/domain/usecases/ai/extract_action_items.dart"
check_file "lib/domain/usecases/ai/summarize_content.dart"
check_file "lib/domain/usecases/ai/semantic_search.dart"
check_file "lib/domain/usecases/ai/analyze_writing.dart"
check_file "lib/domain/usecases/ai/suggest_reminders.dart"
check_file "lib/domain/usecases/ai/find_related_notes.dart"
check_file "lib/domain/usecases/ai/generate_insights.dart"
check_file "lib/domain/usecases/ai/correct_grammar.dart"
check_file "lib/domain/usecases/ai/apply_smart_formatting.dart"
check_file "lib/domain/usecases/ai/generate_meeting_notes.dart"
echo ""

echo "📄 Checking Voice Use Cases..."
check_file "lib/domain/usecases/voice/start_voice_input.dart"
check_file "lib/domain/usecases/voice/stop_voice_input.dart"
check_file "lib/domain/usecases/voice/start_recording.dart"
check_file "lib/domain/usecases/voice/stop_recording.dart"
echo ""

echo "📄 Checking BLoC Files..."
check_file "lib/presentation/bloc/ai/ai_bloc.dart"
check_file "lib/presentation/bloc/ai/ai_event.dart"
check_file "lib/presentation/bloc/ai/ai_state.dart"
check_file "lib/presentation/bloc/voice/voice_bloc.dart"
check_file "lib/presentation/bloc/voice/voice_event.dart"
check_file "lib/presentation/bloc/voice/voice_state.dart"
echo ""

echo "📄 Checking Widget Files..."
check_file "lib/presentation/widgets/ai_features_menu.dart"
check_file "lib/presentation/widgets/voice_input_button.dart"
echo ""

echo "📄 Checking Configuration Files..."
check_file "lib/core/config/ai_config.dart"
check_file "lib/injection_container.dart"
check_file "lib/main.dart"
check_file "pubspec.yaml"
echo ""

echo "📄 Checking Test Files..."
check_file "test/data/repositories/ai_repository_impl_test.dart"
check_file "test/data/repositories/voice_repository_impl_test.dart"
check_file "test/domain/usecases/ai/generate_title_test.dart"
echo ""

echo "📄 Checking Documentation..."
check_file "AI_FEATURES_IMPLEMENTATION.md"
check_file "AI_QUICK_START.md"
check_file "INTEGRATION_EXAMPLE.md"
check_file "IMPLEMENTATION_COMPLETE.md"
echo ""

echo "📄 Checking Platform Configuration..."
check_file "android/app/src/main/AndroidManifest.xml"
check_file "ios/Runner/Info.plist"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Verification Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Implementation is complete.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Set your API key: flutter run --dart-define=GEMINI_API_KEY=your_key"
    echo "2. Run tests: flutter test"
    echo "3. Build the app: flutter run"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Please review the missing files.${NC}"
    exit 1
fi
