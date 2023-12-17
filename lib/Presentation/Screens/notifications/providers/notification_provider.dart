// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spade_lite/Common/api.dart';
import 'package:spade_lite/Common/api_handler/api_client_config.dart';
import 'package:spade_lite/Common/api_handler/api_handler_models.dart';
import 'package:spade_lite/Presentation/Screens/notifications/models/notifications_model.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsProvider, NotificationsRepo>(
  (ref) => NotificationsProvider(ref),
);

class NotificationsProvider extends StateNotifier<NotificationsRepo> {
  final Ref ref;
  NotificationsProvider(this.ref) : super(NotificationsRepo()) {
    refreshData();
  }

  Future<void> refreshData() async {
    final res = await state.uploadImage();

    if (res.valid) {
      res.data?.data = res.data?.data?.reversed.toList();
      state = state.copyWith(
        notfications: res.data,
      );
    }
  }
}

class NotificationsRepo {
  NotificationsModel? notfications;
  final BackendService _apiService = BackendService(
    Dio(),
  );

  NotificationsRepo({
    this.notfications,
  });

  Future<ResponseModel<NotificationsModel>> uploadImage() async {
    Response response = await _apiService.runCall(
      _apiService.dio.get(
        '${AppEndpoints.baseUrl}/api/v1/notifications',
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<NotificationsModel>(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: NotificationsModel.fromJson(response.data),
        // data: NotificationsModel.fromJson(testNotifData),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  NotificationsRepo copyWith({
    NotificationsModel? notfications,
  }) {
    return NotificationsRepo(
      notfications: notfications ?? this.notfications,
    );
  }
}

final testNotifData = {
  "statusCode": "SUCCESS",
  "data": [
    {
      "id": 3,
      "created_at": "2023-11-25T20:30:33.069Z",
      "updated_at": "2023-11-25T20:30:33.069Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 1,
          "created_at": "2023-11-25T20:30:33.161Z",
          "updated_at": "2023-11-25T20:30:33.161Z",
          "sender_Id": 4,
          "notification_id": 3,
          "message_id": 32,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 5,
      "created_at": "2023-11-25T20:33:37.949Z",
      "updated_at": "2023-11-25T20:33:37.949Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 3,
          "created_at": "2023-11-25T20:33:38.021Z",
          "updated_at": "2023-11-25T20:33:38.021Z",
          "sender_Id": 4,
          "notification_id": 5,
          "message_id": 34,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 6,
      "created_at": "2023-11-25T20:34:27.127Z",
      "updated_at": "2023-11-25T20:34:27.127Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 4,
          "created_at": "2023-11-25T20:34:27.182Z",
          "updated_at": "2023-11-25T20:34:27.182Z",
          "sender_Id": 4,
          "notification_id": 6,
          "message_id": 35,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 8,
      "created_at": "2023-11-25T20:44:08.202Z",
      "updated_at": "2023-11-25T20:44:08.202Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 6,
          "created_at": "2023-11-25T20:44:08.261Z",
          "updated_at": "2023-11-25T20:44:08.261Z",
          "sender_Id": 4,
          "notification_id": 8,
          "message_id": 37,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 11,
      "created_at": "2023-11-27T20:51:26.046Z",
      "updated_at": "2023-11-27T20:51:26.046Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 9,
          "created_at": "2023-11-27T20:51:26.977Z",
          "updated_at": "2023-11-27T20:51:26.977Z",
          "sender_Id": 4,
          "notification_id": 11,
          "message_id": 40,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 12,
      "created_at": "2023-11-27T20:54:32.161Z",
      "updated_at": "2023-11-27T20:54:32.161Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 10,
          "created_at": "2023-11-27T20:54:33.135Z",
          "updated_at": "2023-11-27T20:54:33.135Z",
          "sender_Id": 4,
          "notification_id": 12,
          "message_id": 41,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 13,
      "created_at": "2023-11-27T20:58:04.078Z",
      "updated_at": "2023-11-27T20:58:04.078Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 11,
          "created_at": "2023-11-27T20:58:04.997Z",
          "updated_at": "2023-11-27T20:58:04.997Z",
          "sender_Id": 4,
          "notification_id": 13,
          "message_id": 42,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 14,
      "created_at": "2023-11-27T21:09:17.664Z",
      "updated_at": "2023-11-27T21:09:17.664Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 12,
          "created_at": "2023-11-27T21:09:18.586Z",
          "updated_at": "2023-11-27T21:09:18.586Z",
          "sender_Id": 4,
          "notification_id": 14,
          "message_id": 43,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 15,
      "created_at": "2023-11-27T21:11:34.106Z",
      "updated_at": "2023-11-27T21:11:34.106Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 13,
          "created_at": "2023-11-27T21:11:35.103Z",
          "updated_at": "2023-11-27T21:11:35.103Z",
          "sender_Id": 4,
          "notification_id": 15,
          "message_id": 44,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 18,
      "created_at": "2023-11-27T21:19:31.394Z",
      "updated_at": "2023-11-27T21:19:31.394Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 16,
          "created_at": "2023-11-27T21:19:32.471Z",
          "updated_at": "2023-11-27T21:19:32.471Z",
          "sender_Id": 4,
          "notification_id": 18,
          "message_id": 48,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 23,
      "created_at": "2023-11-30T05:14:46.071Z",
      "updated_at": "2023-11-30T05:14:46.071Z",
      "type": "message",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [
        {
          "id": 21,
          "created_at": "2023-11-30T05:14:46.124Z",
          "updated_at": "2023-11-30T05:14:46.124Z",
          "sender_Id": 4,
          "notification_id": 23,
          "message_id": 53,
          "description": "Augustine sent you a message"
        }
      ],
      "likeNotifications": []
    },
    {
      "id": 35,
      "created_at": "2023-11-30T23:26:08.156Z",
      "updated_at": "2023-11-30T23:26:08.156Z",
      "type": "like",
      "is_read": false,
      "user_id": 5,
      "messageNotifications": [],
      "likeNotifications": [
        {
          "id": 14,
          "created_at": "2023-11-30T23:26:08.209Z",
          "updated_at": "2023-11-30T23:26:08.209Z",
          "liker_Id": 5,
          "notification_id": 35,
          "description": "new like from Victor "
        }
      ]
    }
  ],
  "message": "",
  "devMessage": ""
};
