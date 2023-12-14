import 'package:flutter/material.dart';

class GroupedAvatar extends StatelessWidget {
  const GroupedAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          Positioned(
            right: 0,
            top: 10,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          Positioned(
            bottom: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          Positioned(
            left: -10,
            top: 10,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
        ],
      ),
    );
  }
}
