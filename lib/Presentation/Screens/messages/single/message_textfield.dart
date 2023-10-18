import 'package:flutter/material.dart';

class MessageTextfield extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController controller;
  const MessageTextfield(
      {super.key, required this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: 'Message...',
                fillColor: const Color(0xfff5f5f5),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50))),
          )),
          const SizedBox(width: 8),
          IconButton(
              onPressed: onTap,
              icon: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset('assets/images/send.png'),
              )),
        ],
      ),
    );
  }
}
