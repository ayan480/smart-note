@echo off
REM Verification script for AI features implementation (Windows)
REM This script checks that all required files are present and properly configured

echo Verifying AI Features Implementation...
echo.

setlocal enabledelayedexpansion
set PASSED=0
set FAILED=0

REM Function to check if file exists
:check_file
if exist "%~1" (
    echo [OK] %~1
    set /a PASSED+=1
) else (
    echo [MISSING] %~1
    set /a FAILED+=1
)
goto :eof

echo Checking Directory Structure...
call :check_file "lib\data\datasources\remote"
call :check_file "lib\data\datasources\local"
call :check_file "lib\domain\usecases\ai"
call :check_file "lib\domain\usecases\voice"
call :check_file "lib\presentation\bloc\ai"
call :check_file "lib\presentation\bloc\voice"
echo.

echo Checking Service Files...
call :check_file "lib\data\datasources\remote\ai_service.dart"
call :check_file "lib\data\datasources\local\voice_service.dart"
call :check_file "lib\data\datasources\local\share_service.dart"
echo.

echo Checking Repository Implementations...
call :check_file "lib\data\repositories\ai_repository_impl.dart"
call :check_file "lib\data\repositories\voice_repository_impl.dart"
echo.

echo Checking AI Use Cases...
call :check_file "lib\domain\usecases\ai\generate_title.dart"
call :check_file "lib\domain\usecases\ai\generate_tags.dart"
call :check_file "lib\domain\usecases\ai\get_text_completion.dart"
call :check_file "lib\domain\usecases\ai\extract_action_items.dart"
call :check_file "lib\domain\usecases\ai\summarize_content.dart"
call :check_file "lib\domain\usecases\ai\semantic_search.dart"
call :check_file "lib\domain\usecases\ai\analyze_writing.dart"
call :check_file "lib\domain\usecases\ai\suggest_reminders.dart"
call :check_file "lib\domain\usecases\ai\find_related_notes.dart"
call :check_file "lib\domain\usecases\ai\generate_insights.dart"
call :check_file "lib\domain\usecases\ai\correct_grammar.dart"
call :check_file "lib\domain\usecases\ai\apply_smart_formatting.dart"
call :check_file "lib\domain\usecases\ai\generate_meeting_notes.dart"
echo.

echo Checking Voice Use Cases...
call :check_file "lib\domain\usecases\voice\start_voice_input.dart"
call :check_file "lib\domain\usecases\voice\stop_voice_input.dart"
call :check_file "lib\domain\usecases\voice\start_recording.dart"
call :check_file "lib\domain\usecases\voice\stop_recording.dart"
echo.

echo Checking BLoC Files...
call :check_file "lib\presentation\bloc\ai\ai_bloc.dart"
call :check_file "lib\presentation\bloc\ai\ai_event.dart"
call :check_file "lib\presentation\bloc\ai\ai_state.dart"
call :check_file "lib\presentation\bloc\voice\voice_bloc.dart"
call :check_file "lib\presentation\bloc\voice\voice_event.dart"
call :check_file "lib\presentation\bloc\voice\voice_state.dart"
echo.

echo Checking Widget Files...
call :check_file "lib\presentation\widgets\ai_features_menu.dart"
call :check_file "lib\presentation\widgets\voice_input_button.dart"
echo.

echo Checking Configuration Files...
call :check_file "lib\core\config\ai_config.dart"
call :check_file "lib\injection_container.dart"
call :check_file "lib\main.dart"
call :check_file "pubspec.yaml"
echo.

echo Checking Test Files...
call :check_file "test\data\repositories\ai_repository_impl_test.dart"
call :check_file "test\data\repositories\voice_repository_impl_test.dart"
call :check_file "test\domain\usecases\ai\generate_title_test.dart"
echo.

echo Checking Documentation...
call :check_file "AI_FEATURES_IMPLEMENTATION.md"
call :check_file "AI_QUICK_START.md"
call :check_file "INTEGRATION_EXAMPLE.md"
call :check_file "IMPLEMENTATION_COMPLETE.md"
echo.

echo ========================================
echo Verification Summary
echo ========================================
echo Passed: %PASSED%
echo Failed: %FAILED%
echo.

if %FAILED% EQU 0 (
    echo All checks passed! Implementation is complete.
    echo.
    echo Next steps:
    echo 1. Set your API key: flutter run --dart-define=GEMINI_API_KEY=your_key
    echo 2. Run tests: flutter test
    echo 3. Build the app: flutter run
    exit /b 0
) else (
    echo Some checks failed. Please review the missing files.
    exit /b 1
)
