import 'package:flutter/material.dart';
import '../constants.dart';

class RollButton extends StatelessWidget {
  final VoidCallback onPressed;
  final  VoidCallback onLongPress;

  const RollButton({super.key,
    required this.onPressed,
    required this.onLongPress
  });

  final  widthFactor = 1.4;

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.symmetric(horizontal: 50),
      width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
            tileMode:  TileMode.clamp,
            //stops: [0.1,0.99],
              colors: [/*Colors.white*/defSecClr,defSecClr],
    // colors: [Color(0xFF56ab2f ),Color(0xFFa8e063)],//Lush
            //colors: [Colors.white70, defBtnClr])
            )
    ),

      child: MaterialButton(
        padding: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),),
        color: Colors.transparent,//defBtnClr,
        splashColor: Colors.transparent,// defPriClr,
        elevation: 15,
        enableFeedback: true,
        textColor: Colors.white,
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Center(
          widthFactor: widthFactor,
          child: Text(
            "ROLL",
            style: defTs.copyWith(
                color: defBtnClr, fontSize: 40, shadows: []),
          ),
        ),
      ),
    );
  }
}


