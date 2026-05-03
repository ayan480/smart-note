import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/voice_repository.dart';

/// Use case for starting audio recording
class StartRecording implements UseCase<void, StartRecordingParams> {
  final VoiceRepository repository;

  StartRecording(this.repository);

  @override
  Future<Either<Failure, void>> call(StartRecordingParams params) async {
    return await repository.startRecording(params.filePath);
  }
}

class StartRecordingParams extends Equatable {
  final String filePath;

  const StartRecordingParams({required this.filePath});

  @override
  List<Object> get props => [filePath];
}
