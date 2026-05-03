import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/repositories/voice_repository.dart';
import '../../../domain/usecases/voice/start_recording.dart';
import '../../../domain/usecases/voice/start_voice_input.dart';
import '../../../domain/usecases/voice/stop_recording.dart';
import '../../../domain/usecases/voice/stop_voice_input.dart';
import 'voice_event.dart';
import 'voice_state.dart';

/// BLoC for Voice features
class VoiceBloc extends Bloc<VoiceEvent, VoiceState> {
  final StartVoiceInput startVoiceInput;
  final StopVoiceInput stopVoiceInput;
  final StartRecording startRecording;
  final StopRecording stopRecording;
  final VoiceRepository voiceRepository;

  VoiceBloc({
    required this.startVoiceInput,
    required this.stopVoiceInput,
    required this.startRecording,
    required this.stopRecording,
    required this.voiceRepository,
  }) : super(const VoiceInitial()) {
    on<StartVoiceInputEvent>(_onStartVoiceInput);
    on<StopVoiceInputEvent>(_onStopVoiceInput);
    on<StartRecordingEvent>(_onStartRecording);
    on<StopRecordingEvent>(_onStopRecording);
    on<CheckSpeechAvailabilityEvent>(_onCheckSpeechAvailability);
    on<RequestMicrophonePermissionEvent>(_onRequestMicrophonePermission);
    on<ResetVoiceEvent>(_onResetVoice);
  }

  Future<void> _onStartVoiceInput(
    StartVoiceInputEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(const VoiceLoading());
    final result = await startVoiceInput(NoParams());
    result.fold(
      (failure) => emit(VoiceError(failure.message)),
      (_) => emit(const VoiceListening()),
    );
  }

  Future<void> _onStopVoiceInput(
    StopVoiceInputEvent event,
    Emitter<VoiceState> emit,
  ) async {
    final result = await stopVoiceInput(NoParams());
    result.fold(
      (failure) => emit(VoiceError(failure.message)),
      (text) => emit(VoiceInputCompleted(text)),
    );
  }

  Future<void> _onStartRecording(
    StartRecordingEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(const VoiceLoading());
    final result = await startRecording(
      StartRecordingParams(filePath: event.filePath),
    );
    result.fold(
      (failure) => emit(VoiceError(failure.message)),
      (_) => emit(const VoiceRecording()),
    );
  }

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<VoiceState> emit,
  ) async {
    final result = await stopRecording(NoParams());
    result.fold(
      (failure) => emit(VoiceError(failure.message)),
      (filePath) => emit(RecordingCompleted(filePath)),
    );
  }

  Future<void> _onCheckSpeechAvailability(
    CheckSpeechAvailabilityEvent event,
    Emitter<VoiceState> emit,
  ) async {
    final result = await voiceRepository.isSpeechAvailable();
    result.fold(
      (failure) => emit(VoiceError(failure.message)),
      (isAvailable) => emit(SpeechAvailabilityChecked(isAvailable)),
    );
  }

  Future<void> _onRequestMicrophonePermission(
    RequestMicrophonePermissionEvent event,
    Emitter<VoiceState> emit,
  ) async {
    final result = await voiceRepository.requestMicrophonePermission();
    result.fold(
      (failure) => emit(VoiceError(failure.message)),
      (isGranted) => emit(PermissionGranted(isGranted)),
    );
  }

  Future<void> _onResetVoice(
    ResetVoiceEvent event,
    Emitter<VoiceState> emit,
  ) async {
    emit(const VoiceInitial());
  }
}
