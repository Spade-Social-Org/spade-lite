import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/group_chat_screen.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/create_group_bottomsheet.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/grouped_avatar.dart';
import 'package:spade_lite/Presentation/Screens/notifications/presentation/notification_screen.dart';
import '../group/group_message.dart';
import '../likes/message_likes.dart';
import '../widget/custom_iconbutton.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool isSelected = false;
  int selectedTab = 0;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Groups',
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
                  'Top 5 groups',
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
                        pushTo(context, const GroupChatScreen());
                      },
                      child: const GroupedAvatar().pOnly(r: 16),
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
                                builder: (ctx) => const GroupMessage())),
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
              SizedBox(
                height: 40,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) =>
                                const CreateGroupBottomsheet(),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 43,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 12,
                          ),
                        ).pOnly(r: 12),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        pushTo(context, const GroupChatScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'New to the Area',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ).pOnly(r: 12),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              const Groups(),
              50.spacingH,
              const Groups(),
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

class Groups extends StatelessWidget {
  const Groups({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 181,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              pushTo(context, const GroupChatScreen());
            },
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/image.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Naija Club Chatter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ).pOnly(r: 12),
          );
        },
      ),
    );
  }
}
