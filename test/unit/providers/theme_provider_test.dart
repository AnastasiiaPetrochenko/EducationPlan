import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/providers/theme_provider.dart'; 

void main() {
  group('ThemeProvider', () {
    test('початкова тема має бути ThemeMode.system', () {
      final provider = ThemeProvider();
      expect(provider.themeMode, ThemeMode.system);
    });

    test('метод setTheme змінює тему', () {
      final provider = ThemeProvider();
      
      provider.setTheme(ThemeMode.dark);
      expect(provider.themeMode, ThemeMode.dark);

      provider.setTheme(ThemeMode.light);
      expect(provider.themeMode, ThemeMode.light);
    });
  });
}