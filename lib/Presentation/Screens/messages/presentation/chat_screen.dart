import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/widgets/messages_app_bar.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/widgets/messages_body.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/socket_provider.dart';
import 'package:spade_lite/resources/resources.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final i = ref.watch(socketProvider);
    return Scaffold(
      appBar: const MessagesAppBar(),
      body: const MessagesBody(),
      bottomSheet: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(
            //   height: 28,
            //   child: ListView.builder(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (BuildContext context, int index) {
            //       return InkWell(
            //         onTap: () {
            //           //
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.all(8),
            //           decoration: BoxDecoration(
            //             color: const Color(0xffF5F5F5),
            //             borderRadius: BorderRadius.circular(100),
            //           ),
            //           child: const Text(
            //             'Who is your celebrity crush?',
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 10,
            //             ),
            //           ),
            //         ).pOnly(r: 16),
            //       );
            //     },
            //   ),
            // ),
            // const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: TextField(
                controller: text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xffF5F5F5),
                  hintText: 'Message...',
                  suffixIcon: InkWell(
                    onTap: () {
                      ref.read(socketProvider.notifier).sendMessage(
                          text: text.text,
                          receiverId:
                              ref.read(messagesProvider).currentChatData?.id ??
                                  '');
                      text.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        SpiderSvgAssets.send,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ).pSymmetric(h: 24),
            30.spacingH,
          ],
        ),
      ),
    );
  }
}
