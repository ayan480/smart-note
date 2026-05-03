import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Service for voice and speech operations
class VoiceService {
  final stt.SpeechToText _speechToText;
  final AudioRecorder _audioRecorder;
  String _recognizedText = '';

  VoiceService()
    : _speechToText = stt.SpeechToText(),
      _audioRecorder = AudioRecorder();

  /// Check if speech recognition is available
  Future<bool> isSpeechAvailable() async {
    return await _speechToText.initialize(
      onError: (error) => print('Speech recognition error: $error'),
      onStatus: (status) => print('Speech recognition status: $status'),
    );
  }

  /// Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Start listening for voice input
  Future<void> startListening({
    required Function(String) onResult,
    String localeId = 'en_US',
  }) async {
    final available = await isSpeechAvailable();
    if (!available) {
      throw Exception('Speech recognition not available');
    }

    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      throw Exception('Microphone permission denied');
    }

    _recognizedText = '';

    await _speechToText.listen(
      onResult: (result) {
        _recognizedText = result.recognizedWords;
        onResult(_recognizedText);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: localeId,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  /// Stop listening for voice input
  Future<String> stopListening() async {
    await _speechToText.stop();
    return _recognizedText;
  }

  /// Check if currently listening
  bool get isListening => _speechToText.isListening;

  /// Get available locales for speech recognition
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    return await _speechToText.locales();
  }

  /// Start recording audio to file
  Future<void> startRecording(String filePath) async {
    final hasPermission = await requestMicrophonePermission();
    if (!hasPermission) {
      throw Exception('Microphone permission denied');
    }

    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );
    } else {
      throw Exception('Recording permission denied');
    }
  }

  /// Stop recording audio
  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path;
  }

  /// Check if currently recording
  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    await _audioRecorder.pause();
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    await _audioRecorder.resume();
  }

  /// Cancel recording
  Future<void> cancelRecording() async {
    await _audioRecorder.cancel();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }

  /// Get recording amplitude (for visualizations)
  Future<double> getAmplitude() async {
    final amplitude = await _audioRecorder.getAmplitude();
    return amplitude.current;
  }
}
