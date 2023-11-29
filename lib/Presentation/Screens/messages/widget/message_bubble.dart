import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

import '../model/messages.dart';

class MessageBubble extends StatelessWidget {
  final MessageData message;
  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final userId = ref.watch(userIdProvider).asData;
      if (userId == null) return const SizedBox.shrink();
      return Column(
        children: [
          Row(
              mainAxisAlignment: message.userId == int.parse(userId.value!)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                message.userId == int.parse(userId.value!)
                    ? const SizedBox.shrink()
                    : const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                const SizedBox(width: 8),
                Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: message.userId == int.parse(userId.value!)
                          ? const Color(0xffef0c28)
                          : const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(8),
                        topLeft: message.userId == int.parse(userId.value!)
                            ? const Radius.circular(8)
                            : const Radius.circular(0),
                        topRight: message.userId == int.parse(userId.value!)
                            ? const Radius.circular(0)
                            : const Radius.circular(8),
                        bottomRight: const Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          message.content!,
                          style: TextStyle(
                              color: message.userId == int.parse(userId.value!)
                                  ? Colors.white
                                  : Colors.black),
                        )))
              ])
        ],
      );
    });
  }
}
