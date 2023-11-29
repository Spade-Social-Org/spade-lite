import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:spade_lite/Common/api.dart';
import 'package:spade_lite/Common/api_handler/api_client_config.dart';
import 'package:spade_lite/Common/api_handler/api_handler_models.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Common/utils/string_exception.dart';
import 'package:spade_lite/Presentation/Screens/Buttom_nav/navigation_container.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/custom_snackbar.dart';
import 'package:spade_lite/Presentation/widgets/loading_dialog.dart';
import 'package:spade_lite/prefs/local_data.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

final profileImageProvider =
    NotifierProvider<ProfileImageProvider, ProfileImageRepo>(
        ProfileImageProvider.new);

class ProfileImageProvider extends Notifier<ProfileImageRepo> {
  @override
  build() {
    return ProfileImageRepo();
  }

  Future<void> saveProfilePicture(
    BuildContext context, {
    required String filePath,
  }) async {
    loadingDialog();

    final res = await state.uploadImage(
      filePath: filePath,
    );
    pop();
    if (res.valid) {
      pushAndRemoveUntil(const NavigationContainer());
    } else {
      customSnackBar(res.error!.message!);
    }
  }
}

class ProfileImageRepo {
  final BackendService _apiService = BackendService(
    Dio(),
  );

  ProfileImageRepo();

  Future<ResponseModel> uploadImage({
    required String filePath,
  }) async {
    final data = FormData();

    final file = await MultipartFile.fromFile(
      filePath,
      filename: filePath.split('/').last,
      contentType: MediaType('image', 'jpg'),
    );
    data.files.add(
      MapEntry('files', file),
    );

    Response response = await _apiService.runCall(
      _apiService.dio.post(
        '${AppEndpoints.baseUrl}/api/v1/users/image',
        data: data,
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: response.data,
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }
}
