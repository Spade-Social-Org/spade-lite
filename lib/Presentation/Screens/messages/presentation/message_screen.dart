import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/chat_screen.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/group_screen.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/widgets/matches_widget.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/widgets/messages_widget.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/message_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/single/single_message.dart';
import 'package:spade_lite/Presentation/Screens/notifications/presentation/notification_screen.dart';
import 'package:spade_lite/Common/navigator.dart';
import '../widget/custom_iconbutton.dart';
import '../widget/message_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  bool isSelected = false;
  int selectedTab = 0;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CustomIconButton(
            imageValue: 'bell',
            onTap: () {
              pushTo(context, const NotificationScreen());
            },
            size: 23,
            color: Colors.grey,
          ),
          CustomIconButton(
            imageValue: 'Camera',
            onTap: () {},
            size: 23,
            color: Colors.grey,
          ),
          CustomIconButton(
            imageValue: 'person-group',
            onTap: () {},
            size: 23,
          ),
          CustomIconButton(
            imageValue: 'more-vert',
            onTap: () {},
            size: 25,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Top 5 picks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          16.spacingH,
          const MatchesWidget(),
          const SizedBox(height: 20),
          const Expanded(
            child: MessagesWidget(),
          ),
        ],
      ),
    );
  }

  Color indicatorColor() {
    switch (selectedTab) {
      case 0:
        return const Color(0xff155332);
      case 1:
        return const Color(0xfff3495e);
      case 2:
        return const Color(0xff999999);
      case 3:
        return const Color(0xfffed557);
    }
    return Colors.white;
  }
}
