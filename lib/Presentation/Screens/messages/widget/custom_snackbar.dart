import 'package:flutter/material.dart';
import 'package:spade_lite/Common/navigator.dart';

void customSnackBar(data) =>
    ScaffoldMessenger.of(kNavigatorKey.currentContext!).showSnackBar(SnackBar(
        duration: const Duration(minutes: 1),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      onPressed: () =>
                          ScaffoldMessenger.of(kNavigatorKey.currentContext!)
                              .removeCurrentSnackBar(),
                      child: const Text(
                        'DISMISS',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ))),
            )
          ],
        )));
