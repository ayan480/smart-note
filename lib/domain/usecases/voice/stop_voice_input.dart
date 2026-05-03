import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/voice_repository.dart';

/// Use case for stopping voice input
class StopVoiceInput implements UseCase<String, NoParams> {
  final VoiceRepository repository;

  StopVoiceInput(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.stopListening();
  }
}
