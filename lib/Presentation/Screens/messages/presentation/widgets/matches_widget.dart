import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/messages_provider.dart';

class MatchesWidget extends ConsumerWidget {
  const MatchesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final matches = ref.watch(messagesProvider).userMatchesModel?.data;
    if (matches == null || matches.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        scrollDirection: Axis.horizontal,
        itemCount: matches.length,
        itemBuilder: (BuildContext context, int index) {
          final item = matches[index];
          return InkWell(
            onTap: () {
              ref.read(messagesProvider.notifier).onGoToChat(
                    id: item.userId!.toString(),
                    name: item.name!,
                    image: item.image,
                  );
              // pushTo(context, const ChatScreen());
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item.image ?? AppConstants.defaultImage),
                ),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.green),
              ),
            ).pOnly(r: 16),
          );
        },
      ),
    );
  }
}
