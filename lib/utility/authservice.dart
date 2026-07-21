import 'dart:convert';

import 'package:evahan/providers/userprovider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final bool success;
  final String message;
  final String? userId;
  final String? roleId;

  AuthResult({
    required this.success,
    required this.message,
    this.userId,
    this.roleId,
  });
}

class Authservice {
  static Future<AuthResult> login({
    required String username,
    required String password,
    required Userprovider userprovider,
    bool isDemo = false,
  }) async {
    final response = await http.post(
      Uri.parse('https://app.evahansevai.com/api/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
    await prefs.setBool('isLoggedIn', true);

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final String userId = responseData['user_data']['reg_id'].toString();
      final String roleId = responseData['user_data']['category_id']
          .toString();

      await prefs.setString('userid', userId);
      await prefs.setString('roleid', roleId);
      await prefs.setBool('is_demo_session', isDemo);

      userprovider.setUserId(userId, roleId);

      return AuthResult(
        success: true,
        message: responseData['message']?.toString() ?? '',
        userId: userId,
        roleId: roleId,
      );
    }

    return AuthResult(
      success: false,
      message: responseData['message']?.toString() ?? 'Login failed',
    );
  }

  static Future<bool> hasValidDemoSession() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool isDemoSession = prefs.getBool('is_demo_session') ?? false;
    final String userId = prefs.getString('userid') ?? '';
    return isLoggedIn && isDemoSession && userId.isNotEmpty;
  }
}
