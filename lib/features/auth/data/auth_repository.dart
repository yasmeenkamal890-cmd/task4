import 'package:dio/dio.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.accessToken,
  });

  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String accessToken;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: (json['id'] as num?)?.toInt() ?? 0,
        username: json['username'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        image: json['image'] as String? ?? '',
        accessToken: json['accessToken'] as String? ?? '',
      );
}

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'username': username.trim(),
        'password': password,
        'expiresInMins': 60,
      },
    );
    return AuthUser.fromJson(response.data as Map<String, dynamic>);
  }
}
