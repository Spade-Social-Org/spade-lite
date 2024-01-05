import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/notifications/models/notifications_model.dart';

class DecideScreen extends StatelessWidget {
  final Likenotification notification;

  const DecideScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // String place = (notification.description!.contains("invited you to")
    //     ? notification.description!
    //         .substring(
    //             notification.description!.indexOf("invited you to") +
    //                 "invited you to".length,
    //             notification.description!.length - 1)
    //         .trim()
    //     : "Error");
    String inviter = (notification.description!.contains("has invited you to")
        ? notification.description!
            .substring(
                0, notification.description!.indexOf("has invited you to"))
            .trim()
        : "Error");
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Date with $inviter',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        // Row(
        //   children: [
        //     Text(
        //       'Date with $inviter: ',
        //       style: const TextStyle(
        //         fontSize: 20,
        //       ),
        //     ),
        //     Text(
        //       place.length > 15 ? '${place.substring(0, 15)}...' : place,
        //       style: const TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ],
        // ),
      ),
      body: Center(
        child: Text(
          'Hello, this is the Decide Screen! ${notification.notificationId}',
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
