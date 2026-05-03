import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/ai_repository.dart';

/// Use case for getting text completions
class GetTextCompletion implements UseCase<List<String>, TextCompletionParams> {
  final AIRepository repository;

  GetTextCompletion(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
    TextCompletionParams params,
  ) async {
    if (params.currentText.trim().isEmpty || params.currentText.length < 10) {
      return const Right([]);
    }

    final result = await repository.getSuggestions(
      noteContent: params.currentText,
      context: '',
    );

    return result.fold(
      (failure) => Left(failure),
      (suggestions) => Right(suggestions.map((s) => s.content).toList()),
    );
  }
}

class TextCompletionParams extends Equatable {
  final String currentText;
  final int maxSuggestions;

  const TextCompletionParams({
    required this.currentText,
    this.maxSuggestions = 3,
  });

  @override
  List<Object> get props => [currentText, maxSuggestions];
}
