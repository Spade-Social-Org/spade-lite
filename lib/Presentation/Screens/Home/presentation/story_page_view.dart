import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spade_v4/Common/constants.dart';
import 'package:spade_v4/Common/routes/app_routes.dart';
import 'package:spade_v4/Common/theme.dart';
import 'package:spade_v4/Common/utils/utils.dart';
import 'package:spade_v4/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_v4/Presentation/Screens/Home/presentation/widgets/profile_image.dart';
import 'package:spade_v4/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_v4/Common/blurred_background_image.dart';
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
  final bool _isKeyboardOpen = false;
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
    final stories = ref.watch(feedProvider).feedModel?.data ?? [];
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
                        ProfileImage(
                          imageUrl: stories[index].posterImage ??
                              AppConstants.defaultImage,
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
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(SpiderSvgAssets.heartOutlined),
                        ),
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
      storyItems: widget.feed.gallery
              ?.map(
                (e) => StoryItem(
                  BlurBackgroundImage(
                    imageUrl: e,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  duration: const Duration(seconds: 3),
                ),
              )
              .toList() ??
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
