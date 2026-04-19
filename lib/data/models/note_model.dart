import 'package:floor/floor.dart';
import '../../domain/entities/note.dart';

@Entity(tableName: 'notes')
class NoteModel {
  @PrimaryKey()
  final String id;

  final String title;
  final String content;
  final int createdAt;
  final int updatedAt;
  final String? backgroundColor;
  final String? backgroundImagePath;
  final String attachmentIds; // Stored as comma-separated string
  final String? reminderId;
  final int isPinned; // SQLite doesn't have boolean, use int (0 or 1)
  final int isArchived;
  final String tags; // Stored as comma-separated string

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.backgroundColor,
    this.backgroundImagePath,
    this.attachmentIds = '',
    this.reminderId,
    this.isPinned = 0,
    this.isArchived = 0,
    this.tags = '',
  });

  /// Convert domain entity to data model
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt.millisecondsSinceEpoch,
      updatedAt: note.updatedAt.millisecondsSinceEpoch,
      backgroundColor: note.backgroundColor,
      backgroundImagePath: note.backgroundImagePath,
      attachmentIds: note.attachmentIds.join(','),
      reminderId: note.reminderId,
      isPinned: note.isPinned ? 1 : 0,
      isArchived: note.isArchived ? 1 : 0,
      tags: note.tags.join(','),
    );
  }

  /// Convert data model to domain entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      backgroundColor: backgroundColor,
      backgroundImagePath: backgroundImagePath,
      attachmentIds: attachmentIds.isEmpty ? [] : attachmentIds.split(','),
      reminderId: reminderId,
      isPinned: isPinned == 1,
      isArchived: isArchived == 1,
      tags: tags.isEmpty ? [] : tags.split(','),
    );
  }
}
