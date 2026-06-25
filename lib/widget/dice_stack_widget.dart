import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import '../constants.dart';
import '../core/dice_model.dart';

class DiceStackWidget extends StatelessWidget {
  final String imagePath;
  final int value;
  final int scale;
  final String? label;
  final Type type;
  final Color color;
  late FractionalOffset offset;
  late double fontSize = 10;

  static final gradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
    //stops: [0.1,0.99],
    colors: [defPriClr, defBtnClr],
    //colors: [Colors.white70, defBtnClr])
  );

  DiceStackWidget({
    Key? key,
    required this.imagePath,
    required this.value,
    required this.scale,
    required this.type,
    required this.color,
    this.label,
  }) : super(key: key);

  static FractionalOffset getOffset(Type type) {
    switch (type) {
      case D10:
      case DiceCustomSide:
        return const FractionalOffset(0.5, 0.3);
      case D4:
        return const FractionalOffset(0.5, 0.4);
      case D20:
        return const FractionalOffset(0.5, 0.63);
      case D8:
        return const FractionalOffset(0.5, 0.45);
      default:
        return const FractionalOffset(0.5, 0.5);
    }
  }

  static double getLabelFontSize(int value,Type type, double maxWidth) {
    switch (type) {
      case DiceInfinite:
        if (value > 9999) {
          return maxWidth / 8;
        } else if (value > 999) {
          return maxWidth / 6;
        } else if (value > 99) {
          return maxWidth / 5;
        } else {
          return maxWidth / 4;
        }
      case DiceCustomSide:
        if (value > 9999) {
          return maxWidth / 8;
        } else if (value > 99) {
          return maxWidth / 5;
        } else {
          return maxWidth / 3;
        }
      default:
        return maxWidth / 5;
    }
  }
  void setFontSize(double size){
    fontSize = size;
  }
  ///пересчитывает шрифт относительно размеров экрана
  void setFontSizeFromWidth(double maxWidth){
    fontSize = getLabelFontSize(value,type, maxWidth) / scale;
  }

  @override
  Widget build(BuildContext context) {
    offset = getOffset(type);
    return Stack(
      children: [
        SimpleShadow(
            offset: const Offset(9, 9), // Default: Offset(2, 2)
            color: Colors.black,//defBtnClr,
            sigma: 3.5,
            child: Image.asset(imagePath, color: color)),
        ///D6 достаточно только картинки, остальным же надо показать цифру
        if(type != D6..runtimeType)...[
          Align(
              alignment: offset!,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => DiceStackWidget.gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: defPriClr,
                    fontSize: fontSize,
                    fontFamily: "MarkoOne",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          ///DiceInfinite и DiceCustomSide нуждаются в дополнительной подписи
          if (label != null) ...[
            Align(
                alignment: type != DiceInfinite
                    ? const FractionalOffset(0.69, 0.89)
                    : const FractionalOffset(0.6, 0.7),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => DiceStackWidget.gradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    label.toString(),
                    style: TextStyle(
                      color: defSecClr,
                      fontSize: fontSize / 3,
                      fontFamily: "MarkoOne",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ],
        ],
      ],
    );
  }
}
