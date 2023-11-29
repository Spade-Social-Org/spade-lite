import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spade_lite/prefs/pref_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/model/chat_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/model/messages.dart';

import '../model/user_matches_response_model.dart';

final messageRepository = Provider((ref) => MessageRepository());

@riverpod
class MessageRepository {
  final _client = Client();
  final baseUrl = "https://spade-backend-v3-production.up.railway.app/api/v1";
  final box = GetStorage();

  Future<List<MessageData>> getUserMessages() async {
    final token = await PrefProvider.getUserToken();
    final id = await PrefProvider.getUserId();
    final response = await _client.get(Uri.parse("$baseUrl/messages/$id"),
        headers: {"Authorization": "Bearer $token"});
    final data = jsonDecode(response.body);
    box.write('messages', data);
    return Messages.fromJson(data).data;
  }

  Future<List<ChatsData>> getUserChats() async {
    final token = await PrefProvider.getUserToken();
    final response = await _client.get(Uri.parse("$baseUrl/messages"),
        headers: {"Authorization": "Bearer $token"});
    final data = jsonDecode(response.body);
    box.write('chats', data);
    return ChatsResponseModel.fromJson(data).data;
  }

  Future<List<UserMatchesResponseData>> getUserMatches() async {
    final token = await PrefProvider.getUserToken();
    final response = await _client.get(Uri.parse("$baseUrl/users/matches"),
        headers: {"Authorization": "Bearer $token"});
    final data = (jsonDecode(response.body)['data'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => UserMatchesResponseData.fromJson(e))
        .toList();
    return data;
  }
}
