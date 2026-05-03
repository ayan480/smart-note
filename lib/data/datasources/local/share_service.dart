import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Service for handling shared content from other apps
class ShareService {
  StreamSubscription? _intentDataStreamSubscription;
  StreamSubscription? _intentTextStreamSubscription;

  /// Initialize share listeners
  void initialize({
    required Function(List<SharedMediaFile>) onMediaShared,
    required Function(String) onTextShared,
  }) {
    // Listen for media files shared while app is in memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen(
          (List<SharedMediaFile> value) {
            if (value.isNotEmpty) {
              onMediaShared(value);
            }
          },
          onError: (err) {
            print('Error receiving shared media: $err');
          },
        );

    // Listen for text shared while app is in memory
    _intentTextStreamSubscription = ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        if (value.isNotEmpty) {
          onTextShared(value);
        }
      },
      onError: (err) {
        print('Error receiving shared text: $err');
      },
    );

    // Get initial shared media (when app is opened from share)
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        onMediaShared(value);
      }
    });

    // Get initial shared text (when app is opened from share)
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null && value.isNotEmpty) {
        onTextShared(value);
      }
    });
  }

  /// Reset shared data (call after processing)
  void reset() {
    ReceiveSharingIntent.reset();
  }

  /// Dispose resources
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    _intentTextStreamSubscription?.cancel();
  }
}
