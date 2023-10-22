import 'dart:convert';

import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spade_v4/prefs/pref_provider.dart';
import 'package:spade_v4/Presentation/Screens/messages/model/chat_model.dart';
import 'package:spade_v4/Presentation/Screens/messages/model/messages.dart';

import '../model/user_matches_response_model.dart';

final messageRepository = Provider((ref) => MessageRepository());

@riverpod
class MessageRepository {
  final _client = Client();
  final baseUrl = "https://spade-backend-v3-production.up.railway.app/api/v1";

  Future<List<MessageData>> getUserMessages() async {
    final token = await PrefProvider.getUserToken();
    final id = await PrefProvider.getUserId();
    final response = await _client.get(Uri.parse("$baseUrl/messages/$id"),
        headers: {"Authorization": "Bearer $token"});
    final data = jsonDecode(response.body);
    return Messages.fromJson(data).data;
  }

  Future<ChatsResponseModel> getUserChats() async {
    final token = await PrefProvider.getUserToken();
    final response = await _client.get(Uri.parse("$baseUrl/messages"),
        headers: {"Authorization": "Bearer $token"});
    final data = jsonDecode(response.body);
    return ChatsResponseModel.fromJson(data);
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
