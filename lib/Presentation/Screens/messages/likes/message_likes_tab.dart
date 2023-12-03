import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Presentation/Screens/messages/provider/message_provider.dart';

import 'aces_grid.dart';
import 'jokers_list.dart';

class MessageLikesTab extends StatelessWidget {
  const MessageLikesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final matches = ref.watch(userMatchesFutureProvider);
      return Center(
          child: matches.when(
              data: (data) => DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                          indicatorWeight: 4,
                          labelColor: Color(0xff8A8A8A),
                          indicatorColor: Color(0xff8A8A8A),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [Tab(text: 'Jokers'), Tab(text: 'Aces')]),
                      const SizedBox(height: 8),
                      Expanded(
                          child: TabBarView(
                              children: [JokersList(data: data), const AcesGrid()])),
                      const SizedBox(height: 16),
                    ],
                  )),
              error: (e, t) => const SizedBox(),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  )));
    });
  }
}
