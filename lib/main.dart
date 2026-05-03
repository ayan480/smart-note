import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'data/datasources/local/share_service.dart';
import 'domain/entities/note.dart';
import 'injection_container.dart' as di;
import 'presentation/bloc/note/note_bloc.dart';
import 'presentation/bloc/note/note_event.dart';
import 'presentation/pages/note_editor_page.dart';
import 'presentation/pages/notes_page.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ShareService _shareService = ShareService();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeShareListener();
  }

  void _initializeShareListener() {
    _shareService.initialize(
      onMediaShared: (List<SharedMediaFile> files) {
        _handleSharedMedia(files);
      },
      onTextShared: (String text) {
        _handleSharedText(text);
      },
    );
  }

  void _handleSharedMedia(List<SharedMediaFile> files) {
    // Create a new note with shared media
    final content = files
        .map((file) {
          return 'Shared file: ${file.path}\nType: ${file.type}';
        })
        .join('\n\n');

    _createNoteFromSharedContent('Shared Media', content);
  }

  void _handleSharedText(String text) {
    // Create a new note with shared text
    _createNoteFromSharedContent('Shared Content', text);
  }

  void _createNoteFromSharedContent(String title, String content) {
    final note = Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Navigate to note editor with the shared content
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => NoteEditorPage(note: note)),
    );

    // Reset shared data
    _shareService.reset();
  }

  @override
  void dispose() {
    _shareService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<NoteBloc>(),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Smart Notes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const NotesPage(),
      ),
    );
  }
}
