import 'package:flutter/material.dart';
import 'package:spade_v4/Common/navigator.dart';
import 'package:spade_v4/Presentation/Screens/messages/single/single_message.dart';

import '../model/user_matches_response_model.dart';

class JokersList extends StatelessWidget {
  final List<UserMatchesResponseData> data;
  const JokersList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        data.length,
        (i) => MaterialButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => push(SingleMessage(
            userId: data[i].userId!,
            username: data[i].name!,
            post: '',
          )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(width: .2, color: const Color(0xff8A8A8A))),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/avatar.png',
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[i].name!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text('Hey! How are you today?')
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('3:40'),
                      Row(
                        children: [
                          MaterialButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            minWidth: 60,
                            height: 25,
                            color: Colors.black,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              'New',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 30)
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
