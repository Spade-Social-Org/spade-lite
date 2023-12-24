import 'package:flutter/material.dart';

class RoundedMarker extends StatelessWidget {
  const RoundedMarker({super.key, 
    required this.imageUrl,
    required this.type,
  });

  final String imageUrl;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: type == "single_searching"
              ? Colors.green
              : Colors.red, // Change this to your desired border color
          width: 3.0, // Change this to your desired border width
        ),
      ),
      child: CircleAvatar(
        radius: 30,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            width: 400,
            height: 400,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
      ),
    );
  }
}
