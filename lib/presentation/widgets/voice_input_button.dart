import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/voice/voice_bloc.dart';
import '../bloc/voice/voice_event.dart';
import '../bloc/voice/voice_state.dart';

/// Widget for voice input functionality
class VoiceInputButton extends StatefulWidget {
  final Function(String) onTextRecognized;
  final VoidCallback? onListeningStarted;
  final VoidCallback? onListeningStopped;

  const VoiceInputButton({
    super.key,
    required this.onTextRecognized,
    this.onListeningStarted,
    this.onListeningStopped,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VoiceBloc, VoiceState>(
      listener: (context, state) {
        if (state is VoiceListening) {
          setState(() => _isListening = true);
          widget.onListeningStarted?.call();
          _showSnackBar(context, 'Listening...', Colors.blue);
        } else if (state is VoiceInputCompleted) {
          setState(() => _isListening = false);
          widget.onListeningStopped?.call();
          widget.onTextRecognized(state.recognizedText);
          _showSnackBar(context, 'Text recognized!', Colors.green);
        } else if (state is VoiceError) {
          setState(() => _isListening = false);
          widget.onListeningStopped?.call();
          _showSnackBar(context, state.message, Colors.red);
        }
      },
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (_isListening) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return IconButton(
            icon: Icon(
              Icons.mic,
              color: Color.lerp(
                Colors.red,
                Colors.red.shade900,
                _animationController.value,
              ),
              size: 24 + (_animationController.value * 4),
            ),
            tooltip: 'Stop Listening',
            onPressed: _stopListening,
          );
        },
      );
    }

    return IconButton(
      icon: const Icon(Icons.mic_none),
      tooltip: 'Start Voice Input',
      onPressed: _startListening,
    );
  }

  void _startListening() {
    context.read<VoiceBloc>().add(const StartVoiceInputEvent());
  }

  void _stopListening() {
    context.read<VoiceBloc>().add(const StopVoiceInputEvent());
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
