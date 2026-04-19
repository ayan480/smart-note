import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleArchive;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePin,
    required this.onToggleArchive,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = note.backgroundColor != null
        ? Color(int.parse(note.backgroundColor!.replaceFirst('#', '0xFF')))
        : Colors.white;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'Untitled' : note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    const Icon(Icons.push_pin, size: 18, color: Colors.black54),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      switch (value) {
                        case 'pin':
                          onTogglePin();
                          break;
                        case 'archive':
                          onToggleArchive();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'pin',
                        child: Row(
                          children: [
                            Icon(
                              note.isPinned
                                  ? Icons.push_pin_outlined
                                  : Icons.push_pin,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(note.isPinned ? 'Unpin' : 'Pin'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(Icons.archive_outlined, size: 20),
                            const SizedBox(width: 12),
                            Text(note.isArchived ? 'Unarchive' : 'Archive'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  note.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(note.updatedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (note.attachmentIds.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.attach_file, size: 14, color: Colors.grey[600]),
                    Text(
                      '${note.attachmentIds.length}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                  if (note.reminderId != null) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.notifications_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
