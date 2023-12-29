import 'package:flutter/material.dart';

class DateSet extends StatelessWidget {
  const DateSet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'The date is set!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -25,
                      right: 0,
                      child: Transform.translate(
                        offset: const Offset(0, 50),
                        child: Transform.rotate(
                          angle: 0.25, // Adjust the angle as needed
                          child: _buildImage('assets/images/image1.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: 150,
                      child: Transform.translate(
                        offset: const Offset(0, 50),
                        child: Transform.rotate(
                          angle: -0.25, // Adjust the angle as needed
                          child: _buildImage('assets/images/image1.png'),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 115,
                      right: 100,
                      child: _buildHeartImage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'View Calender',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Image.asset(
        imagePath,
        width: 225,
        height: 225,
      ),
    );
  }

  Widget _buildHeartImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/date-heart.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
