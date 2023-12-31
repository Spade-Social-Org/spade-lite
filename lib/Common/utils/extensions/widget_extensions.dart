import 'package:flutter/material.dart';

final widgetExtensions = <String, Widget>{};

extension WidgetSpacing on num {
  SizedBox get spacingW => SizedBox(width: toDouble());
  SizedBox get spacingH => SizedBox(height: toDouble());
}

extension WidgetExtensions on Widget {
  Widget get visible => this;
  Widget get invisible => const SizedBox.shrink();
  Widget rounded(double radius) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );
}

extension WidgetPadding on Widget {
  @widgetFactory
  Widget pAll(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );

  @widgetFactory
  Widget pSymmetric({
    double h = 0,
    double v = 0,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: h,
          vertical: v,
        ),
        child: this,
      );

  @widgetFactory
  Widget pOnly({
    double l = 0,
    double t = 0,
    double r = 0,
    double b = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: l,
          top: t,
          right: r,
          bottom: b,
        ),
        child: this,
      );
}

// align widget horizontal

extension WidgetAlignHorizontal on Widget {
  /// puts widget in a row and aligns it to the left
  Widget get alignLeft => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          this,
        ],
      );

  /// puts widget in a row and aligns it to the right
  Widget get alignRight => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          this,
        ],
      );

  /// puts widget in a row and aligns it to the center
  Widget get alignCenter => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          this,
        ],
      );
}
