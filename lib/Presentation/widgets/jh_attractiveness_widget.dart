import 'dart:math';

import 'package:flutter/material.dart';

class AttractivenessWidget extends StatelessWidget {
  const AttractivenessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
      child: Container(
        // height: screenHeight * 0.8,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Attractiveness Analysis',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                      height: 2.0,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomCircularProgressBar(
                    width: 120.0, // Width of the circular progress bar
                    height: 120.0, // Height of the circular progress bar
                    progress: 0.5, // Progress value between 0.0 and 1.0
                    strokeWidth: 25.0, // Width of the progress bar line
                    color: Color.fromRGBO(21, 83, 50, 1),
                    value: 50, // Color of the progress bar
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Physical attraction can play a significant role in sparking a deeper connection',
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontFamily: 'Poppins', // Font family
                      fontSize: 12.0, // Font size
                      fontStyle: FontStyle.normal, // Font style
                      fontWeight: FontWeight.w400, // Font weight
                      letterSpacing: 0.0, // Letter spacing
                      height: 1.0, // Line height
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Here's a breakdown of how your physical attraction can play a significant role in sparking a deeper connection:",
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontFamily: 'Poppins', // Font family
                      fontSize: 12.0, // Font size
                      fontStyle: FontStyle.normal, // Font style
                      fontWeight: FontWeight.w600, // Font weight
                      letterSpacing: 0.0, // Letter spacing
                      height: 1.0, // Line height
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Container(
                // height: screenHeight * 0.36,
                width: screenWidth,

                decoration: const BoxDecoration(
                  color: Color.fromRGBO(21, 83, 50, 0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 290,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Physical',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 12.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w700, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "You both scored 60&% You find each other's physical features and appearance attractive, contributing to a strong initial chemistry.",
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w500, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                )
                              ],
                            ),
                          ),
                          RoundedContainer(
                            text: '60%',
                            backgroundColor: Color.fromRGBO(21, 83, 50, 1),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      // This creates a horizontal line
                      color: Color.fromRGBO(138, 138, 138, 0.20), // Line color
                      thickness: 2, // Line thickness
                      indent: 10, // Indent (space before the line)
                      endIndent: 10, // End indent (space after the line)
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 290,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Body Language',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 12.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w700, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "You both scored 90% Your high compatibility in communication enables open and meaningful conversations, fostering a deep understanding and connection between you two.",
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w500, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                )
                              ],
                            ),
                          ),
                          RoundedContainer(
                            text: '90%',
                            backgroundColor: Color.fromRGBO(21, 83, 50, 1),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      // This creates a horizontal line
                      color: Color.fromRGBO(138, 138, 138, 0.20), // Line color
                      thickness: 2, // Line thickness
                      indent: 10, // Indent (space before the line)
                      endIndent: 10, // End indent (space after the line)
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 290,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chemistry',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 12.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w700, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "You both scored 50% The overall chemistry between you two is remarkable, indicating a strong physical and emotional connection.",
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w500, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                )
                              ],
                            ),
                          ),
                          RoundedContainer(
                            text: '50%',
                            backgroundColor: Color.fromRGBO(21, 83, 50, 1),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      // This creates a horizontal line
                      color: Color.fromRGBO(138, 138, 138, 0.20), // Line color
                      thickness: 2, // Line thickness
                      indent: 10, // Indent (space before the line)
                      endIndent: 10, // End indent (space after the line)
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 290,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Style',
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 12.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w700, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "You both scored 75%. You appreciate each other's sense of style and grooming, which contributes to the attraction you feel towards one another.",
                                  style: TextStyle(
                                    color: Colors.black, // Text color
                                    fontFamily: 'Poppins', // Font family
                                    fontSize: 10.0, // Font size
                                    fontStyle: FontStyle.normal, // Font style
                                    fontWeight: FontWeight.w500, // Font weight
                                    height: 1.0, // Line height
                                  ),
                                )
                              ],
                            ),
                          ),
                          RoundedContainer(
                            text: '75%',
                            backgroundColor: Color.fromRGBO(21, 83, 50, 1),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      // This creates a horizontal line
                      color: Color.fromRGBO(138, 138, 138, 0.20), // Line color
                      thickness: 2, // Line thickness
                      indent: 10, // Indent (space before the line)
                      endIndent: 10, // End indent (space after the line)
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomCircularProgressBar extends StatefulWidget {
  final double width;
  final double height;
  final double progress;
  final double strokeWidth;
  final Color color;
  final int value;

  const CustomCircularProgressBar({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.value,
  });

  @override
  _CustomCircularProgressBarState createState() =>
      _CustomCircularProgressBarState();
}

class _CustomCircularProgressBarState extends State<CustomCircularProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(widget.width / 2.0), // Make it circular
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(10, 0), // Shadow offset
          ),
        ],
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: CircularProgressBarPainter(
              progress: widget.progress,
              strokeWidth: widget.strokeWidth,
              color: widget.color,
            ),
          ),
          Positioned(
              top: widget.height / 2.2,
              left: widget.width / 2.8,
              child: Text(
                '${widget.value}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.0,
                  height: 1.0,
                ),
              ))
        ],
      ),
    );
  }
}

class CircularProgressBarPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  CircularProgressBarPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromRGBO(238, 238, 238, 1) // Background color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);

    // Draw the background circle
    canvas.drawCircle(center, radius, paint);

    paint.color = color; // Set the color to the progress color

    final double sweepAngle = 360 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start angle
      degreesToRadians(sweepAngle), // Sweep angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class RoundedContainer extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const RoundedContainer({
    super.key,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(75.0), // Adjust the radius as needed
          ),
        ),
        Positioned(
          top: 15,
          left: 10,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white, // Text color
              fontSize: 12.0, // Font size
            ),
          ),
        ),
      ],
    );
  }
}
