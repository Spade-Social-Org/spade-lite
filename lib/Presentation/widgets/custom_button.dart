import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final double? textSize;
  final Color? textColor;
  final BorderSide? borderSide;
  final AlignmentGeometry textAlign;
  final double? radius;
  final bool isLoading;
  final BorderSide? hasBorderside;

  const CustomButton({
    super.key,
    this.onPressed,
    this.textColor,
    this.text,
    this.color,
    this.child,
    this.width = double.infinity,
    this.height,
    this.borderSide,
    this.radius = 12,
    this.isLoading = false,
    this.textSize,
    this.textAlign = Alignment.center,
    this.hasBorderside,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading ? true : false,
      child: SizedBox(
        height: height ?? 54,
        width: width,
        child: MaterialButton(
          elevation: 0,
          highlightElevation: 0,
          onPressed: onPressed ?? () {},
          color: isLoading ? Colors.blueGrey.shade300 : color,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: hasBorderside ?? const BorderSide(color: Colors.white),
          ),
          child: child ??
              Align(
                alignment: textAlign,
                child: Text(text!,
                    style: TextStyle(
                        // Use the provided style or default to TextStyle
                        color: textColor ?? Colors.white,
                        fontSize: textSize ?? 18,
                        fontWeight: FontWeight.w600)),
              ),
        ),
      ),
    );
  }
}
