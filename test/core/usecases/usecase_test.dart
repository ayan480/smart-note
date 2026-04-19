import 'package:flutter_test/flutter_test.dart';
import 'package:smart_note/core/usecases/usecase.dart';

void main() {
  group('NoParams', () {
    test('should support value equality', () {
      final params1 = NoParams();
      final params2 = NoParams();

      expect(params1, equals(params2));
    });

    test('should have empty props', () {
      final params = NoParams();

      expect(params.props, isEmpty);
    });
  });
}
