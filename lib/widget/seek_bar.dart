import 'dart:ui';
import 'package:flutter/material.dart';

class VerticalSeekBar extends StatefulWidget {
  final Color thumbColor;
  final Color progressColor;
  final Color backgroundColor;
  final double currentVolume;
  final double maxValue;
  final Function onChangedValue;

  const VerticalSeekBar({
    super.key,
    required this.thumbColor,
    required this.progressColor,
    required this.backgroundColor,
    required this.currentVolume,
    required this.onChangedValue,
    required this.maxValue,
  });

  @override
  _VerticalSeekBarState createState() => _VerticalSeekBarState();
}

class _VerticalSeekBarState extends State<VerticalSeekBar> {
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.currentVolume;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 5.0,
        thumbShape: CustomSliderThumbShape(
          thumbRadius: 18,
        ),
        thumbColor: widget.thumbColor,
        overlayColor: Colors.transparent,
        activeTrackColor: widget.progressColor,
        inactiveTrackColor: widget.backgroundColor,
      ),
      child: Slider(
        value: _value,
        min: 0,
        max: widget.maxValue,
        divisions: 100,
        onChanged: (newValue) {
          widget.onChangedValue(newValue);
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}


class CustomSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  CustomSliderThumbShape({
    this.thumbRadius = 10.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    const double innerThumbRadius = 12.0;
    const double outerThumbRadius = 18.0;

    final Offset thumbCenter = center.translate(0, thumbRadius - outerThumbRadius);

    final Paint paint = Paint();
    paint.color = Colors.white38;
    canvas.drawCircle(thumbCenter, outerThumbRadius, paint);

    paint.color = Colors.white; // Set color for the inner circle
    canvas.drawCircle(thumbCenter, innerThumbRadius, paint);
  }
}

class CustomSliderTrackShape extends SliderTrackShape {
  final double defaultHeight;
  final double progressHeight;

  CustomSliderTrackShape({
    this.defaultHeight = 11.0,
    this.progressHeight = 4.0,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = isDiscrete ? progressHeight : defaultHeight;

    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset, // Corrected parameter name
        bool isDiscrete = false,
        bool isEnabled = false,
      }) {
    print("efrbgnh $secondaryOffset");
    final double trackHeight = isDiscrete ? progressHeight : defaultHeight;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final canvas = context.canvas;

    final Paint paint = Paint()
      ..color = Colors.white38
      ..strokeCap = StrokeCap.round
      ..strokeWidth = trackHeight;

    final Offset startPoint = trackRect.centerLeft;
    final Offset endPoint = trackRect.centerRight;

    canvas.drawLine(startPoint, endPoint, paint);

    canvas.drawCircle(thumbCenter, 2.0, paint);
    if (secondaryOffset != null) {
      canvas.drawCircle(secondaryOffset, 2.0, paint);
    }
  }
}

