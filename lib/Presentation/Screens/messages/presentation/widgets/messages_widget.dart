import 'package:flutter/material.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/group_screen.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/message_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/single/single_message.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/custom_iconbutton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/message_card.dart';

class MessagesWidget extends ConsumerStatefulWidget {
  const MessagesWidget({
    super.key,
  });

  @override
  ConsumerState<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends ConsumerState<MessagesWidget> {
  var query = '';
  @override
  Widget build(BuildContext context) {
    final messages = ref
        .watch(messagesProvider)
        .chatsModel
        ?.data
        .where(
          (element) => element.name!.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: const Color(0xfff5f5f5),
                      filled: true,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset('assets/images/search.png'),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomIconButton(
                  imageValue: 'grid',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const GroupScreen())),
                  size: 20),
            ],
          ),
        ),
        const SizedBox(height: 25),
        if (messages?.isEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: messages?.length ?? 0,
              separatorBuilder: (BuildContext context, int index) {
                return 30.spacingH;
              },
              itemBuilder: (BuildContext context, int index) {
                final item = messages![index];
                return MessageCard(
                  chat: item,
                  onTap: () {
                    ref.read(messagesProvider.notifier).onGoToChat(
                          id: item.userId!.toString(),
                          name: item.name!,
                          image: item.image,
                        );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
