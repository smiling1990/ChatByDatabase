/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chatbydatabase/config/config.dart';

/// Created On 2019/12/2
/// Description: Circular progress indicator
///
class GradientCircularProgressIndicator extends StatelessWidget {
  GradientCircularProgressIndicator({
    this.stokeWidth = 2.0,
    @required this.radius,
    this.colors,
    this.stops,
    this.strokeCapRound = false,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.totalAngle = 2 * pi,
    this.text,
    this.textStyle,
    this.value,
  });

  /// Stoke Width
  final double stokeWidth;

  /// Radius
  final double radius;

  /// If round
  final bool strokeCapRound;

  /// [0.0-1.0]
  final double value;

  /// '15s'
  final String text;

  /// TextStyle
  final TextStyle textStyle;

  /// Background Color
  final Color backgroundColor;

  /// Progress total, common 2 * PI
  final double totalAngle;

  /// Gradient
  final List<Color> colors;

  /// Gradient end color
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    double _offset = .0;
    // Adjustment
    if (strokeCapRound) {
      _offset = asin(stokeWidth / (radius * 2 - stokeWidth));
    }
    var _colors = colors;
    if (_colors == null) {
      Color color = Theme.of(context).accentColor;
      _colors = [color, color];
    }
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: -pi / 2.0 - _offset,
            child: CustomPaint(
              size: Size.fromRadius(radius),
              painter: _GradientCircularProgressPainter(
                stokeWidth: stokeWidth,
                strokeCapRound: strokeCapRound,
                backgroundColor: backgroundColor,
                value: value,
                total: totalAngle,
                radius: radius,
                colors: _colors,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            text ?? '',
            style: textStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  decoration: TextDecoration.none,
                  fontSize: Config.bigTextSize_36,
                ),
          ),
        ),
      ],
    );
  }
}

/// Painter
class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter(
      {this.stokeWidth: 10.0,
      this.strokeCapRound: false,
      this.backgroundColor = const Color(0xFFEEEEEE),
      this.radius,
      this.total = 2 * pi,
      @required this.colors,
      this.stops,
      this.value});

  final double stokeWidth;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;
  final List<Color> colors;
  final double total;
  final double radius;
  final List<double> stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius);
    }
    double _offset = stokeWidth / 2.0;
    double _value = (value ?? .0);
    _value = _value.clamp(.0, 1.0) * total;
    double _start = .0;
    if (strokeCapRound) {
      _start = asin(stokeWidth / (size.width - stokeWidth));
    }
    Rect rect = Offset(_offset, _offset) &
        Size(size.width - stokeWidth, size.height - stokeWidth);
    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = stokeWidth;
    // Background
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, _start, total, false, paint);
    }
    // Gradient
    if (_value > 0) {
      paint.shader = SweepGradient(
        startAngle: 0.0,
        endAngle: _value,
        colors: colors,
        stops: stops,
      ).createShader(rect);

      canvas.drawArc(rect, _start, _value, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
