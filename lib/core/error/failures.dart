import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure for database operations
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Failure for network operations (future use)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for permission issues
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Failure for file operations
class FileFailure extends Failure {
  const FileFailure(super.message);
}

/// Failure for AI operations
class AIFailure extends Failure {
  const AIFailure(super.message);
}

/// Failure for voice/speech operations
class VoiceFailure extends Failure {
  const VoiceFailure(super.message);
}

/// Failure for validation
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
