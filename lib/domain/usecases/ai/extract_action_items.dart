import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for extracting action items
class ExtractActionItems
    implements UseCase<List<Map<String, dynamic>>, ExtractActionItemsParams> {
  final AIRepositoryImpl repository;

  ExtractActionItems(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    ExtractActionItemsParams params,
  ) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.extractActionItems(params.content);
  }
}

class ExtractActionItemsParams extends Equatable {
  final String content;

  const ExtractActionItemsParams({required this.content});

  @override
  List<Object> get props => [content];
}
