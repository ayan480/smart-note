import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for applying smart formatting
class ApplySmartFormatting
    implements UseCase<String, ApplySmartFormattingParams> {
  final AIRepositoryImpl repository;

  ApplySmartFormatting(this.repository);

  @override
  Future<Either<Failure, String>> call(
    ApplySmartFormattingParams params,
  ) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.applySmartFormatting(params.content);
  }
}

class ApplySmartFormattingParams extends Equatable {
  final String content;

  const ApplySmartFormattingParams({required this.content});

  @override
  List<Object> get props => [content];
}
