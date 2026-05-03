import 'package:equatable/equatable.dart';

/// Base class for Voice states
abstract class VoiceState extends Equatable {
  const VoiceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class VoiceInitial extends VoiceState {
  const VoiceInitial();
}

/// Loading state
class VoiceLoading extends VoiceState {
  const VoiceLoading();
}

/// Listening state (voice input active)
class VoiceListening extends VoiceState {
  const VoiceListening();
}

/// Voice input completed state
class VoiceInputCompleted extends VoiceState {
  final String recognizedText;

  const VoiceInputCompleted(this.recognizedText);

  @override
  List<Object> get props => [recognizedText];
}

/// Recording state (audio recording active)
class VoiceRecording extends VoiceState {
  const VoiceRecording();
}

/// Recording completed state
class RecordingCompleted extends VoiceState {
  final String filePath;

  const RecordingCompleted(this.filePath);

  @override
  List<Object> get props => [filePath];
}

/// Speech availability checked state
class SpeechAvailabilityChecked extends VoiceState {
  final bool isAvailable;

  const SpeechAvailabilityChecked(this.isAvailable);

  @override
  List<Object> get props => [isAvailable];
}

/// Permission granted state
class PermissionGranted extends VoiceState {
  final bool isGranted;

  const PermissionGranted(this.isGranted);

  @override
  List<Object> get props => [isGranted];
}

/// Error state
class VoiceError extends VoiceState {
  final String message;

  const VoiceError(this.message);

  @override
  List<Object> get props => [message];
}
