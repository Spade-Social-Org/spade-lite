import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return const Padding(
      padding: EdgeInsets.only(left: 25, bottom: 20),
      child: SizedBox(
        height: 30,
        width: 200,
      ),
    );
  }
}
