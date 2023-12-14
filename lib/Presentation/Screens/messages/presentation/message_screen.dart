import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/chat_screen.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/group_screen.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/message_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/single/single_message.dart';
import 'package:spade_lite/Presentation/Screens/notifications/presentation/notification_screen.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/message_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/single/single_message.dart';
import '../group/group_message.dart';
import '../likes/message_likes.dart';
import '../widget/custom_iconbutton.dart';
import '../widget/message_card.dart';
import '../widget/message_tabs.dart';
import 'package:spade_lite/Presentation/Screens/notifications/presentation/notification_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool isSelected = false;
  int selectedTab = 0;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
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
        body: SingleChildScrollView(
          child: Column(
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
              SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        pushTo(context, const ChatScreen());
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/avatar.png'),
                          ),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.green),
                        ),
                      ).pOnly(r: 16),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 45,
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            fillColor: const Color(0xfff5f5f5),
                            filled: true,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset('assets/images/search.png'),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(50)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    )),
                    const SizedBox(width: 8),
                    CustomIconButton(
                        imageValue: 'spade-small',
                        color: Colors.grey,
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => const MesssageLikes())),
                        size: 22),
                    CustomIconButton(
                        imageValue: 'grid',
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => const GroupScreen())),
                        size: 20),
                    CustomIconButton(
                        imageValue: 'list',
                        color: isSelected ? indicatorColor() : Colors.grey,
                        onTap: () => setState(() => isSelected = !isSelected),
                        size: 20)
                  ],
                ),
              ),
              const SizedBox(height: 25),
              isSelected
                  ? MessageTabs(
                      selectedTab: selectedTab,
                      onTap: (i) => setState(() => selectedTab = i),
                      indicatorColor: indicatorColor())
                  : ref.watch(chatListFutureProvider).when(
                      data: (data) => data.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Image.asset('assets/images/empty-message.png',
                                      height: 200),
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
                          : Column(
                              children: data
                                  .map((e) => MessageCard(
                                      messageLength: '5',
                                      messageLengthColor: Colors.blueGrey,
                                      sender: e.name!,
                                      message: e.latestMessage!,
                                      onTap: () => push(SingleMessage(
                                            userId: e.userId!,
                                            username: e.name!,
                                          )),
                                      indicatorColor: const Color(0xff155332),
                                      timeSent: '5:40'))
                                  .toList(),
                            ),
                      error: (e, t) => const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink()),
            ],
          ),
        ),
      );
    });
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
