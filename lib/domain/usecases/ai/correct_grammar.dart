import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for correcting grammar and spelling
class CorrectGrammar implements UseCase<String, CorrectGrammarParams> {
  final AIRepositoryImpl repository;

  CorrectGrammar(this.repository);

  @override
  Future<Either<Failure, String>> call(CorrectGrammarParams params) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.correctGrammarAndSpelling(params.content);
  }
}

class CorrectGrammarParams extends Equatable {
  final String content;

  const CorrectGrammarParams({required this.content});

  @override
  List<Object> get props => [content];
}
