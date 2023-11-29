import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Presentation/Screens/messages/repository/message_repository.dart';

import '../model/chat_model.dart';
import '../model/messages.dart';
import '../model/user_matches_response_model.dart';
import '../repository/message_local_repository.dart';

final chatListFutureProvider =
    FutureProvider((ref) => ref.watch(messageProvider).getUserChats());

final userMatchesFutureProvider =
    FutureProvider((ref) => ref.watch(messageProvider).getUserMatches());

final messageProvider = Provider((ref) => MessageProvider(ref));

class MessageProvider {
  final Ref ref;

  MessageProvider(this.ref);

  Future<List<MessageData>> getMessages() async {
    try {
      return await ref.watch(messageRepository).getUserMessages();
    } on SocketException catch (_) {
      return await MessageLocalRepository.getUserMessages();
    }
  }

  Future<List<ChatsData>> getUserChats() async {
    try {
      return await ref.watch(messageRepository).getUserChats();
    } on SocketException catch (_) {
      return await MessageLocalRepository.getUserChats();
    }
  }

  Future<List<UserMatchesResponseData>> getUserMatches() async {
    return await ref.watch(messageRepository).getUserMatches();
  }
}
