// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spade_lite/Common/api.dart';
import 'package:spade_lite/Common/api_handler/api_client_config.dart';
import 'package:spade_lite/Common/api_handler/api_handler_models.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Presentation/Screens/messages/models/chat_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/models/messages.dart';
import 'package:spade_lite/Presentation/Screens/messages/models/on_add_new_message_data_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/models/user_matches_response_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/chat_screen.dart';
import 'package:spade_lite/Presentation/Screens/notifications/models/notifications_model.dart';

final messagesProvider = StateNotifierProvider<MessagesProvider, MessagesRepo>(
  (ref) => MessagesProvider(ref),
);

class MessagesProvider extends StateNotifier<MessagesRepo> {
  final Ref ref;
  MessagesProvider(this.ref) : super(MessagesRepo()) {
    refreshData();
  }

  Future<void> refreshData() async {
    refreshMatches();
    refreshChats();
  }

  void onGoToChat({
    required String id,
    required String name,
    String? image,
  }) async {
    state = state
      ..currentChat = null
      ..currentChatData = (id: id, name: name, image: image);
    state = state.copyWith();
    push(const ChatScreen());
    final res = await state.fetchMessages(id: id);
    if (res.valid) {
      state = state.copyWith(
        currentChat: res.data,
        currentChatData: (id: id, name: name, image: image),
      );
    }
  }

  void onAddNewMessageData(OnAddNewMessageDataModel data) {
    if (data.senderId.toString() != state.currentChatData?.id) return;
    state = state.copyWith(
      currentChat: state.currentChat!
        ..data = [
          MessageData(
            content: data.content,
            createdAt: DateTime.now(),
            name: data.name,
            userId: data.senderId,
            image: state.currentChatData?.image,
          ),
          ...state.currentChat!.data,
        ],
    );
  }

  refreshMatches() async {
    final res = await state.fetchUserMatches();
    if (res.valid) {
      state = state.copyWith(
        userMatchesModel: res.data,
      );
    }
  }

  refreshChats() async {
    final res = await state.fetchUserChats();
    if (res.valid) {
      state = state.copyWith(
        chatsModel: res.data,
      );
    }
  }
}

class MessagesRepo {
  UserMatchesResponseModel? userMatchesModel;
  ChatsResponseModel? chatsModel;
  Messages? currentChat;
  ({String id, String name, String? image})? currentChatData;

  final BackendService _apiService = BackendService(
    Dio(),
  );

  MessagesRepo({
    this.userMatchesModel,
    this.chatsModel,
    this.currentChatData,
    this.currentChat,
  });

  Future<ResponseModel<Messages>> fetchMessages({required String id}) async {
    Response response = await _apiService.runCall(
      _apiService.dio.get(
        '${AppEndpoints.baseUrl}/api/v1/messages/$id',
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<Messages>(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: Messages.fromJson(response.data),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<UserMatchesResponseModel>> fetchUserMatches() async {
    Response response = await _apiService.runCall(
      _apiService.dio.get(
        '${AppEndpoints.baseUrl}/api/v1/users/matches',
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<UserMatchesResponseModel>(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: UserMatchesResponseModel.fromJson(response.data),
        // data: NotificationsModel.fromJson(testNotifData),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  Future<ResponseModel<ChatsResponseModel>> fetchUserChats() async {
    Response response = await _apiService.runCall(
      _apiService.dio.get(
        '${AppEndpoints.baseUrl}/api/v1/messages',
      ),
    );

    final num statusCode = response.statusCode ?? 000;

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<ChatsResponseModel>(
        valid: true,
        statusCode: statusCode,
        message: response.data['message'],
        data: ChatsResponseModel.fromJson(response.data),
        // data: NotificationsModel.fromJson(testNotifData),
      );
    }

    return ResponseModel(
      error: ErrorModel.fromJson(response.data),
      statusCode: statusCode,
      message: response.data['message'],
    );
  }

  MessagesRepo copyWith({
    UserMatchesResponseModel? userMatchesModel,
    ChatsResponseModel? chatsModel,
    Messages? currentChat,
    ({String id, String name, String? image})? currentChatData,
  }) {
    return MessagesRepo(
      userMatchesModel: userMatchesModel ?? this.userMatchesModel,
      chatsModel: chatsModel ?? this.chatsModel,
      currentChat: currentChat ?? this.currentChat,
      currentChatData: currentChatData ?? this.currentChatData,
    );
  }
}
