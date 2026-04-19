import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/domain/entities/note.dart';
import 'package:smart_note/presentation/widgets/note_card.dart';

void main() {
  group('NoteCard Widget', () {
    late Note testNote;
    late bool onTapCalled;
    late bool onDeleteCalled;
    late bool onTogglePinCalled;
    late bool onToggleArchiveCalled;

    setUp(() {
      testNote = Note(
        id: '1',
        title: 'Test Note',
        content: 'Test Content',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        isPinned: false,
        isArchived: false,
      );

      onTapCalled = false;
      onDeleteCalled = false;
      onTogglePinCalled = false;
      onToggleArchiveCalled = false;
    });

    Widget buildNoteCard() {
      return MaterialApp(
        home: Scaffold(
          body: NoteCard(
            note: testNote,
            onTap: () => onTapCalled = true,
            onDelete: () => onDeleteCalled = true,
            onTogglePin: () => onTogglePinCalled = true,
            onToggleArchive: () => onToggleArchiveCalled = true,
          ),
        ),
      );
    }

    testWidgets('should display note title and content', (tester) async {
      await tester.pumpWidget(buildNoteCard());

      expect(find.text('Test Note'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('should display "Untitled" when title is empty', (
      tester,
    ) async {
      testNote = testNote.copyWith(title: '');
      await tester.pumpWidget(buildNoteCard());

      expect(find.text('Untitled'), findsOneWidget);
    });

    testWidgets('should show pin icon when note is pinned', (tester) async {
      testNote = testNote.copyWith(isPinned: true);
      await tester.pumpWidget(buildNoteCard());

      expect(find.byIcon(Icons.push_pin), findsOneWidget);
    });

    testWidgets('should not show pin icon when note is not pinned', (
      tester,
    ) async {
      await tester.pumpWidget(buildNoteCard());

      expect(find.byIcon(Icons.push_pin), findsNothing);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      await tester.pumpWidget(buildNoteCard());

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(onTapCalled, true);
    });

    testWidgets('should show popup menu when more button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildNoteCard());

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Pin'), findsOneWidget);
      expect(find.text('Archive'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should show attachment icon when note has attachments', (
      tester,
    ) async {
      testNote = testNote.copyWith(attachmentIds: ['att1', 'att2']);
      await tester.pumpWidget(buildNoteCard());

      expect(find.byIcon(Icons.attach_file), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should show reminder icon when note has reminder', (
      tester,
    ) async {
      testNote = testNote.copyWith(reminderId: 'reminder1');
      await tester.pumpWidget(buildNoteCard());

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('should display formatted date', (tester) async {
      await tester.pumpWidget(buildNoteCard());

      expect(find.text('Jan 01, 2024'), findsOneWidget);
    });

    testWidgets('should apply background color when set', (tester) async {
      testNote = testNote.copyWith(backgroundColor: '#FFFF0000');
      await tester.pumpWidget(buildNoteCard());

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, const Color(0xFFFF0000));
    });

    testWidgets('should use white background when no color is set', (
      tester,
    ) async {
      await tester.pumpWidget(buildNoteCard());

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.white);
    });
  });
}
