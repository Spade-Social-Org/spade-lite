import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spade_lite/Presentation/Screens/messages/provider/message_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/single/single_message.dart';

import 'package:spade_lite/prefs/pref_provider.dart';

import '../../../../Common/api.dart';
import '../models/messages.dart';

final socketProvider = StateNotifierProvider<SocketProvider, SocketModel>(
    (ref) => SocketProvider(ref));

class SocketProvider extends StateNotifier<SocketModel> {
  final Ref ref;
  SocketProvider(this.ref) : super(SocketModel());
  StreamSocket streamSocket = StreamSocket();

  Future<void> initializeSocket() async {
    final token = await PrefProvider.getUserToken();
    final socket = IO.io(
        'https://spade-backend-v3-production.up.railway.app/',
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {...customHeader, 'authorization': 'Bearer $token'}).build());
    socket.onConnect((data) {});
    socket.on('message.private', (data) {
      streamSocket.addResponse;
      ref.invalidate(messageFutureProvider);
      ref.invalidate(chatListFutureProvider);
    });
    state = state.copyWith(socket: socket);
  }

  Future<void> sendMessage({String? text, String? receiverId}) async {
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
