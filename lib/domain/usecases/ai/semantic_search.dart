import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for semantic search
class SemanticSearch implements UseCase<List<String>, SemanticSearchParams> {
  final AIRepositoryImpl repository;

  SemanticSearch(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(
    SemanticSearchParams params,
  ) async {
    if (params.query.trim().isEmpty) {
      return const Left(ValidationFailure('Query is empty'));
    }
    return await repository.semanticSearch(params.query, params.notes);
  }
}

class SemanticSearchParams extends Equatable {
  final String query;
  final List<Map<String, String>> notes;

  const SemanticSearchParams({required this.query, required this.notes});

  @override
  List<Object> get props => [query, notes];
}
