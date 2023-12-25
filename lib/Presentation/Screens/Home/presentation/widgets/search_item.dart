import 'package:flutter/material.dart';
import 'package:spade_lite/Common/routes/app_routes.dart';
import 'package:spade_lite/Common/theme.dart';
import 'package:spade_lite/Presentation/Screens/Profile/profile.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle row click
        pushTo(context, const Profile());
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assets/images/Ellipse 368.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset('assets/images/add.png',
                          width: 16, height: 16),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontWeight: FontWeightManager.semiBold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                // Handle close button press
              },
            )
          ],
        ),
      ),
    );
  }
}
