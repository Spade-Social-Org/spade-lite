import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Presentation/Screens/messages/models/chat_model.dart';

class MessageCard extends StatelessWidget {
  final ChatsData chat;
  final VoidCallback onTap;

  const MessageCard({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MaterialButton(
        onPressed: onTap,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(chat.image ?? AppConstants.defaultImage),
                    ),
                    Positioned(
                      right: -8,
                      top: -8,
                      child: HexagonWidget.flat(
                        width: 25,
                        color: Colors.blueGrey,
                        padding: 2.0,
                        // child: const Text(
                        //   '5',
                        //   style: TextStyle(
                        //       fontSize: 8,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          chat.name ?? '',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.circle,
                          color: Color(0xff1AACFF),
                          size: 8,
                        ),
                      ],
                    ),
                    Text(chat.latestMessage ?? ''),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    // Text(
                    //   timeSent,
                    //   style: const TextStyle(fontSize: 11, color: Colors.grey),
                    // ),
                    const SizedBox(height: 6),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset('assets/images/timer.png', height: 17),
                        const Positioned(
                          right: 3,
                          bottom: -3,
                          child: Text(
                            '5',
                            style: TextStyle(
                              fontSize: 8,
                              color: Color(0xff155332),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: const LinearProgressIndicator(
                value: 0.6,
                color: Color(0xffC8192D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
