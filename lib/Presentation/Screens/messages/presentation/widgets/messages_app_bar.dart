import 'package:flutter/material.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/custom_iconbutton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MessagesAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context, ref) {
    final data = ref.watch(messagesProvider);
    final messages = data.currentChatData;
    return AppBar(
      toolbarHeight: 100,
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      title: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    NetworkImage(messages?.image ?? AppConstants.defaultImage),
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          20.spacingW,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    messages?.name ?? '',
                    style: const TextStyle(
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
    );
  }
}
