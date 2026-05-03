import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_note/core/error/failures.dart';
import 'package:smart_note/data/datasources/local/voice_service.dart';
import 'package:smart_note/data/repositories/voice_repository_impl.dart';

@GenerateMocks([VoiceService])
import 'voice_repository_impl_test.mocks.dart';

void main() {
  late VoiceRepositoryImpl repository;
  late MockVoiceService mockVoiceService;

  setUp(() {
    mockVoiceService = MockVoiceService();
    repository = VoiceRepositoryImpl(voiceService: mockVoiceService);
  });

  group('startListening', () {
    test('should start listening when voice service succeeds', () async {
      // arrange
      when(
        mockVoiceService.startListening(onResult: anyNamed('onResult')),
      ).thenAnswer((_) async => {});

      // act
      final result = await repository.startListening();

      // assert
      expect(result, const Right(null));
    });

    test(
      'should return VoiceFailure when voice service throws exception',
      () async {
        // arrange
        when(
          mockVoiceService.startListening(onResult: anyNamed('onResult')),
        ).thenThrow(Exception('Microphone error'));

        // act
        final result = await repository.startListening();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<VoiceFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );
  });

  group('stopListening', () {
    const recognizedText = 'Hello world';

    test('should return recognized text when stopping listening', () async {
      // arrange
      when(
        mockVoiceService.stopListening(),
      ).thenAnswer((_) async => recognizedText);

      // act
      final result = await repository.stopListening();

      // assert
      expect(result, const Right(recognizedText));
      verify(mockVoiceService.stopListening());
    });
  });

  group('isSpeechAvailable', () {
    test('should return true when speech is available', () async {
      // arrange
      when(mockVoiceService.isSpeechAvailable()).thenAnswer((_) async => true);

      // act
      final result = await repository.isSpeechAvailable();

      // assert
      expect(result, const Right(true));
      verify(mockVoiceService.isSpeechAvailable());
    });

    test('should return false when speech is not available', () async {
      // arrange
      when(mockVoiceService.isSpeechAvailable()).thenAnswer((_) async => false);

      // act
      final result = await repository.isSpeechAvailable();

      // assert
      expect(result, const Right(false));
    });
  });

  group('requestMicrophonePermission', () {
    test('should return true when permission is granted', () async {
      // arrange
      when(
        mockVoiceService.requestMicrophonePermission(),
      ).thenAnswer((_) async => true);

      // act
      final result = await repository.requestMicrophonePermission();

      // assert
      expect(result, const Right(true));
      verify(mockVoiceService.requestMicrophonePermission());
    });

    test('should return false when permission is denied', () async {
      // arrange
      when(
        mockVoiceService.requestMicrophonePermission(),
      ).thenAnswer((_) async => false);

      // act
      final result = await repository.requestMicrophonePermission();

      // assert
      expect(result, const Right(false));
    });
  });

  group('startRecording', () {
    const filePath = '/path/to/recording.aac';

    test('should start recording when voice service succeeds', () async {
      // arrange
      when(mockVoiceService.startRecording(any)).thenAnswer((_) async => {});

      // act
      final result = await repository.startRecording(filePath);

      // assert
      expect(result, const Right(null));
      verify(mockVoiceService.startRecording(filePath));
    });

    test('should return VoiceFailure when recording fails', () async {
      // arrange
      when(
        mockVoiceService.startRecording(any),
      ).thenThrow(Exception('Recording error'));

      // act
      final result = await repository.startRecording(filePath);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<VoiceFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('stopRecording', () {
    const recordedFilePath = '/path/to/recording.aac';

    test('should return file path when stopping recording', () async {
      // arrange
      when(
        mockVoiceService.stopRecording(),
      ).thenAnswer((_) async => recordedFilePath);

      // act
      final result = await repository.stopRecording();

      // assert
      expect(result, const Right(recordedFilePath));
      verify(mockVoiceService.stopRecording());
    });

    test('should return VoiceFailure when path is null', () async {
      // arrange
      when(mockVoiceService.stopRecording()).thenAnswer((_) async => null);

      // act
      final result = await repository.stopRecording();

      // assert
      expect(result, const Left(VoiceFailure('Recording path is null')));
    });
  });
}
