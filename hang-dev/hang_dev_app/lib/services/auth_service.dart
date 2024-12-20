import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hang_dev_app/models/login_response.dart';
import 'package:hang_dev_app/services/dio_service.dart';
import 'package:hang_dev_app/utils/secure_storage.dart';
import 'package:hang_dev_app/utils/user_manager.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  final Dio dio = DioService().getDio();
  final SecureStorage secureStorage = SecureStorage();

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  logout() async {
    try {
      await postLogout();
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      await secureStorage.deleteAccessToken();
      await secureStorage.deleteRefreshToken();
      UserManager().init();
    }
  }

  postLogout() async {
    String? accessToken = await secureStorage.readAccessToken();
    String? refreshToken = await secureStorage.readRefreshToken();
    await dio.post(
      '/auth/logout',
      data: {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      },
    );
  }

  Future<bool> isLogin() async {
    String? accessToken = await secureStorage.readAccessToken();
    String? refreshToken = await secureStorage.readRefreshToken();
    String? signupStatus = await secureStorage.readSignupStatus();
    if (accessToken == null || refreshToken == null || signupStatus != "true") {
      return false;
    } else {
      UserManager().setUserId(extractUserIdFromToken(accessToken));
      UserManager().setAccessToken(accessToken);
      UserManager().setRefreshToken(refreshToken);
      return true;
    }
  }

  loginWithKakao() async {
    String accessToken = await _getKakaoAccessToken();
    LoginResponse loginResponse = await postKakaoLogin(accessToken);
    await _saveTokens(loginResponse);
    return loginResponse;
  }

  loginWithApple() async {
    AuthorizationCredentialAppleID credit = await _getAppleToken();
    LoginResponse loginResponse =
        await postAppleLogin(credit.identityToken!, credit.authorizationCode);
    await _saveTokens(loginResponse);
    return loginResponse;
  }

  Future<void> _saveTokens(LoginResponse authResponse) async {
    if (authResponse.isSignUp == false) {
      await secureStorage.writeSignupStatus("true");
    } else {
      await secureStorage.writeSignupStatus("false");
    }
    await secureStorage.writeAccessToken(authResponse.accessToken);
    await secureStorage.writeRefreshToken(authResponse.refreshToken);
    UserManager().setUserId(extractUserIdFromToken(authResponse.accessToken!));
    UserManager().setAccessToken(authResponse.accessToken!);
    UserManager().setRefreshToken(authResponse.refreshToken!);
  }

  Future<LoginResponse> postKakaoLogin(String accessToken) async {
    try {
      var response = await dio
          .post('/auth/kakao/login', data: {"accessToken": accessToken});
      return LoginResponse.fromJson(response.data["data"]);
    } catch (error) {
      throw Exception("로그인 실패");
    }
  }

  Future<LoginResponse> postAppleLogin(
    String identityToken,
    String authorizationCode,
  ) async {
    try {
      var response = await dio.post(
        '/auth/apple/login',
        data: {
          "accessToken": identityToken,
          "authorizationCode": authorizationCode,
        },
      );
      return LoginResponse.fromJson(response.data["data"]);
    } catch (error) {
      throw Exception("로그인 실패");
    }
  }

  Future<String> _getKakaoAccessToken() async {
    OAuthToken? token;
    if (await isKakaoTalkInstalled()) {
      token = await _loginWithKakaoTalkApp();
    } else {
      token = await _loginWithKakaoAccount();
    }
    return token.accessToken;
  }

  _getAppleToken() async {
    AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    return credential;
  }

  Future<OAuthToken> _loginWithKakaoTalkApp() async {
    OAuthToken? token;
    try {
      token = await UserApi.instance.loginWithKakaoTalk();
      debugPrint('카카오톡으로 로그인 성공 ${token.accessToken}');
    } catch (error) {
      debugPrint('카카오톡으로 로그인 실패 $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        throw Exception("로그인 실패");
      }
      token = await _loginWithKakaoAccount();
    }
    return token;
  }

  Future<OAuthToken> _loginWithKakaoAccount() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      debugPrint('카카오계정으로 로그인 성공 ${token.accessToken}');
      return token;
    } catch (error) {
      debugPrint('카카오계정으로 로그인 실패 $error');
      throw Exception("로그인 실패");
    }
  }

  int extractUserIdFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);
    return payloadMap['userId'];
  }
}
