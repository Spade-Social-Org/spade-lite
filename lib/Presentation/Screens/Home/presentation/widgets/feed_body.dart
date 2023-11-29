import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Presentation/Screens/Home/models/feed_model.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/feed_box.dart';
import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';

class FeedBody extends ConsumerStatefulWidget {
  const FeedBody({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedBodyState();
}

class _FeedBodyState extends ConsumerState<FeedBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        ref.read(feedProvider.notifier).fetchPosts(refreshToNew: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feeds = ref.watch(feedProvider);
    if (feeds.feedModel == null) {
      return ListView.builder(
        itemCount: 20,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (BuildContext context, int index) {
          return Skeletonizer(
            enabled: true,
            containersColor: Colors.grey,
            child: FeedBox(
              isLoad: true,
              feed: Feed(
                createdAt: DateTime.now(),
                description: 'adcaecdqwe wexwexewx cecwsxw c3ec',
                posterImage: AppConstants.defaultImage,
                posterName: 'Spider',
                gallery: [
                  AppConstants.defaultImage,
                ],
              ),
            ).pOnly(b: 20),
          );
        },
      );
    }
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref.read(feedProvider.notifier).fetchPosts(refreshToNew: true);
      },
      child: ListView.builder(
        itemCount: (feeds.feedModel?.data?.length ?? 0) + 1,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          if (index == (feeds.feedModel?.data?.length ?? 0)) {
            if (feeds.storyLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              ).alignCenter;
            } else {
              return const SizedBox.shrink();
            }
          }
          return FeedBox(
            feed: feeds.feedModel!.data![index],
          ).pOnly(b: 20);
        },
      ),
    );
  }
}
