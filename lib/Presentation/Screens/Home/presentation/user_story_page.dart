import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/story_page_view.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/profile_image.dart';
import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_lite/Common/blurred_background_image.dart';
import 'package:spade_lite/resources/resources.dart';
import 'package:story_view/story_view.dart';

class UserStoryPageView extends ConsumerStatefulWidget {
  const UserStoryPageView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends ConsumerState<UserStoryPageView> {
  final _storyController = StoryController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(userStoryProvider);
    final data = stories?.fold(
      Feed(
        posterName: stories.first.posterName,
        posterImage: stories.first.posterImage,
        createdAt: stories.first.createdAt,
        posterId: stories.first.posterId,
        bookmarked: stories.first.bookmarked,
        description: stories.first.description,
        id: stories.first.id,
        likedPost: stories.first.likedPost,
        gallery: [],
        numberOfLikes: stories.first.numberOfLikes,
      ),
      (value, element) => value.copyWith(
        gallery: [
          ...value.gallery ?? [],
          ...element.gallery ?? [],
        ],
      ),
    );
    if (data == null) return const Scaffold();
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Story(
              storyController: _storyController,
              feed: data,
              onNext: () {
                pop(context);
              },
              onPrev: () {
                pop(context);
              },
              onUp: () {
                pop(context);
              },
              onStoryComplete: () {
                pop(context);
              },
              onDown: () {
                pop(context);
              },
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 20,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileImage(
                      imageUrl: data.posterImage ?? AppConstants.defaultImage,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ).pSymmetric(h: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedButton extends ConsumerStatefulWidget {
  final Feed feed;
  const FeedButton(this.feed, {super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedButtonState();
}

class _FeedButtonState extends ConsumerState<FeedButton> {
  late bool isLiked;

  @override
  void initState() {
    isLiked = bool.tryParse(widget.feed.likedPost ?? '') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        setState(() {
          isLiked = !isLiked;
        });

        final newLike = await ref.read(feedProvider.notifier).likePost(
              action: isLiked,
              id: widget.feed.id!,
              isStory: false,
            );

        setState(() {
          isLiked = newLike;
        });
      },
      icon: SvgPicture.asset(
        isLiked ? SpiderSvgAssets.heart : SpiderSvgAssets.heartOutlined,
        width: 17.68,
        height: 16,
      ),
    );
  }
}
