import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/constants.dart';
import 'package:spade_lite/Common/utils/extensions/date_extensions.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/Common/utils/extensions/widget_extensions.dart';
import 'package:spade_lite/Presentation/Screens/notifications/models/notifications_model.dart';
import 'package:spade_lite/Presentation/Screens/notifications/providers/notification_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notifs = ref.watch(notificationsProvider);
    if (notifs.notfications == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.tune,
                color: Color(0xff818181),
              ),
            ),
          ],
        ),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    final groupedNotifs = groupBy<NotificationData, DateTime>(
      notifs.notfications?.data ?? [],
      (p0) => p0.createdAt!.stripTime,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune,
              color: Color(0xff818181),
            ),
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(notificationsProvider.notifier).refreshData();
        },
        child: ListView.builder(
          itemCount: groupedNotifs.length,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemBuilder: (BuildContext context, int index) {
            final entry = groupedNotifs.entries.elementAt(index);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeago.format(entry.key),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                15.spacingH,
                for (final notif in entry.value)
                  for (final notifData in <Likenotification>[
                    ...(notif.likenotifications ?? []),
                    ...(notif.messagenotifications ?? []),
                  ])
                    Container(
                      width: double.infinity,
                      height: 81,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3FC1C1C1),
                            blurRadius: 2.79,
                            offset: Offset(0, 2.79),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            notifData.senderImageUrl ??
                                AppConstants.defaultImage,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.noRepeat,
                            alignment: Alignment.center,
                          ).rounded(30),
                          12.spacingW,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notifData.description ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                5.spacingH,
                                const Text(
                                  'Click to see details',
                                  style: TextStyle(
                                    color: Color(0xFF818181),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          12.spacingW,
                          Text(
                            timeago.format(
                              notifData.createdAt ?? DateTime.now(),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF818181),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ).pSymmetric(v: 20);
          },
        ),
      ),
    );
  }
}
