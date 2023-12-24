import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/theme.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/search_item.dart';
import 'package:spade_lite/Presentation/Screens/notifications/presentation/notification_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/feed_body.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/story_row.dart';
import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_lite/resources/resources.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);
    return GestureDetector(
      /* // check on swipe left
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          Camera().takeImage();
          //Navigator.of(context).pushNamed('/chat');
        }
      }, */
      child: Scaffold(
        backgroundColor: Colors.black,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                titleSpacing: 0,
                title: feedAppBar(context),
                backgroundColor: Colors.black,
                elevation: 0,
                scrolledUnderElevation: 0,
                floating: true,
                pinned: true,
                snap: true,
                bottom: const StoryRow(),
              ),
              if (feed.filePath != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        if (feed.filePath!.split('.').last != 'jpg')
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FutureBuilder(
                              future: VideoThumbnail.thumbnailData(
                                video: feed.filePath!,
                                imageFormat: ImageFormat.JPEG,
                                maxHeight: 50,
                                quality: 25,
                              ),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return const CircularProgressIndicator
                                      .adaptive();
                                }
                                return Image.memory(
                                  snapshot.data,
                                  fit: BoxFit.cover,
                                  height: 50,
                                );
                              },
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              File(feed.filePath!),
                              fit: BoxFit.cover,
                              height: 50,
                            ),
                          ),
                        16.spacingW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uploading...',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              8.spacingH,
                              LinearProgressIndicator(
                                value: (feed.uploadProgress ?? 0) <= 0
                                    ? null
                                    : feed.uploadProgress,
                                backgroundColor: const Color(0xff232323),
                                color: const Color(0xff818181),
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ],
                          ),
                        ),
                        if (feed.onRetryPost != null) ...[
                          16.spacingW,
                          ElevatedButton(
                            onPressed: () {
                              feed.onRetryPost!();
                            },
                            child: const Text('Retry'),
                          ),
                          16.spacingW,
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(feedProvider.notifier)
                                  .onCancelCreatePost();
                            },
                            child: const Text('Cancel'),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
            ];
          },
          body: const FeedBody(),
        ),
      ),
    );
  }

  Widget buildBottomSheetContent(double screenHeight) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: Container(
        height: screenHeight * 0.8,
        width: double.infinity,
        color: const Color(0xFF232323),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Search for people",
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: const Color(0xFF333333),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFF333333),
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        weight: 30,
                        size: 30,
                      ),
                      onPressed: () {}),
                ),
                textAlign: TextAlign.center,
                onSubmitted: (_) {},
              ),
              const Column(
                children: [
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @widgetFactory
  Widget feedAppBar(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: Text(
            'Feed',
            style: CustomTextStyle.heading5_20.white.w600,
          ),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) =>
                  buildBottomSheetContent(screenHeight),
              backgroundColor: Colors.transparent,
            );
          },
          child: Image.asset(
            SpiderImageAssets.personGroup,
            width: 23.35,
            height: 18.75,
          ),
        ),
        10.spacingW,
        InkWell(
          onTap: () {
            pushTo(context, const NotificationScreen());
          },
          child: Image.asset(
            SpiderImageAssets.mdiBellNotificationOutline,
            width: 18.75,
            height: 18.75,
          ),
        ),
      ],
    ).pOnly(l: 20, r: 20);
  }
}
