import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:spade_lite/Common/api.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/login_model.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/otp_model.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/register_model.dart';

import '../model/verify_email_model.dart';

class AuthRepository {
  static final client = Client();

  static Future<ResponseModel> login(LoginModel model) async {
    var response = await client
        .post(Uri.parse("${baseUrl}auth/login"), body: model.toMap())
        .timeout(const Duration(seconds: 60));
    final data = jsonDecode(response.body);
    return ResponseModel.fromJson(data);
  }

  static Future<RegisterResponseModel> register(RegisterModel model) async {
    var response = await client
        .post(Uri.parse("${baseUrl}auth/signup"), body: model.toJson())
        .timeout(const Duration(seconds: 60));
    final data = jsonDecode(response.body);
    print(data);
    return RegisterResponseModel.fromJson(data);
  }

  static Future<ResponseModel> sendOTP(OTPModel model) async {
    var response = await client
        .post(Uri.parse("${baseUrl}auth/otp/send"),
            headers: {...customHeader}, body: jsonEncode(model.toMap()))
        .timeout(const Duration(seconds: 60));
    final data = jsonDecode(response.body);
    print(data);
    return ResponseModel.fromJson(data);
  }

  static Future<ResponseModel> verifyOTP(VerifyEmailModel model) async {
    var response = await client
        .post(Uri.parse("${baseUrl}auth/otp/verify"), body: model.toMap())
        .timeout(const Duration(seconds: 60));
    final data = jsonDecode(response.body);
    print(data);
    return ResponseModel.fromJson(data);
  }
}
