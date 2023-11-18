import 'package:flutter/material.dart';
import 'package:spade_lite/Common/theme.dart';

class OvalProfileImage extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  const OvalProfileImage({
    super.key,
    required this.imageUrl,
    this.borderColor = CustomColors.greenPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 50.84,
      decoration: ShapeDecoration(
        shape: OvalBorder(
          side: BorderSide(
            color: borderColor,
            width: 2,
          ),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final Color borderColor;
  const ProfileImage({
    super.key,
    required this.imageUrl,
    this.borderColor = CustomColors.greenPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: borderColor,
            width: 2,
          ),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
