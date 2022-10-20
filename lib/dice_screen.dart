import 'dart:math';
import 'package:dice/bottom_sheet_widget.dart';
import 'package:dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants.dart';

class DiceScreen extends StatefulWidget  {
  const DiceScreen({Key? key}) : super(key: key);

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      animationBehavior: AnimationBehavior.preserve
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit,DiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: defPriClr,
          body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: state.currentImg.isEmpty ? null
                            : ScaleTransition(
                              scale: _controller.drive(Tween<double>(begin: 1.0,end: 2.0)),
                              child: RotationTransition(
                                turns: _controller.drive(Tween<double>(begin: 1.0,end: pi/3)),
                                child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: context.read<DiceCubit>().axisCount(),
                                ),
                                itemCount: state.currentImg.length,
                                physics: state.listDice.length < 7
                                    ? const NeverScrollableScrollPhysics()
                                    : const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return RotationTransition(
                                    turns: _controller.drive(Tween<double>(begin: 1.0,end: pi/6)),
                                    child: FadeTransition(
                                      opacity: _controller.drive(Tween<double>(begin: 1.0,end: 0.0)),
                                      child: ScaleTransition(
                                        scale: _controller.drive(Tween<double>(begin: 1.0,end: 0.1)),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child:  state.currentImg[index],//Image(image: state.currentImg[index].image, color: defSecClr),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                      ),
                      Center(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: state.currentImg.isEmpty ? null
                                    : FadeTransition(
                                      opacity: _controller.drive(Tween<double>(begin: 1.0,end: 0.0)),
                                      child: ScaleTransition(
                                        //,
                                        //position: _controller.drive(Tween<Offset>(begin: Offset(1.0,0.0),end:Offset(0.0, 0.0))),
                                        //sizeFactor: ,

                                        scale: _controller.drive(Tween<double>(begin: 1.0,end: 1.2)),
                                        child: Text("${state.rollResult}",
                                  style: defTs.copyWith(fontSize: 100),
                                ),
                                      ),
                                    ),
                              ),
                              ScaleTransition(
                                scale: _controller.drive(Tween<double>(begin: 1.0,end: 0.8)),
                                child: FadeTransition(
                                  opacity: _controller.drive(Tween<double>(begin: 1.0,end: 0.0)),
                                  child:Container(
                              child: state.currentImg.isEmpty ? null
                                  : Text("${state.rollMax}",
                                style: defTs.copyWith(fontSize: 10),
                              ),),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 5,),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: MaterialButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),),
                          color: defBtnClr,
                          splashColor: Colors.brown[900],
                          elevation: 15,
                          enableFeedback: true,
                          textColor: Colors.white,
                          child: Text("ROLL",
                            style: defTs.copyWith(fontSize: 40,shadows: []),
                          ),
                          onPressed: () {
                            _controller.forward().whenComplete(() {
                              context.read<DiceCubit>().roll();
                              _controller.reverse();});
                          },
                          onLongPress: () {
                            _controller.forward();
                            showModalBottomSheet(
                              context: context,
                              elevation: 15,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (_) => DiceController(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                    ],
                  ),
                ],
              )
          ),
        );
      }
    );
  }
}
