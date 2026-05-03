import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for generating meeting notes
class GenerateMeetingNotes
    implements UseCase<Map<String, dynamic>, GenerateMeetingNotesParams> {
  final AIRepositoryImpl repository;

  GenerateMeetingNotes(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GenerateMeetingNotesParams params,
  ) async {
    if (params.transcript.trim().isEmpty) {
      return const Left(ValidationFailure('Transcript is empty'));
    }
    return await repository.generateMeetingNotes(params.transcript);
  }
}

class GenerateMeetingNotesParams extends Equatable {
  final String transcript;

  const GenerateMeetingNotesParams({required this.transcript});

  @override
  List<Object> get props => [transcript];
}
