import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/custom_iconbutton.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/grouped_avatar.dart';
import 'package:spade_lite/resources/resources.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  const GroupChatScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
        title: Row(
          children: [
            const GroupedAvatar(),
            20.spacingW,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Friday Friends',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF818181),
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ],
        ),
        actions: [
          CustomIconButton(
            imageValue: 'calendar',
            onTap: () {},
            size: 20,
          ),
          CustomIconButton(
            imageValue: 'list',
            onTap: () {},
            size: 20,
          ),
        ],
      ),
      body: Center(
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
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xffF5F5F5),
                  hintText: 'Message...',
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      SpiderSvgAssets.send,
                      color: Colors.black,
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
