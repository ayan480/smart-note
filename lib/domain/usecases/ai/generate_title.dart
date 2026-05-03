import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for generating smart titles
class GenerateTitle implements UseCase<String, GenerateTitleParams> {
  final AIRepositoryImpl repository;

  GenerateTitle(this.repository);

  @override
  Future<Either<Failure, String>> call(GenerateTitleParams params) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.generateTitle(params.content);
  }
}

class GenerateTitleParams extends Equatable {
  final String content;

  const GenerateTitleParams({required this.content});

  @override
  List<Object> get props => [content];
}
