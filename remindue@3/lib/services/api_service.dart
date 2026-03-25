import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, dynamic> _parseResponse(http.Response response) {
    final bool isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    try {
      final dynamic decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return {
          ...decoded,
          'success': decoded['success'] is bool ? decoded['success'] : isSuccess,
          'statusCode': response.statusCode,
        };
      }

      return {
        'success': isSuccess,
        'statusCode': response.statusCode,
        'data': decoded,
      };
    } catch (_) {
      return {
        'success': isSuccess,
        'statusCode': response.statusCode,
        'message': response.body.isNotEmpty
            ? response.body
            : 'Unexpected response from server.',
      };
    }
  }

  // ─── GET ALL USERS ───────────────────────
  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: headers,
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── GET USER BY ID ──────────────────────
  static Future<Map<String, dynamic>> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── GET USER BY EMAIL ───────────────────
  static Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final String normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) {
      return {'success': false, 'message': 'Email is required'};
    }

    try {
      final String encodedEmail = Uri.encodeComponent(normalizedEmail);
      final response = await http.get(
        Uri.parse('$baseUrl/users/email/$encodedEmail'),
        headers: headers,
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── CREATE USER (REGISTER) ──────────────
  static Future<Map<String, dynamic>> createUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: headers,
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── UPDATE USER ─────────────────────────
  static Future<Map<String, dynamic>> updateUser(
    int userId, {
    String? username,
    String? email,
    String? password,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
        body: jsonEncode({
          if (username != null) 'username': username,
          if (email != null) 'email': email,
          if (password != null) 'password': password,
        }),
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ─── DELETE USER ─────────────────────────
  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: headers,
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
