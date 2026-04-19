import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/ai_suggestion.dart';
import '../../repositories/ai_repository.dart';

class GetAISuggestions
    implements UseCase<List<AISuggestion>, GetAISuggestionsParams> {
  final AIRepository repository;

  GetAISuggestions(this.repository);

  @override
  Future<Either<Failure, List<AISuggestion>>> call(
    GetAISuggestionsParams params,
  ) async {
    return await repository.getSuggestions(
      noteContent: params.noteContent,
      context: params.context,
    );
  }
}

class GetAISuggestionsParams extends Equatable {
  final String noteContent;
  final String context;

  const GetAISuggestionsParams({
    required this.noteContent,
    required this.context,
  });

  @override
  List<Object> get props => [noteContent, context];
}
