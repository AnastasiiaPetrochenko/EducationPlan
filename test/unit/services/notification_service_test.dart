import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/services/notification_service.dart';

void main() {
  group('NotificationService — логіка планування', () {
    test('час у минулому — не викидає помилку', () async {
      final service = NotificationService();
      final pastTime = DateTime.now().subtract(const Duration(hours: 1));

      expect(
        () async => await service.scheduleNotification(
          1,
          'Тест',
          'Тіло',
          pastTime,
        ),
        returnsNormally,
      );
    });

    test('NotificationService є singleton', () {
      final a = NotificationService();
      final b = NotificationService();
      expect(identical(a, b), true);
    });
  });
}