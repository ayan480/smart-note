import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/repositories/ai_repository_impl.dart';

/// Use case for generating productivity insights
class GenerateInsights
    implements UseCase<Map<String, dynamic>, GenerateInsightsParams> {
  final AIRepositoryImpl repository;

  GenerateInsights(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GenerateInsightsParams params,
  ) async {
    return await repository.generateInsights(params.notes, params.userPatterns);
  }
}

class GenerateInsightsParams extends Equatable {
  final List<Map<String, dynamic>> notes;
  final Map<String, dynamic> userPatterns;

  const GenerateInsightsParams({
    required this.notes,
    required this.userPatterns,
  });

  @override
  List<Object> get props => [notes, userPatterns];
}
