import 'package:flutter/material.dart';

import '../../../model/responses/login_response_model.dart';
import '../../../model/requests/signup_request_model.dart';
import '../api_client.dart';

class AuthRepository {
  final _client = ApiClient.instance;

  Future<void> registerParent(SignupRequestModel model) async {
    await _client.post(
      'Auth/register/parent',
      body: model.toJson(),
    );
  }

  Future<LoginResponseModel> login(String email, String password) async {
    final response = await _client.post(
      'Auth/login',
      body: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(response as Map<String, dynamic>);
  }
  Future<bool> verifyParentPassword(
      String frontendId,
      String password,
      ) async {
    final response = await _client.post(
      'Auth/$frontendId/verify-child-password',
      body: {
        'password': password,
      },
    );
    debugPrint('VERIFY RESPONSE: $response');

    return response['success'] as bool? ?? false;
  }

  Future<void> logout(String userId) async {
    await _client.post('Auth/logout/$userId');
  }
}
