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
        padding: const EdgeInsets.all(24),
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
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Maria Jane",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: 'Inter-Medium',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/images/qr.png",
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "mariajane_50",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Inter-Medium',
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ]),
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Spadecode",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "People can Snap or Scan your Spadecode to add you as a friend!",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Column(
                  children: [
                    InkWell(
                      child: SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Share Your Spade Code",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Save To Cameral Roll",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Share My Profile Link",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Share My Username",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
