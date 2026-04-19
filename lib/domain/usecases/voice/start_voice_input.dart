import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/voice_repository.dart';

class StartVoiceInput implements UseCase<void, NoParams> {
  final VoiceRepository repository;

  StartVoiceInput(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.startListening();
  }
}
