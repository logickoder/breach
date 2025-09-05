import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/dto.dart';

Future<bool> checkIsLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final creds = prefs.getString('creds');
  if (creds == null || creds.isEmpty) return false;

  final data = LoginResponse.fromJson(jsonDecode(creds));
  return data.token.isNotEmpty && data.userId > 0;
}
