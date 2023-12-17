import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Common/theme.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/profile_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_lite/Presentation/Screens/messages/single/single_message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spade_lite/resources/resources.dart';
import 'package:video_player/video_player.dart';

class FeedBox extends ConsumerStatefulWidget {
  final Feed feed;
  final bool isLoad;
  const FeedBox({
    super.key,
    required this.feed,
    this.isLoad = false,
  });

  @override
  ConsumerState<FeedBox> createState() => _FeedBoxState();
}

class _FeedBoxState extends ConsumerState<FeedBox> {
  late bool isLiked;
  late bool isSaved;
  @override
  void initState() {
    isLiked = bool.tryParse(widget.feed.likedPost ?? '') ?? false;
    isSaved = bool.tryParse(widget.feed.bookmarked ?? '') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.isLoad)
              Container(
                width: 50.84,
                height: 46,
                decoration: const ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/51x46"),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                ),
              )
            else
              OvalProfileImage(
                imageUrl: widget.feed.posterImage ?? AppConstants.defaultImage,
              ),
            17.spacingW,
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feed.posterName ?? '',
                    style: CustomTextStyle.large16.white.w600,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.more_vert,
              color: Color(0xffB8B6B6),
            ),
          ],
        ),
        6.spacingH,
        Gallery(feed: widget.feed),
        8.spacingH,
        if (widget.isLoad)
          Row(
            children: [
              const Icon(Icons.more_vert),
              12.spacingW,
              const Icon(Icons.more_vert),
              const Spacer(),
              const Icon(Icons.more_vert),
            ],
          )
        else
          Row(
            children: [
              InkWell(
                onTap: () async {
                  setState(() => isLiked = !isLiked);
                  final newLike =
                      await ref.read(feedProvider.notifier).likePost(
                            action: isLiked,
                            id: widget.feed.id!,
                            isStory: false,
                          );
                  setState(() => isLiked = newLike);
                },
                child: SvgPicture.asset(
                  isLiked
                      ? SpiderSvgAssets.heart
                      : SpiderSvgAssets.heartOutlined,
                  width: 17.68,
                  height: 16,
                ),
              ),
              12.spacingW,
              IconButton(
                onPressed: () => push(SingleMessage(
                    userId: widget.feed.posterId!,
                    username: widget.feed.posterName!)),
                icon: SvgPicture.asset(
                  SpiderSvgAssets.message,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  setState(() => isSaved = !isSaved);
                  final newLike =
                      await ref.read(feedProvider.notifier).bookmarkPost(
                            action: isSaved,
                            id: widget.feed.id!,
                            isStory: false,
                          );
                  setState(() => isSaved = newLike);
                },
                child: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: isSaved ? Colors.white : const Color(0xff8A8A8A),
                  size: 20,
                ),
              ),
            ],
          ),
        10.spacingH,
        Text(widget.feed.description ?? '',
            style: CustomTextStyle.small12.white),
        10.spacingH,
        Text(
          timeago.format(widget.feed.createdAt ?? DateTime.now()),
          style: CustomTextStyle.extraSmall11
              .withColor(const Color(0xffB8B6B6))
              .withSize(10.2),
        ),
      ],
    );
  }
}

class Gallery extends StatefulWidget {
  const Gallery({
    super.key,
    required this.feed,
  });

  final Feed feed;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 260.0,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.feed.gallery?.map(
                (e) {
                  if (e.endsWith('mp4')) {
                    return FeedVideo(videoUrl: e);
                  }
                  return Container(
                    width: double.infinity,
                    height: 260,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(e),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ).toList() ??
              [],
        ),
        if ((widget.feed.gallery?.length ?? 0) > 1)
          Positioned(
            bottom: 27,
            child: Row(
              children: widget.feed.gallery
                      ?.mapIndexed(
                        (i, e) => Container(
                          width: 5.53,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: ShapeDecoration(
                            color: i == _current
                                ? const Color(0xFF0C964C)
                                : Colors.white,
                            shape: const OvalBorder(),
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ),
      ],
    );
  }
}

class FeedVideo extends StatefulWidget {
  final String videoUrl;
  const FeedVideo({
    super.key,
    required this.videoUrl,
  });

  @override
  State<FeedVideo> createState() => _FeedVideoState();
}

class _FeedVideoState extends State<FeedVideo> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.videoUrl,
      ),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
