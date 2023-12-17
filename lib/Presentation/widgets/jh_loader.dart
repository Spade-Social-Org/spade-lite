import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class JHLoadingSpinner extends StatelessWidget {
  final Color color;
  final double size;

  const JHLoadingSpinner({
    super.key,
    this.color = Colors.white,
    this.size = 250.0,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: color,
      size: size,
    );
  }
}
