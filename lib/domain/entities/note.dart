import 'package:equatable/equatable.dart';

/// Core Note entity representing a note in the domain layer
class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? backgroundColor;
  final String? backgroundImagePath;
  final List<String> attachmentIds;
  final String? reminderId;
  final bool isPinned;
  final bool isArchived;
  final List<String> tags;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.backgroundColor,
    this.backgroundImagePath,
    this.attachmentIds = const [],
    this.reminderId,
    this.isPinned = false,
    this.isArchived = false,
    this.tags = const [],
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? backgroundColor,
    String? backgroundImagePath,
    List<String>? attachmentIds,
    String? reminderId,
    bool? isPinned,
    bool? isArchived,
    List<String>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      attachmentIds: attachmentIds ?? this.attachmentIds,
      reminderId: reminderId ?? this.reminderId,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    createdAt,
    updatedAt,
    backgroundColor,
    backgroundImagePath,
    attachmentIds,
    reminderId,
    isPinned,
    isArchived,
    tags,
  ];
}
