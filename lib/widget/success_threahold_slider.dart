import 'package:flutter/material.dart';
import '../constants.dart';

class SuccessThresholdSlider extends StatelessWidget {
  const SuccessThresholdSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: defBtnClr,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Success Threshold $percent%'.toUpperCase(),
            style: defTs.copyWith(fontSize: 30)
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: defSecClr,
                inactiveTrackColor: defPriClr,
                thumbColor: defSecClr,
                overlayColor: defPriClr.withOpacity(0.5),
                thumbShape: DiamondSliderThumbShape()),
            child: Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class DiamondSliderThumbShape extends SliderComponentShape {
  final double radius;

  const DiamondSliderThumbShape({this.radius = 12.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
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
    final canvas = context.canvas;

    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final color = colorTween.evaluate(enableAnimation)!;

    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius, center.dy);
    path.close();

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }
}
