import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/providers/locale_provider.dart'; 

void main() {
  group('LocaleProvider', () {
    test('початкова мова має бути українська (uk)', () {
      final provider = LocaleProvider();
      expect(provider.locale, const Locale('uk'));
    });

    test('метод setLocale змінює мову', () {
      final provider = LocaleProvider();
      
      provider.setLocale(const Locale('en'));
      expect(provider.locale, const Locale('en'));
    });
  });
}