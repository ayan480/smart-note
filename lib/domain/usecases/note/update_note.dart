import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/note.dart';
import '../../repositories/note_repository.dart';

class UpdateNote implements UseCase<Note, UpdateNoteParams> {
  final NoteRepository repository;

  UpdateNote(this.repository);

  @override
  Future<Either<Failure, Note>> call(UpdateNoteParams params) async {
    return await repository.updateNote(params.note);
  }
}

class UpdateNoteParams extends Equatable {
  final Note note;

  const UpdateNoteParams({required this.note});

  @override
  List<Object> get props => [note];
}
