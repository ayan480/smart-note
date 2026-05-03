import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for finding related notes
class FindRelatedNotes
    implements UseCase<List<String>, FindRelatedNotesParams> {
  final AIRepositoryImpl repository;

  FindRelatedNotes(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
    FindRelatedNotesParams params,
  ) async {
    if (params.currentContent.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.findRelatedNotes(
      params.currentNoteId,
      params.currentContent,
      params.allNotes,
    );
  }
}

class FindRelatedNotesParams extends Equatable {
  final String currentNoteId;
  final String currentContent;
  final List<Map<String, String>> allNotes;

  const FindRelatedNotesParams({
    required this.currentNoteId,
    required this.currentContent,
    required this.allNotes,
  });

  @override
  List<Object> get props => [currentNoteId, currentContent, allNotes];
}
