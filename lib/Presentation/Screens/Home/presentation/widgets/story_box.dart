import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/theme.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';

class StoryBox extends ConsumerWidget {
  final Feed feed;
  final bool isLoad;
  const StoryBox({
    super.key,
    required this.feed,
    this.isLoad = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (isLoad)
          Container(
            height: 46,
            width: 46,
            decoration: const ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage("https://via.placeholder.com/51x46"),
                fit: BoxFit.cover,
              ),
              shape: CircleBorder(),
            ),
          )
        else
          Container(
            height: 46,
            width: 46,
            decoration: const ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: CustomColors.greenPrimary,
                  width: 2,
                ),
              ),
            ),
            child: Container(
              decoration: ShapeDecoration(
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      feed.posterImage ?? AppConstants.defaultImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        4.spacingH,
        SizedBox(
          width: 50,
          child: Text(
            feed.posterName ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
