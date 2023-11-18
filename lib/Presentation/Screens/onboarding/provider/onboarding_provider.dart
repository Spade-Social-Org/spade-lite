import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/register_model.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/verify_email_model.dart';

import '../../../../Common/navigator.dart';
import '../../messages/widget/custom_snackbar.dart';
import '../model/login_model.dart';
import '../model/otp_model.dart';
import '../repository/auth_repositiory.dart';
import '../../../../prefs/pref_provider.dart';
import 'loading_state_provider.dart';

final onboardingProvider =
    ChangeNotifierProvider((ref) => OnboardingProvider(ref));

class OnboardingProvider with ChangeNotifier {
  final Ref ref;
  OnboardingProvider(this.ref);

  Future<ResponseModel> login(LoginModel model) async {
    final response =
        await runcallWithDialog<ResponseModel>(AuthRepository.login(model));
    if (response.statusCode == 'SUCCESS') {
      PrefProvider.saveUserToken(response.data!.accessToken!);
      PrefProvider.saveUserId(response.data!.userInfo!.userId!);
      //PrefProvider.saveUserModel(response.data!.userInfo!.userId!);
    } else if (response.statusCode == 'BAD_REQUEST') {
      customSnackBar(response.message);
    } else if (response.statusCode == 'FORBIDDEN') {
      customSnackBar(response.message);
    }
    pop();
    return response;
  }

  Future<RegisterResponseModel> register(RegisterModel model) async {
    final response = await runcallWithDialog(AuthRepository.register(model));
    if (response.statusCode == 'BAD_REQUEST') {
      customSnackBar(response.message);
    } else if (response.statusCode == 'FORBIDDEN') {
      customSnackBar(response.message);
    }
    pop();
    return response;
  }

  Future<ResponseModel> sendOTP(OTPModel model) async {
    final response = await runcallWithLoader<ResponseModel>(
        AuthRepository.sendOTP(model), ref);
    if (response.statusCode == 'SUCCESS') {
      customSnackBar('An OTP has been sent to your email successfully.');
    } else if (response.statusCode == 'BAD_REQUEST') {
      customSnackBar(response.message);
    } else if (response.statusCode == 'FORBIDDEN') {
      customSnackBar(response.message);
    }
    ref.watch(loadingStateProvider).setIsLoadingState(false);
    return response;
  }

  Future<ResponseModel> verifyOTP(String otp) async {
    final response = await runcallWithDialog<ResponseModel>(
        AuthRepository.verifyOTP(VerifyEmailModel(otp: otp)));
    if (response.statusCode == 'SUCCESS') {
      PrefProvider.saveUserId(response.data!.userInfo!.userId!);
      PrefProvider.saveUserToken(response.data!.accessToken!);
      customSnackBar('Email Verified, congratulations! 🎉🚀🚀');
    } else if (response.statusCode == 'BAD_REQUEST') {
      customSnackBar(response.message);
    } else if (response.statusCode == 'FORBIDDEN') {
      customSnackBar(response.message);
    }
    pop();
    return response;
  }
}
