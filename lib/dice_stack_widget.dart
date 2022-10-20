import 'package:flutter/material.dart';
import 'constants.dart';
import 'dice_model.dart';

class DiceStackWidget extends StatelessWidget {
  String imagePath;
  int value;
  int scale;
  String? text;
  Type type;
  late FractionalOffset offset;
  late double size;

  DiceStackWidget(
      {Key? key,
      required this.imagePath,
      required this.value,
      required this.scale,
      required this.type,
      this.text})
      : super(key: key);

  FractionalOffset getOffset(Type type) {
    switch (type) {
      case D10:
        return const FractionalOffset(0.5, 0.3);
      case D4:
        return const FractionalOffset(0.5, 0.35);
      case D20:
        return const FractionalOffset(0.5, 0.58);
      case D8:
        return const FractionalOffset(0.5, 0.45);
      default:
        return const FractionalOffset(0.5, 0.5);
    }
  }

  double getDefSize(Type type, BuildContext context) {
    switch (type) {
      case DCustom:
        return MediaQuery.of(context).size.width / 4;
      // case D4: return const FractionalOffset(0.5, 0.4);
      // case D20: return const FractionalOffset(0.5, 0.55);
      // case D8: return const FractionalOffset(0.5, 0.45);
      default:
        return MediaQuery.of(context).size.width / 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = getDefSize(type, context)  / scale;
    offset = getOffset(type);
    return Stack(
      children: [
        Image.asset(imagePath, color: defSecClr),
        text != null ? Container()
        : Align(
          alignment: offset,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              color: defSecClr,
            ),
          ),
        ),
        Align(
            alignment: offset,
            child: Text(
              value.toString(),
              style: TextStyle(
                color: text != null ? defSecClr : defPriClr,
                fontSize: size,
                fontFamily: "MarkoOne",
                fontWeight: FontWeight.bold,
              ),
            )),
        text != null
            ? Align(
                alignment: const FractionalOffset(0.65, 0.87),
                child: Text(
                  text.toString(),
                  style: TextStyle(
                    color: defSecClr,
                    fontSize: size/3,
                    fontFamily: "MarkoOne",
                    fontWeight: FontWeight.bold,
                  ),
                ))
            : Container(),

      ],
    );
  }
}
