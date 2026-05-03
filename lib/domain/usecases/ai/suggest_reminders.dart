import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for suggesting smart reminders
class SuggestReminders
    implements UseCase<List<Map<String, dynamic>>, SuggestRemindersParams> {
  final AIRepositoryImpl repository;

  SuggestReminders(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
    SuggestRemindersParams params,
  ) async {
    if (params.content.trim().isEmpty) {
      return const Left(ValidationFailure('Content is empty'));
    }
    return await repository.suggestReminders(params.content);
  }
}

class SuggestRemindersParams extends Equatable {
  final String content;

  const SuggestRemindersParams({required this.content});

  @override
  List<Object> get props => [content];
}
