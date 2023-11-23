import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spade_v4/Common/constants.dart';
import 'package:spade_v4/Common/routes/app_routes.dart';
import 'package:spade_v4/Common/theme.dart';
import 'package:spade_v4/Common/utils/extensions/date_extensions.dart';
import 'package:spade_v4/Common/utils/utils.dart';
import 'package:spade_v4/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_v4/Presentation/Screens/Home/presentation/widgets/profile_image.dart';
import 'package:spade_v4/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_v4/Common/blurred_background_image.dart';
import 'package:spade_v4/Presentation/widgets/jh_logger.dart';
import 'package:spade_v4/prefs/local_data.dart';
import 'package:spade_v4/resources/resources.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends ConsumerStatefulWidget {
  final int startIndex;
  const StoryPageView({super.key, required this.startIndex});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends ConsumerState<StoryPageView>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  //final bool _isKeyboardOpen = false;
  final _storyController = StoryController();

  final _textController = TextEditingController();

  final _textFocusNode = FocusNode();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.startIndex,
    );
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0) {
      _storyController.pause();
    } else {
      _storyController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(feedProvider).storyModel?.data ?? [];
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: stories.length,
        itemBuilder: ((context, index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Story(
                  storyController: _storyController,
                  feed: stories[index],
                  onStoryComplete: () {
                    if (index == stories.length - 1) {
                      pop(context);
                      return;
                    }
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  onNext: () {
                    if (index == stories.length - 1) {
                      pop(context);
                      return;
                    }
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  onPrev: () {
                    if (index == 0) return;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  onDown: () {
                    pop(context);
                  },
                  onUp: () {
                    _textFocusNode.requestFocus();
                  },
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 20,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ProfileImage(
                              imageUrl: stories[index].posterImage ??
                                  AppConstants.defaultImage,
                            ),
                            4.spacingW,
                            Text(stories[index].createdAt?.formatTime ?? ''),
                          ],
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
                Positioned(
                  bottom: MediaQuery.paddingOf(context).bottom + 20,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _textFocusNode,
                            controller: _textController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              hintText: 'Message...',
                              hintStyle: CustomTextStyle.small12.white,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _textController.clear();
                                  _textFocusNode.unfocus();
                                },
                                icon: SvgPicture.asset(SpiderSvgAssets.send),
                              ),
                            ),
                            style: CustomTextStyle.small12.white,
                          ),
                        ),
                        FeedButton(stories[index]),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(SpiderSvgAssets.locationArrow),
                        ),
                      ],
                    ).pSymmetric(h: 20),
                  ),
                ),
              ],
            ),
          );
        }),
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

class Story extends ConsumerStatefulWidget {
  final Feed feed;
  final Function() onNext;
  final Function() onPrev;
  final Function() onDown;
  final Function() onUp;
  final Function() onStoryComplete;
  final StoryController storyController;
  const Story({
    super.key,
    required this.feed,
    required this.onNext,
    required this.onPrev,
    required this.onDown,
    required this.onUp,
    required this.onStoryComplete,
    required this.storyController,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StoryState();
}

class _StoryState extends ConsumerState<Story> {
  @override
  Widget build(BuildContext context) {
    return StoryView(
      controller: widget.storyController,
      storyItems: widget.feed.gallery?.map(
            (e) {
              LocalData.instance.setStoryViewed(e);

              if (e.endsWith('mp4')) {
                return StoryItem.pageVideo(
                  e,
                  controller: widget.storyController,
                );
              }
              return StoryItem(
                BlurBackgroundImage(
                  imageUrl: e,
                  height: double.infinity,
                  width: double.infinity,
                ),
                duration: const Duration(seconds: 3),
              );
            },
          ).toList() ??
          [],
      onVerticalSwipeComplete: (p0) {
        switch (p0) {
          case Direction.down:
            widget.onDown();
          case Direction.up:
            widget.onUp();
          case Direction.right:
            widget.onNext();
          case Direction.left:
            widget.onPrev();
          default:
            break;
        }
      },
      onComplete: widget.onStoryComplete,
      progressPosition: ProgressPosition.top,
      repeat: false,
      inline: true,
    );
  }
}
