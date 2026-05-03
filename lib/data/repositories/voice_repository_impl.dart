import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/voice_repository.dart';
import '../datasources/local/voice_service.dart';

/// Implementation of VoiceRepository
class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceService voiceService;
  String _currentRecognizedText = '';

  VoiceRepositoryImpl({required this.voiceService});

  @override
  Future<Either<Failure, void>> startListening() async {
    try {
      await voiceService.startListening(
        onResult: (text) {
          _currentRecognizedText = text;
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(VoiceFailure('Failed to start listening: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> stopListening() async {
    try {
      final text = await voiceService.stopListening();
      return Right(text);
    } catch (e) {
      return Left(VoiceFailure('Failed to stop listening: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isSpeechAvailable() async {
    try {
      final available = await voiceService.isSpeechAvailable();
      return Right(available);
    } catch (e) {
      return Left(
        VoiceFailure('Failed to check speech availability: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> requestMicrophonePermission() async {
    try {
      final granted = await voiceService.requestMicrophonePermission();
      return Right(granted);
    } catch (e) {
      return Left(
        VoiceFailure('Failed to request permission: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> startRecording(String filePath) async {
    try {
      await voiceService.startRecording(filePath);
      return const Right(null);
    } catch (e) {
      return Left(VoiceFailure('Failed to start recording: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> stopRecording() async {
    try {
      final path = await voiceService.stopRecording();
      if (path == null) {
        return const Left(VoiceFailure('Recording path is null'));
      }
      return Right(path);
    } catch (e) {
      return Left(VoiceFailure('Failed to stop recording: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> transcribeAudio(String audioFilePath) async {
    try {
      // For now, return a placeholder
      // In a real implementation, you would use a transcription service
      return const Right('Audio transcription not yet implemented');
    } catch (e) {
      return Left(VoiceFailure('Failed to transcribe audio: ${e.toString()}'));
    }
  }

  /// Check if currently listening
  bool get isListening => voiceService.isListening;

  /// Check if currently recording
  Future<Either<Failure, bool>> isRecording() async {
    try {
      final recording = await voiceService.isRecording();
      return Right(recording);
    } catch (e) {
      return Left(
        VoiceFailure('Failed to check recording status: ${e.toString()}'),
      );
    }
  }

  /// Pause recording
  Future<Either<Failure, void>> pauseRecording() async {
    try {
      await voiceService.pauseRecording();
      return const Right(null);
    } catch (e) {
      return Left(VoiceFailure('Failed to pause recording: ${e.toString()}'));
    }
  }

  /// Resume recording
  Future<Either<Failure, void>> resumeRecording() async {
    try {
      await voiceService.resumeRecording();
      return const Right(null);
    } catch (e) {
      return Left(VoiceFailure('Failed to resume recording: ${e.toString()}'));
    }
  }

  /// Cancel recording
  Future<Either<Failure, void>> cancelRecording() async {
    try {
      await voiceService.cancelRecording();
      return const Right(null);
    } catch (e) {
      return Left(VoiceFailure('Failed to cancel recording: ${e.toString()}'));
    }
  }

  /// Get recording amplitude
  Future<Either<Failure, double>> getAmplitude() async {
    try {
      final amplitude = await voiceService.getAmplitude();
      return Right(amplitude);
    } catch (e) {
      return Left(VoiceFailure('Failed to get amplitude: ${e.toString()}'));
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await voiceService.dispose();
  }
}
