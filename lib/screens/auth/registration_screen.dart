import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../home/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return "Будь ласка, введіть ім'я";
    if (value.length < 2) return "Ім'я має бути не менше 2 символів";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Будь ласка, введіть email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Введіть коректний email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Будь ласка, введіть пароль';
    if (value.length < 6) return 'Пароль має бути не менше 6 символів';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Пароль має містити велику літеру';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Пароль має містити цифру';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Будь ласка, підтвердіть пароль';
    if (value != _passwordController.text) return 'Паролі не співпадають';
    return null;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        await userCredential.user?.updateDisplayName(_nameController.text);
        await FirebaseAnalytics.instance.logEvent(
          name: 'sign_up',
          parameters: {
            'method': 'email',
            'user_id': userCredential.user?.uid ?? '',
          },
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Реєстрація успішна! Виконується вхід.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'Пароль занадто слабкий.';
            break;
          case 'email-already-in-use':
            errorMessage = 'Цей email вже використовується.';
            break;
          case 'invalid-email':
            errorMessage = 'Невірний формат email.';
            break;
          default:
            errorMessage = 'Помилка: ${e.message}';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Непередбачена помилка: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFB4B4B4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: isDesktop ? 400 : double.infinity),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Заголовок як у файлі 3
                    const Text(
                      'Education Plan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Створіть новий акаунт',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: isDesktop ? 32 : 48),

                    CustomTextField(
                      controller: _nameController,
                      hintText: "Введіть ваше ім'я",
                      labelText: "Ім'я",
                      prefixIcon: Icons.person_outlined,
                      validator: _validateName,
                    ),
                    SizedBox(height: isDesktop ? 16 : 20),

                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email (example@email.com)',
                      labelText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    SizedBox(height: isDesktop ? 16 : 20),

                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Пароль (мінімум 6 символів)',
                      labelText: 'Пароль',
                      prefixIcon: Icons.lock_outlined,
                      obscureText: !_isPasswordVisible,
                      validator: _validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                          size: isDesktop ? 18 : 20,
                        ),
                        onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 16 : 20),

                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Підтвердіть пароль',
                      labelText: 'Підтвердіть пароль',
                      prefixIcon: Icons.lock_outlined,
                      obscureText: !_isConfirmPasswordVisible,
                      validator: _validateConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                          size: isDesktop ? 18 : 20,
                        ),
                        onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 40),

                    CustomButton(
                      text: 'Зареєструватися',
                      onPressed: _register,
                      isLoading: _isLoading,
                      backgroundColor: const Color(0xFF2E8B32),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
