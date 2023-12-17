import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/messages/presentation/group_chat_screen.dart';
import '../widget/custom_iconbutton.dart';
import 'message_likes_tab.dart';

class MesssageLikes extends StatefulWidget {
  const MesssageLikes({super.key});

  @override
  State<MesssageLikes> createState() => _MesssageLikesState();
}

class _MesssageLikesState extends State<MesssageLikes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(top: 25),
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        title: const Text(
                          'Likes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          CustomIconButton(
                              color: Colors.grey,
                              imageValue: 'Camera',
                              onTap: () {},
                              size: 25),
                          CustomIconButton(
                              imageValue: 'person-group',
                              onTap: () {},
                              size: 23),
                          CustomIconButton(
                              imageValue: 'more-vert', onTap: () {}, size: 25)
                        ],
                        bottom: PreferredSize(
                            preferredSize: const Size(60, 230),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        items.length,
                                        (i) => Expanded(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                height: 150,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: items[i].color,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Image.asset(
                                                      items[i].icon),
                                                ),
                                              ),
                                            ))),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: SizedBox(
                                        height: 45,
                                        child: TextField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              fillColor:
                                                  const Color(0xfff5f5f5),
                                              filled: true,
                                              suffixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Image.asset(
                                                    'assets/images/search.png'),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                        ),
                                      )),
                                      const SizedBox(width: 8),
                                      CustomIconButton(
                                          imageValue: 'spade-filled',
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const MesssageLikes())),
                                          size: 22),
                                      CustomIconButton(
                                          imageValue: 'grid',
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const GroupChatScreen())),
                                          size: 20),
                                      CustomIconButton(
                                          imageValue: 'list',
                                          onTap: () => {},
                                          size: 20)
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                body: const MessageLikesTab())));
  }
}

List<BoxItems> items = [
  BoxItems(const Color(0xff8A8A8A), 'assets/images/spade-filled.png'),
  BoxItems(const Color(0xff0C964C), 'assets/images/diamond-fill.png'),
  BoxItems(const Color(0xffFFC727), 'assets/images/club-fill.png'),
  BoxItems(const Color(0xffFF0000), 'assets/images/heart-fill.png'),
];

class BoxItems {
  final Color color;
  final String icon;

  BoxItems(this.color, this.icon);
}
