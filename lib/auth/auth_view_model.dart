import 'package:breach/app/logger.dart';
import 'package:flutter/material.dart';

import '../app/data/api_client.dart';
import 'domain/auth_screen_type.dart';

class AuthViewModel extends ChangeNotifier {
  static final _emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

  final AuthScreenType type;

  final email = TextEditingController();

  final password = TextEditingController();

  AuthViewModel(this.type) {
    email.addListener(_onTextChanged);
    password.addListener(_onTextChanged);
  }

  var _loading = false;

  var _buttonEnabled = false;

  bool get loading => _loading;

  bool get buttonEnabled => _buttonEnabled;

  Future<void> submit() async {
    if (_loading) return;

    try {
      _loading = true;
      notifyListeners();

      final path = switch (type) {
        AuthScreenType.signIn => 'login',
        AuthScreenType.signUp => 'register',
      };
      apiClient.post(
        '/auth/$path',
        data: {
          'email': email.text.trim(),
          'password': password.text,
        },
      );
    } catch (e, stackTrace) {
      logger.e('Auth error', error: e, stackTrace: stackTrace);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (type == AuthScreenType.signUp && value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _onTextChanged() {
    _buttonEnabled = (email.text.trim().isNotEmpty && password.text.isNotEmpty);
    notifyListeners();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
