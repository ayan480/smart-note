import 'package:equatable/equatable.dart';

enum AttachmentType { image, document, audio, video, other }

/// Attachment entity for note attachments
class Attachment extends Equatable {
  final String id;
  final String noteId;
  final String fileName;
  final String filePath;
  final AttachmentType type;
  final int fileSize;
  final DateTime createdAt;

  const Attachment({
    required this.id,
    required this.noteId,
    required this.fileName,
    required this.filePath,
    required this.type,
    required this.fileSize,
    required this.createdAt,
  });

  Attachment copyWith({
    String? id,
    String? noteId,
    String? fileName,
    String? filePath,
    AttachmentType? type,
    int? fileSize,
    DateTime? createdAt,
  }) {
    return Attachment(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    noteId,
    fileName,
    filePath,
    type,
    fileSize,
    createdAt,
  ];
}
