import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for analyzing writing
class AnalyzeWriting
    implements UseCase<Map<String, dynamic>, AnalyzeWritingParams> {
  final AIRepositoryImpl repository;

  AnalyzeWriting(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    AnalyzeWritingParams params,
  ) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.analyzeWriting(params.content);
  }
}

class AnalyzeWritingParams extends Equatable {
  final String content;

  const AnalyzeWritingParams({required this.content});

  @override
  List<Object> get props => [content];
}
