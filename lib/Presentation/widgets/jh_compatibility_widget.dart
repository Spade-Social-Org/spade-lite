import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spade_lite/Data/Models/discover_service.dart';
import 'package:spade_lite/Presentation/widgets/jh_activities_widget.dart';
import 'package:spade_lite/Presentation/widgets/jh_attractiveness_widget.dart';
import 'package:spade_lite/Presentation/widgets/jh_personality_widget.dart';
import 'package:spade_lite/Presentation/widgets/jh_value_widget.dart';

class JHCompatibilityWidget extends StatelessWidget {
  final String image;
  const JHCompatibilityWidget({super.key, required this.image});
  Future<void> _showBottomModal(BuildContext context) async {
    // Calculate 90% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double modalHeight = screenHeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0), // Adjust the top radius as needed
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // Set the height to 90% of the screen height
          height: modalHeight * 0.85,

          // padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                const SizedBox(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Icon(Icons.close_outlined, size: 30)),
                ),
              ]),
              const PersonalityWidget()
            ],
          ),
        );
      },
    );
  }

  Future<void> _showBottomModalAttract(BuildContext context) async {
    // Calculate 90% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double modalHeight = screenHeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0), // Adjust the top radius as needed
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // Set the height to 90% of the screen height
          height: modalHeight * 0.85,

          // padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                const SizedBox(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Icon(Icons.close_outlined, size: 30)),
                ),
              ]),
              const AttractivenessWidget()
            ],
          ),
        );
      },
    );
  }

  Future<void> _showBottomValue(BuildContext context) async {
    // Calculate 90% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double modalHeight = screenHeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0), // Adjust the top radius as needed
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // Set the height to 90% of the screen height
          height: modalHeight * 0.85,

          // padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                const SizedBox(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Icon(Icons.close_outlined, size: 30)),
                ),
              ]),
              const ValueWidget()
            ],
          ),
        );
      },
    );
  }

  Future<void> _showBottomModalAct(BuildContext context) async {
    // Calculate 90% of the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    double modalHeight = screenHeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0), // Adjust the top radius as needed
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          // Set the height to 90% of the screen height
          height: modalHeight * 0.85,

          // padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const SizedBox(),
                const SizedBox(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Icon(Icons.close_outlined, size: 30)),
                ),
              ]),
              const ActivitiesWidget()
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<DiscoverService>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            // color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20)),
        height: screenHeight * 0.6,
        width: screenWidth * 0.80,
        child: counterProvider.cardType == "default"
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(""),
                          Text('Match Insights',
                              style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(Icons.close_outlined, size: 30))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/Image 40.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: AssetImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          top: 15,
                          left: screenWidth * 0.34,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/love-round.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Discover Deeper Connections with Match Insights',
                      style: TextStyle(
                        color:
                            Color(0xFF000000), // Use the color code for black

                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      counterProvider.gotoNext("holder");
                    },
                    child: Container(
                      width: screenWidth * 0.78,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12.0), // Border radius
                        color: const Color(0xFFFFF6D9), // Background color
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.1), // Box shadow color
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/per-pie.png',
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Compatibility",
                                style: TextStyle(
                                  color: Color(
                                      0xFF1E1E1E), // Use the color code for #1E1E1E

                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                  width: screenWidth * 0.5,
                                  child: const Text(
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip,
                                    'Explore a detailed breakdown of your compatibility across various dimensions, from shared interests to core values',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    softWrap: true,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      counterProvider.gotoNext("analysis");
                    },
                    child: Container(
                      width: screenWidth * 0.78,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12.0), // Border radius
                        color: const Color(0xfffd2e6eb), // Background color
                        boxShadow: const [
                          BoxShadow(
                            color:
                                Color.fromRGBO(0, 0, 0, 0.1), // Box shadow color
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/probability.png',
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Probability",
                                style: TextStyle(
                                  color: Color(
                                      0xFF1E1E1E), // Use the color code for #1E1E1E

                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                  width: screenWidth * 0.5,
                                  child: const Text(
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip,
                                    'Our algorithms consider your preferences to estimate the likelihood of meeting your dream match.',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    softWrap: true,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : counterProvider.cardType == "holder"
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                counterProvider.goBack();
                              },
                              child: const Padding(
                                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child:
                                      Icon(Icons.arrow_back_ios, size: 30)),
                            ),
                            const Text('Compatibility',
                                style: TextStyle(
                                  color: Color(0xFF1E1E1E),
                                  fontSize: 20,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                )),
                            const Text(""),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/chart-graphic.png",
                          height: screenHeight < 800.0 ? 100 : 120,
                        )
                      ],
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/Image 40.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: AssetImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                      child: Text(
                        "You’ve got a lot in common! Let's explore the areas where you both have a strong connection",
                        style: TextStyle(
                          color: Color(
                              0xFF000000), // Use the color code for black

                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Column(
                      children: [
                        //Personality
                        GestureDetector(
                          onTap: () => {
                            // counterProvider.gotoNext('personality')
                            _showBottomModal(context),
                          },
                          child: Container(
                            width: screenWidth < 400 ? 300 : 350,
                            height: screenHeight < 800.0 ? 25 : 40,
                            padding:
                                const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  const Color.fromRGBO(119, 119, 119, 0.20),
                            ),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personality',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ), // First Text widget
                                CustomLinearProgressIndicator(
                                  progress: 0.9,
                                  color1: Color.fromRGBO(
                                      119, 119, 119, 0.20),
                                  color2: Color.fromRGBO(
                                      119, 119, 119, 1),
                                ),
                                Text(
                                  ' 90%',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ), // Second Text widget
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //Attractiveness
                        GestureDetector(
                          onTap: () => {
                            _showBottomModalAttract(context),
                          },
                          child: Container(
                            width: screenWidth < 400 ? 300 : 350,
                            height: screenHeight < 800.0 ? 25 : 40,
                            padding:
                                const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  const Color.fromRGBO(119, 119, 119, 0.20),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Attractiveness',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth < 400 ? 18 : 30,
                                ), // First Text widget
                                const CustomLinearProgressIndicator(
                                  progress: 0.5,
                                  color1: Color.fromRGBO(
                                      72, 72, 72, 0.20),
                                  color2:
                                      Color.fromRGBO(21, 83, 50, 1),
                                ),
                                SizedBox(
                                  width: screenWidth < 400 ? 30 : 45,
                                ), // First Text widget

                                const Text(
                                  ' 50%',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ), // Second Text widget
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //Value
                        GestureDetector(
                          onTap: () => {
                            _showBottomValue(context),
                          },
                          child: Container(
                            width: screenWidth < 400 ? 300 : 350,
                            height: screenHeight < 800.0 ? 25 : 40,
                            padding:
                                const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  const Color.fromRGBO(119, 119, 119, 0.20),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Value',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth < 400 ? 55 : 75,
                                ), // First Text widget
                                const CustomLinearProgressIndicator(
                                  progress: 0.35,
                                  color1: Color.fromRGBO(
                                      72, 72, 72, 0.20),
                                  color2:
                                      Color.fromRGBO(255, 199, 39, 1),
                                ),
                                SizedBox(
                                  width: screenWidth < 400 ? 25 : 45,
                                ), // First Text widget
                                const Text(
                                  ' 35%',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ), // Second Text widget
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        //Activities
                        GestureDetector(
                          onTap: () {
                            _showBottomModalAct(context);
                          },
                          child: Container(
                            width: screenWidth < 400 ? 300 : 350,
                            height: screenHeight < 800.0 ? 25 : 40,
                            padding:
                                const EdgeInsets.fromLTRB(12, 0, 12, 0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  const Color.fromRGBO(119, 119, 119, 0.20),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Activities',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth < 400 ? 40 : 55,
                                ), // First Text widget
                                const CustomLinearProgressIndicator(
                                  progress: 0.7,
                                  color1: Color.fromRGBO(
                                      72, 72, 72, 0.20),
                                  color2:
                                      Color.fromRGBO(161, 39, 24, 1),
                                ),
                                SizedBox(
                                  width: screenWidth < 400 ? 27 : 45,
                                ),
                                const Text(
                                  ' 70%',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle:
                                        FontStyle.normal, // Font style
                                    fontWeight:
                                        FontWeight.w500, // Font weight
                                    letterSpacing: 0.2, // Letter spacing
                                    height: 1.0, // Line height
                                  ),
                                ), // Second Text widget
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ) :
            counterProvider.cardType == "analysis"
      ?
                Container(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/proba-bg.png'), // Replace with your image path
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Stack(
                        // fit: StackFit.loose,
                        // alignment: Alignment.center,

                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  counterProvider.goBack();

                                },
                                child: const Padding(
                                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                    child:
                                    Icon(Icons.arrow_back_ios, size: 30)),
                              ),
                              const Text('Probability',
                                  style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                  )),
                              const Text(""),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(child: Image.asset("assets/images/analysis_options.png",height: screenHeight * 0.5, width: double.infinity,)),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            // width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color.fromRGBO(133, 171, 202, 0.5), // Use rgba color with opacity
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(40,20,40,12),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Age',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),
                                          Text('25 - 30',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 12,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Height',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),
                                          Text('5’5 - 6’0',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 12,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Religion',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),

                                          Text('Christians',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Ethnicity',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Text('🇲🇱',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),
                                          Text('')
                                        ],
                                      ),
                                      SizedBox(height: 12,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Salary',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),
                                          Text("\$60,000 - \$80,000",
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontFamily: 'Poppins', // Font family
                                              fontSize: 12, // Font size
                                              fontStyle: FontStyle.normal, // Font style
                                              fontWeight: FontWeight.w500, // Font weight
                                              height: 1.2, // Line height as a multiplier (120%)
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                // You can add content here if needed

                              ),
                            ),
                          ),
                        ],
                      )



                    ],
                  ),
                )
                : null,
      );

  }
}

class CustomLinearProgressIndicator extends StatefulWidget {
  final double progress;
  final Color color1;
  final Color color2;

  const CustomLinearProgressIndicator(
      {super.key, required this.progress, required this.color1, required this.color2});

  @override
  _CustomLinearProgressIndicatorState createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState
    extends State<CustomLinearProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0, // Width of the progress bar
      height: 5.0, // Height of the progress bar
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.color1,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: FractionallySizedBox(
        widthFactor: widget.progress,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color2, // Color of the progress bar
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
