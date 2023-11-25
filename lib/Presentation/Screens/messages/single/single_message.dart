import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_v4/Presentation/Screens/messages/provider/socket_provider.dart';
import 'package:spade_v4/Presentation/Screens/messages/single/message_list.dart';
import 'package:spade_v4/Presentation/Screens/messages/single/message_textfield.dart';
import 'package:spade_v4/Presentation/Screens/messages/widget/custom_iconbutton.dart';
import 'package:flutter/material.dart';
import '../provider/message_provider.dart';

final messageFutureProvider =
    FutureProvider((ref) => ref.watch(messageProvider).getMessages());

class SingleMessage extends ConsumerStatefulWidget {
  final int userId;
  final String username;
  final String post;

  const SingleMessage(
      {super.key,
      required this.post,
      required this.userId,
      required this.username});

  @override
  ConsumerState<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends ConsumerState<SingleMessage> {
  final controller = TextEditingController();
  final scrollCtrl = ScrollController();

  void submit() {
    ref.read(socketProvider.notifier).sendMessage(
        text: controller.text.trim(), receiverId: widget.userId.toString());
    setState(() => controller.text = '');
    ref.invalidate(messageFutureProvider);
    scrollCtrl.animateTo(0.0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
          body: SafeArea(
              child: ref.watch(messageFutureProvider).when(
                  data: (data) {
                    final messages = groupBy(data, (key) => key.createdAt);
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        widget.username,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.circle,
                                          color: Color(0xff155332), size: 8)
                                    ],
                                  ),
                                  const Text('Online')
                                ],
                              ),
                              const Spacer(),
                              CustomIconButton(
                                  imageValue: 'video', onTap: () {}, size: 20),
                              CustomIconButton(
                                  imageValue: 'call', onTap: () {}, size: 20),
                              CustomIconButton(
                                  imageValue: 'calendar',
                                  color: Colors.grey,
                                  onTap: () {},
                                  size: 20),
                              CustomIconButton(
                                  imageValue: 'more-vert',
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            padding: EdgeInsets.all(0),
                                            content: SizedBox(
                                                height: 25,
                                                child:
                                                    Text('You are offline'))));
                                  },
                                  size: 20),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.keyboard_arrow_up)),
                        ),
                        const Divider(),
                        Expanded(
                          child: MessageList(
                              image: widget.post,
                              data: messages,
                              scrollController: scrollCtrl),
                        ),
                        const SizedBox(height: 8),
                        MessageTextfield(
                            onSubmitted: (_) => submit(),
                            onTap: () => submit(),
                            onChanged: (value) => setState(() {}),
                            controller: controller),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                  error: (e, t) => Text(e.toString()),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ))));
    });
  }
}
