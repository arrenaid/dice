import 'package:flutter/material.dart';
// import 'package:flutter_bouncing_widgets/Widgets/bounce_elevated_button.dart';
import 'constants.dart';

class RollButton extends StatelessWidget {
  final VoidCallback onPressed;
  final  VoidCallback onLongPress;
  final Widget child;

  const RollButton({Key? key,
    required this.onPressed,
    required this.child,
    required this.onLongPress
  }) : super(key: key);

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
        child: Center(
          widthFactor: widthFactor,
          child: child,
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
      ),
      // child: BounceElevatedButton(
      //   onPressed: onPressed,
      //   child:  child,
      // //     Container(
      // //     height: 44.0,
      // //     decoration: BoxDecoration(
      // //     gradient: LinearGradient(
      // //     colors: [Color.fromARGB(255, 2, 173, 102), Colors.blue])),
      // // child: ElevatedButton(
      // // onPressed: () {},
      // // style: ElevatedButton.styleFrom(
      // // backgroundColor: Colors.transparent,
      // // shadowColor: Colors.transparent),
      // // child: Text('Elevated Button'),
      //
      //   // Text(
      //   //   'add dice',
      //   //   style: defTs.copyWith(color: defPriClr, shadows: []),
      //   //   textAlign: TextAlign.center,
      //   // ),
      //   // Icon(
      //   //   Icons.add,
      //   //   color: defPriClr,
      //   // ),
      //   // style: ElevatedButton.styleFrom(
      //   //   backgroundColor: defSecClr,
      //   //   elevation: 3,
      //   //   shape: RoundedRectangleBorder(
      //   //       borderRadius: BorderRadius.circular(30)),
      //   // ),
      //   size: 80,
      //   borderRadius: BorderRadius.circular(30),
      //   color: Colors.transparent,
      // ),
    );
  }
}


