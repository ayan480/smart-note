import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for summarizing content
class SummarizeContent implements UseCase<String, SummarizeContentParams> {
  final AIRepositoryImpl repository;

  SummarizeContent(this.repository);

  @override
  Future<Either<Failure, String>> call(SummarizeContentParams params) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.summarizeContent(params.content);
  }
}

class SummarizeContentParams extends Equatable {
  final String content;

  const SummarizeContentParams({required this.content});

  @override
  List<Object> get props => [content];
}
