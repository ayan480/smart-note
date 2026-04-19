import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

/// Repository interface for Voice/Speech operations
abstract class VoiceRepository {
  /// Start listening for voice input
  Future<Either<Failure, void>> startListening();

  /// Stop listening for voice input
  Future<Either<Failure, String>> stopListening();

  /// Check if speech recognition is available
  Future<Either<Failure, bool>> isSpeechAvailable();

  /// Request microphone permission
  Future<Either<Failure, bool>> requestMicrophonePermission();

  /// Start recording audio (for call/meeting notes)
  Future<Either<Failure, void>> startRecording(String filePath);

  /// Stop recording audio
  Future<Either<Failure, String>> stopRecording();

  /// Transcribe audio file to text
  Future<Either<Failure, String>> transcribeAudio(String audioFilePath);
}
