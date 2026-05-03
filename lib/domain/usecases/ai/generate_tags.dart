import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for generating tags
class GenerateTags implements UseCase<List<String>, GenerateTagsParams> {
  final AIRepositoryImpl repository;

  GenerateTags(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(GenerateTagsParams params) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.generateTags(params.content, params.existingTags);
  }
}

class GenerateTagsParams extends Equatable {
  final String content;
  final List<String> existingTags;

  const GenerateTagsParams({
    required this.content,
    this.existingTags = const [],
  });

  @override
  List<Object> get props => [content, existingTags];
}
