import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import '../constants.dart';
import '../core/dice_model.dart';

class DiceStackWidget extends StatelessWidget {
  final String imagePath;
  final int value;
  final int scale;
  final String? text;
  final Type type;
  final Color color;
  late final  FractionalOffset offset;
  late final  double size;

  final gradient  =  const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode:  TileMode.clamp,
    //stops: [0.1,0.99],
    colors: [defPriClr,defBtnClr],
    //colors: [Colors.white70, defBtnClr])
  );

  DiceStackWidget(
      {Key? key,
      required this.imagePath,
      required this.value,
      required this.scale,
      required this.type,
        required this.color,
      this.text,
       })
      : super(key: key);

  FractionalOffset getOffset(Type type) {
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

  double getDefSize(Type type, BuildContext context) {
    switch (type) {
      case DiceInfinite: if(value > 9999 ){
        return MediaQuery.of(context).size.width / 8;
      } else if(value > 999 ){
        return MediaQuery.of(context).size.width / 6;
      } else if(value > 99){
        return MediaQuery.of(context).size.width / 5;
      } else {
        return MediaQuery.of(context).size.width / 4;
      }
      case DiceCustomSide: if(value > 9999 ){
        return MediaQuery.of(context).size.width / 8;
      } else if(value > 99){
        return MediaQuery.of(context).size.width / 5;
        } else{
    return MediaQuery.of(context).size.width / 3;
      }
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
        SimpleShadow(
            offset: const Offset(9, 9), // Default: Offset(2, 2)
            color: Colors.black,//defBtnClr,
            sigma: 3.5,
            child: Image.asset(imagePath, color: color)),//defSecClr
        // text != null ? Container()
        // : Align(
        //   alignment: offset,
        //   child: Container(
        //     height: size,
        //     width: size,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(size / 2),
        //       color: defSecClr,
        //     ),
        //   ),
        // ),
        Align(
            alignment: offset,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  color: text != null ? defSecClr : defPriClr,
                  fontSize: size,
                  fontFamily: "MarkoOne",
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        text != null
            ? Align(
                alignment: type != DiceInfinite
                    ? const FractionalOffset(0.69, 0.89)
                    : const FractionalOffset(0.6, 0.7),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    text.toString(),
                    style: TextStyle(
                      color: defSecClr,
                      fontSize: size/3,
                      fontFamily: "MarkoOne",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
            : Container(),

      ],
    );
  }
}
