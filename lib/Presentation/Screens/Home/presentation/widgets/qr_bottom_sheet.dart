import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/bottom_sheet_content.dart';
import 'package:spade_lite/Presentation/Screens/Profile/widget/custom_badge.dart';

class QRBottomSheet {
  static Widget buildQRBottomSheet(double screenHeight, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: Container(
        height: screenHeight * 0.8,
        width: double.infinity,
        color: const Color(0xFF232323),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 250,
                height: 250,
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   border: Border.all(
                //     color: Colors.blue, // Set your desired border color
                //     width: 2.0, // Set your desired border width
                //   ),
                // ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/Ellipse 368.png'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomBadge(text: "1.2k Followers", imagePath: ""),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              BottomSearchSheet.buildBottomSheetContent(
                                  MediaQuery.of(context).size.height),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                        );
                      },
                      child: const CustomBadge(
                          text: "", imagePath: "assets/images/search-2.png"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
