import 'package:get_storage/get_storage.dart';

import '../model/chat_model.dart';
import '../model/messages.dart';

class MessageLocalRepository {
  static final box = GetStorage();

  static Future<List<ChatsData>> getUserChats() async {
    final data = box.read<Map<String, dynamic>>('chats');
    return ChatsResponseModel.fromJson(data).data;
  }

  static Future<List<MessageData>> getUserMessages() async {
    final data = box.read<Map<String, dynamic>>('messages');
    return Messages.fromJson(data).data;
  }
}
