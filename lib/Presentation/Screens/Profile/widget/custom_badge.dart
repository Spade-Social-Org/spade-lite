import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final String imagePath;

  const CustomBadge({
    Key? key,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe3e3e7), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 12,
                      color: Color(0xff818181),
                      fontFamily: 'Inter-Medium',
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 9999,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
