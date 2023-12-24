import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/utils/extensions/date_extensions.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/models/messages.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

class MessagesBody extends ConsumerWidget {
  const MessagesBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final messages = ref.watch(messagesProvider).currentChat?.data;
    final userId = ref.watch(userIdProvider).value;
    if (messages == null || messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty-message.png', height: 200),
              const Text(
                'No Messages',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Text(
                'No messages here yet. Start a conversation with someone you swiped right on or added.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    } else {
      final newList = groupBy(
        messages,
        (p0) => p0.createdAt?.stripTime ?? DateTime.now(),
      );
      return ListView.separated(
        itemCount: newList.length ?? 0,
        reverse: true,
        separatorBuilder: (BuildContext context, int index) {
          return 10.spacingH;
        },
        padding: const EdgeInsets.only(
          bottom: 100,
          right: 30,
          left: 30,
        ),
        itemBuilder: (BuildContext context, int index) {
          final item = newList.entries.elementAt(index);

          return Column(
            children: [
              Text(
                item.key.formatDateWords,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              for (var j in item.value.reversed)
                ChatTile(
                    isSender: j.userId == int.parse(userId ?? '0'), item: j),
            ],
          );
        },
      );
    }
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.isSender,
    required this.item,
  });

  final bool isSender;
  final MessageData item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isSender) 70.spacingW,
        Expanded(
          child: Align(
            alignment:
                (isSender) ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: ShapeDecoration(
                color: isSender ? Colors.black : const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                    topLeft: isSender ? const Radius.circular(10) : Radius.zero,
                    topRight:
                        isSender ? Radius.zero : const Radius.circular(10),
                  ),
                ),
              ),
              child: Text(
                item.content ?? '',
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        if (!isSender) 70.spacingW,
      ],
    );
  }
}
