import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/api.dart';
import 'package:spade_lite/Common/api_handler/api_client_config.dart';
import 'package:spade_lite/Common/api_handler/api_handler_models.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/changed_user_model.dart';

final notifProvider = StateNotifierProvider<NotifProvider, NotifService>((ref) {
  return NotifProvider(ref, NotifService());
});

class NotifProvider extends StateNotifier<NotifService> {
  final Ref ref;
  final NotifService repo;
  NotifProvider(this.ref, this.repo) : super(NotifService()) {
    sendFCMToken();
  }

  Future<void> sendFCMToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (event) async {
        state.updateUserProfile(
          ChangedUserModel(
            fcmToken: event,
          ),
        );
      },
    );
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return;
    state.updateUserProfile(
      ChangedUserModel(
        fcmToken: fcmToken,
      ),
    );
  }
}

class NotifService {
  final BackendService _apiService = BackendService(Dio());

  Future<ResponseModel> updateUserProfile(ChangedUserModel user) async {
    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/user/profile/update',
        data: user.toJson(),
      ),
    );

    final int statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.statusMessage,
        data: (response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }
}
