import 'dart:math';
import 'package:dice/screens/history_screen.dart';
import 'package:dice/widget/roll_button.dart';
import 'package:dice/screens/bottom_sheet_widget.dart';
import 'package:dice/cubit/dice_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../widget/EmptyInfoWidget.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        animationBehavior: AnimationBehavior.preserve);

    super.initState();
  }

  @override
  void dispose() {
    context.read<DiceCubit>().dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(builder: (context, state) {
      double gridWidth = getGridViewWidth(context);
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [defPriClr, Colors.black],
              radius: 1.7,
              focal: Alignment(-0.1, 0.8),
              tileMode: TileMode.clamp,
            ),
          ),
          child: SafeArea(
              child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: gridWidth,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: state.currentImg.isEmpty
                        ? EmptyInfoWidget(width: gridWidth)
                        : ScaleTransition(
                            scale: _controller
                                .drive(Tween<double>(begin: 1.0, end: 2.0)),
                            child: RotationTransition(
                              turns: _controller.drive(
                                  Tween<double>(begin: 1.0, end: pi / 3)),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        context.read<DiceCubit>().axisCount(),
                                  ),
                                  itemCount: state.currentImg.length,
                                  physics: state.listDice.length < 7
                                      ? const NeverScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    state.currentImg[index]
                                        .setFontSizeFromWidth(gridWidth);
                                    return RotationTransition(
                                      turns: _controller.drive(Tween<double>(
                                          begin: 1.0, end: pi / 6)),
                                      child: FadeTransition(
                                        opacity: _controller.drive(
                                            Tween<double>(
                                                begin: 1.0, end: 0.0)),
                                        child: ScaleTransition(
                                          scale: _controller.drive(
                                              Tween<double>(
                                                  begin: 1.0, end: 0.1)),
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: state.currentImg[index]),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              if (state.rollResult >=
                                  (state.rollMax * state.successThreshold)
                                      .ceil()) ...[
                                ScaleTransition(
                                  scale: _controller.drive(
                                      Tween<double>(begin: 1.0, end: 0.8)),
                                  child: FadeTransition(
                                    opacity: _controller.drive(
                                        Tween<double>(begin: 1.0, end: 0.0)),
                                    child: Container(
                                      child: state.currentImg.isEmpty
                                          ? null
                                          : Icon(CupertinoIcons.arrow_up,
                                              color: defSecClr),
                                    ),
                                  ),
                                ),
                                ScaleTransition(
                                  scale: _controller.drive(
                                      Tween<double>(begin: 1.0, end: 0.8)),
                                  child: FadeTransition(
                                    opacity: _controller.drive(
                                        Tween<double>(begin: 1.0, end: 0.0)),
                                    child: Container(
                                      child: state.currentImg.isEmpty
                                          ? null
                                          : Text(
                                              "${state.successThreshold}",
                                              style:
                                                  defTs.copyWith(fontSize: 10),
                                            ),
                                    ),
                                  ),
                                ),
                              ],

                              ///0.5 от максимального броска
                              ///для понимания выигрышный бросок или проигрышный необходим коифецент выигрыша
                              ScaleTransition(
                                scale: _controller
                                    .drive(Tween<double>(begin: 1.0, end: 0.8)),
                                child: FadeTransition(
                                  opacity: _controller.drive(
                                      Tween<double>(begin: 1.0, end: 0.0)),
                                  child: Container(
                                    child: state.currentImg.isEmpty
                                        ? null
                                        : Text(
                                            "${(state.rollMax * state.successThreshold).ceil()}+",
                                            style: defTs.copyWith(fontSize: 10),
                                          ),
                                  ),
                                ),
                              ),

                              if (!(state.rollResult >=
                                  (state.rollMax * state.successThreshold)
                                      .ceil())) ...[
                                ScaleTransition(
                                  scale: _controller.drive(
                                      Tween<double>(begin: 1.0, end: 0.8)),
                                  child: FadeTransition(
                                    opacity: _controller.drive(
                                        Tween<double>(begin: 1.0, end: 0.0)),
                                    child: Container(
                                      child: state.currentImg.isEmpty
                                          ? null
                                          : Text(
                                              "${state.successThreshold}",
                                              style:
                                                  defTs.copyWith(fontSize: 10),
                                            ),
                                    ),
                                  ),
                                ),
                                ScaleTransition(
                                  scale: _controller.drive(
                                      Tween<double>(begin: 1.0, end: 0.8)),
                                  child: FadeTransition(
                                    opacity: _controller.drive(
                                        Tween<double>(begin: 1.0, end: 0.0)),
                                    child: Container(
                                      child: state.currentImg.isEmpty
                                          ? null
                                          : Icon(CupertinoIcons.arrow_down,
                                              color: defSecClr),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          ///результат броска
                          GestureDetector(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                elevation: 15,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(50))),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (context) => LayoutBuilder(
                                  builder: (context, constraints) =>
                                      HistoryScreen(
                                    past: state.past,
                                    width: constraints.maxWidth,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: state.currentImg.isEmpty
                                  ? null
                                  : FadeTransition(
                                      opacity: _controller.drive(
                                          Tween<double>(begin: 1.0, end: 0.0)),
                                      child: ScaleTransition(
                                        scale: _controller.drive(Tween<double>(
                                            begin: 1.0, end: 1.2)), //end: 1.2
                                        child: Text(
                                          "${state.rollResult}",
                                          style: defTs.copyWith(fontSize: 100),
                                        ),
                                      ),
                                    ),
                            ),
                          ),

                          ///максимальный возможный бросок
                          ScaleTransition(
                            scale: _controller
                                .drive(Tween<double>(begin: 1.0, end: 0.8)),
                            child: FadeTransition(
                              opacity: _controller
                                  .drive(Tween<double>(begin: 1.0, end: 0.0)),
                              child: Container(
                                child: state.currentImg.isEmpty
                                    ? null
                                    : Text(
                                        "${state.rollMax}",
                                        style: defTs.copyWith(fontSize: 10),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: ScaleTransition(
                      scale: _controller
                          .drive(Tween<double>(begin: 1.0, end: 0.9)),
                      child: RollButton(
                        onPressed: () {
                          _controller.forward().whenComplete(() {
                            context.read<DiceCubit>().roll();
                            _controller.reverse();
                          });
                        },
                        onLongPress: () {
                          _controller.forward();
                          showModalBottomSheet(
                            context: context,
                            elevation: 15,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(50))),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (context) => LayoutBuilder(
                              builder: (context, constraints) =>
                                  DiceController(width: constraints.maxWidth),
                            ),
                          );
                        },
                        child: Text(
                          "ROLL",
                          style: defTs.copyWith(
                              color: defBtnClr, fontSize: 40, shadows: []),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                ],
              ),
            ],
          )),
        ),
      );
    });
  }

  double getGridViewWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width - 40 <
        MediaQuery.of(context).size.height / 2) {
      return MediaQuery.of(context).size.width;
    } else {
      return MediaQuery.of(context).size.height / 2;
    }
  }
}
