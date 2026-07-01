import 'package:dice/cubit/dice_cubit.dart';
import 'package:dice/screens/dice_custom_side_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../core/dice_model.dart';
import '../widget/success_threahold_slider.dart';

class DiceController extends StatefulWidget {
  final double width;

  const DiceController({super.key, required this.width});

  @override
  State<DiceController> createState() => _DiceControllerState();
}

class _DiceControllerState extends State<DiceController> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: defPriClr,
          body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.listAllDice.length,
            itemBuilder: (context, index) {
              Color currentColor = state.listAllDice[index].color;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: state.listAllDice[index].runtimeType == AnonymousDice
                    ? index == 0
                        ? SuccessThresholdSlider(
                            value: state.successThreshold,
                            onChanged: (value) => context
                                .read<DiceCubit>()
                                .changeSuccessThreshold(value))
                        : Column(
                            children: [
                              addCustomDiceRow(
                                  context: context, width: widget.width),
                              SizedBox(
                                height: 10,
                              ),
                              addCustomSideDice(),
                            ],
                          )
                    : RowDiceCounting(
                        currentColor: currentColor,
                        dice: state.listAllDice[index],
                        index: index,
                        width: widget.width,
                      ),
              );
            },
          ));
    });
  }

  /// Добавляем кость с настраиваемыми сторонами
  Widget addCustomSideDice() {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          elevation: 15,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (_) => LayoutBuilder(
            builder: (context, constraints) =>
                CustomSideDiceSheet(width: constraints.maxWidth),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: defSecClr,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'customizable dice',
          style: defTs.copyWith(color: defPriClr, shadows: []),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget addCustomDiceRow(
      {required BuildContext context, required double width}) {
    int lengthValue = 1;
    return isVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: width / 2,
                  child: TextFormField(
                    cursorColor: defSecClr,
                    decoration: const InputDecoration(
                      hintText: "Dice number",
                      hintStyle: defTs,
                      suffixStyle: defTs,
                      labelStyle: defTs,
                      helperStyle: defTs,
                      errorStyle: defTs,
                      prefixStyle: defTs,
                      counterStyle: defTs,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: defSecClr, width: 2.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: defSecClr, width: 2.5),
                      ),
                    ),
                    style: defTs,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onSaved: (value) => lengthValue = int.parse(value!),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "pls enter...";
                      }
                      if (int.parse(value) < 1) {
                        return "pls enter number > 0...";
                      }
                      if (int.parse(value) > maxIntRandom) {
                        return "pls enter number < $maxIntRandom...";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _formKey.currentState!.validate(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      isVisible = false;
                      context.read<DiceCubit>().insertDiceInfinite(lengthValue);
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(MySnackBar("Add Custom Dice"));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(MySnackBar("error form"));
                  }
                },
                child: const Icon(
                  Icons.add,
                  color: defPriClr,
                ),
                // borderRadius: BorderRadius.circular(30),
                // color: defSecClr,
                style: ElevatedButton.styleFrom(
                  backgroundColor: defSecClr,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          )
        : SizedBox(
            width: double.infinity,
            child: /*Bounce*/ ElevatedButton(
              onPressed: () {
                setState(() {
                  isVisible = true;
                });
              },
              child: Text(
                'add dice',
                style: defTs.copyWith(color: defPriClr, shadows: []),
                textAlign: TextAlign.center,
              ),
              // Icon(
              //   Icons.add,
              //   color: defPriClr,
              // ),
              style: ElevatedButton.styleFrom(
                backgroundColor: defSecClr,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              // borderRadius: BorderRadius.circular(30),
              // color: defSecClr,
            ),
          );
  }
}

class RowDiceCounting extends StatelessWidget {
  const RowDiceCounting(
      {super.key,
      required this.currentColor,
      required this.dice,
      required this.index,
      required this.width});

  final Color currentColor;
  final Dice dice;
  final int index;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: dice.runtimeType != DiceCustomSide
          ? null
          : BoxDecoration(
              color: defSecClr,
              borderRadius: BorderRadius.circular(30),
            ),
      child: Column(
        children: [
          if (dice.runtimeType == DiceCustomSide) ...[
            Container(
              height: 30,
              child: OverflowBox(
                maxWidth: width,
                child: ListView.separated(
                  padding: EdgeInsets.only(left: 40, top: 5),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: dice.sides.length,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: defBtnClr,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        dice.sides[index].num.toString(),
                        textAlign: TextAlign.center,
                        style: defTs.copyWith(
                            color: currentColor, shadows: [], fontSize: 15),
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    width: 10,
                  ),
                ),
              ),
            )
          ],
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            dice.runtimeType == DiceInfinite ||
                    dice.runtimeType == DiceCustomSide
                ? SizedBox(
                    height: width / 6,
                    width: width / 6,
                    child: Stack(
                      children: [
                        Image.asset(
                          dice.sides.first.image,
                          color: dice.runtimeType == DiceCustomSide
                              ? defPriClr
                              : currentColor,
                        ),
                        Align(
                          alignment: const FractionalOffset(0.5, 0.5),
                          child: /*Bounce*/ IconButton(
                            onPressed: () => context
                                .read<DiceCubit>()
                                .removeDiceInfinite(index),
                            icon: Icon(
                              CupertinoIcons.delete_solid,
                              color: dice.runtimeType == DiceCustomSide
                                  ? defBtnClr
                                  : defSecClr,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  dice.runtimeType == DiceCustomSide
                                      ? currentColor
                                      : defBtnClr,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            /*                                          borderRadius: BorderRadius.circular(30),
                                color: defBtnClr,*/
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: width / 6,
                    child: Image.asset(
                      dice.sides.first.image,
                      color: currentColor,
                    )),
            Container(
              width: width / 5,
              child: Align(
                alignment: FractionalOffset(0, 0.5),
                child: Text(
                    dice.runtimeType == DiceInfinite
                        ? "D${context.read<DiceCubit>().infiniteLength(dice)}"
                        : dice.runtimeType == DiceCustomSide
                            ? "Dc${dice.sides.length}"
                            : "${dice.runtimeType}",
                    style: defTs.copyWith(
                        shadows: [],
                        color: dice.runtimeType == DiceCustomSide
                            ? defPriClr
                            : currentColor,
                        overflow: TextOverflow.fade),
                    maxLines: 2,
                    textAlign: TextAlign.start),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              height: width / 8,
              width: width / 2,
              decoration: BoxDecoration(
                color: defBtnClr,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${context.read<DiceCubit>().countType(dice)}",
                      style: defTs.copyWith(
                          shadows: [],
                          color: currentColor,
                          overflow: TextOverflow.fade),
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            context.read<DiceCubit>().addDice(dice),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentColor /*defSecClr*/,
                          elevation: 3,
                          fixedSize: Size(width / 7, width / 7),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30))),
                        ),
                        child: Icon(
                          Icons.add,
                          color: defPriClr,
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentColor,
                            fixedSize: Size(width / 7, width / 7),
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                          ),
                          onPressed: () =>
                              context.read<DiceCubit>().removeDice(dice),
                          child: const Icon(Icons.close, color: defPriClr)),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}

SnackBar MySnackBar(String title) {
  return SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 35,
      duration: const Duration(seconds: 3),
      backgroundColor: defBtnClr,
      content: Text(
        title,
        style: defTs,
        textAlign: TextAlign.center,
      ));
}