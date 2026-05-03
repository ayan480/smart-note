import 'package:equatable/equatable.dart';

/// Base class for Voice events
abstract class VoiceEvent extends Equatable {
  const VoiceEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start voice input
class StartVoiceInputEvent extends VoiceEvent {
  const StartVoiceInputEvent();
}

/// Event to stop voice input
class StopVoiceInputEvent extends VoiceEvent {
  const StopVoiceInputEvent();
}

/// Event to start recording
class StartRecordingEvent extends VoiceEvent {
  final String filePath;

  const StartRecordingEvent(this.filePath);

  @override
  List<Object> get props => [filePath];
}

/// Event to stop recording
class StopRecordingEvent extends VoiceEvent {
  const StopRecordingEvent();
}

/// Event to check speech availability
class CheckSpeechAvailabilityEvent extends VoiceEvent {
  const CheckSpeechAvailabilityEvent();
}

/// Event to request microphone permission
class RequestMicrophonePermissionEvent extends VoiceEvent {
  const RequestMicrophonePermissionEvent();
}

/// Event to reset voice state
class ResetVoiceEvent extends VoiceEvent {
  const ResetVoiceEvent();
}
