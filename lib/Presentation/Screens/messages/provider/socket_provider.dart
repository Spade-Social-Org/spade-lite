import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spade_lite/Presentation/Screens/messages/models/on_add_new_message_data_model.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';

import 'package:spade_lite/prefs/pref_provider.dart';

import '../../../../Common/api.dart';
import '../models/messages.dart';

final socketProvider = StateNotifierProvider<SocketProvider, SocketModel>(
    (ref) => SocketProvider(ref));

class SocketProvider extends StateNotifier<SocketModel> {
  final Ref ref;
  SocketProvider(this.ref) : super(SocketModel()) {
    initializeSocket();
  }
  StreamSocket streamSocket = StreamSocket();

  Future<void> initializeSocket() async {
    final token = await PrefProvider.getUserToken();
    final socket = IO.io(
        'https://spade-backend-v3-production.up.railway.app/',
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {...customHeader, 'authorization': 'Bearer $token'}).build());
    socket.onConnect((data) {});
    socket.onAny((event, data) {
      log('$event $data');
    });
    socket.on('message.private', (data) {
      ref.read(messagesProvider.notifier).onAddNewMessageData(
            OnAddNewMessageDataModel.fromJson(data),
          );
    });
    state = state.copyWith(socket: socket);
  }

  Future<void> sendMessage({String? text, String? receiverId}) async {
    log('send message $text $receiverId');
    state.socket!
        .emit('message.private', {'content': text, 'receiver_id': receiverId});
  }
}

class SocketModel {
  final IO.Socket? socket;
  SocketModel({this.socket});

  SocketModel copyWith({
    IO.Socket? socket,
  }) {
    return SocketModel(
      socket: socket ?? this.socket,
    );
  }
}

class StreamSocket {
  final _socketResponse = StreamController<Messages>();

  void Function(Messages) get addResponse => _socketResponse.sink.add;

  Stream<Messages> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
