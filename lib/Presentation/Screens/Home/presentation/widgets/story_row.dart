import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/theme.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/story_page_view.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/user_story_page.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/profile_image.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/story_box.dart';

import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_lite/prefs/local_data.dart';

class StoryRow extends ConsumerStatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(61);

  const StoryRow({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedBodyState();
}

class _FeedBodyState extends ConsumerState<StoryRow> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        ref.read(feedProvider.notifier).fetchStories(refreshToNew: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var stories = ref.watch(storyProvider);
    final feeds = ref.watch(feedProvider);
    if (stories == null) {
      return SizedBox(
        height: 61,
        child: ListView.builder(
          itemCount: 20,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (BuildContext context, int index) {
            return Skeletonizer(
              enabled: true,
              containersColor: Colors.grey,
              child: StoryBox(
                isLoad: true,
                feed: Feed(
                  createdAt: DateTime.now(),
                  description: 'adcaecdqwe wexwexewx cecwsxw c3ec',
                  posterImage: AppConstants.defaultImage,
                  posterName: 'Spider',
                  gallery: {
                    AppConstants.defaultImage,
                  },
                ),
              ).pOnly(r: 20),
            );
          },
        ),
      );
    }
    return SizedBox(
      height: 61,
      child: ListView.builder(
        itemCount: (stories.data?.length ?? 0) + 2,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                final userStory = ref.read(userStoryProvider);
                if (userStory?.isEmpty ?? true) {
                  FeedRepo.pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  pushTo(
                    context,
                    const UserStoryPageView(),
                  );
                }
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      const ProfileImage(
                        imageUrl: AppConstants.defaultImage,
                        borderColor: Color(0xFF7A7A7A),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF7A7A7A),
                            shape: OvalBorder(
                              side: BorderSide(width: 1, color: Colors.white),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  4.spacingH,
                  const Text(
                    'My Story',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                  )
                ],
              ).pOnly(r: 15),
            );
          } else if (index == ((stories.data?.length ?? 0) + 1)) {
            if (feeds.storyLoading) {
              return Skeletonizer(
                enabled: true,
                containersColor: Colors.grey,
                child: StoryBox(
                  isLoad: true,
                  feed: Feed(
                    createdAt: DateTime.now(),
                    description: 'adcaecdqwe wexwexewx cecwsxw c3ec',
                    posterImage: AppConstants.defaultImage,
                    posterName: 'Spider',
                    gallery: {
                      AppConstants.defaultImage,
                    },
                  ),
                ).pOnly(r: 20),
              ).alignCenter;
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return InkWell(
              onTap: () {
                pushTo(
                  context,
                  StoryPageView(startIndex: index - 1),
                );
              },
              child: StoryBox(
                feed: stories.data![index - 1],
                borderColor: stories.data![index - 1].gallery?.any((element) =>
                            LocalData.instance.isStoryViewed(element) ==
                            false) ??
                        false
                    ? CustomColors.greenPrimary
                    : Colors.grey,
              ).pOnly(r: 15),
            );
          }
        },
      ),
    );
  }
}
