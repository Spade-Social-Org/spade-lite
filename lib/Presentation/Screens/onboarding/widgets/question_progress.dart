// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class QProgess extends StatelessWidget {
  final int index;
  const QProgess({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    double value = 0.04 * index;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question $index/25",
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black)),
          child: Container(
            width: MediaQuery.of(context).size.width * value,
            color: Colors.black,
            height: 5,
          ),
        )
      ],
    );
  }
}
