import 'package:dice/cubit/dice_cubit.dart';
import 'package:dice/screens/dice_custom_side_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../core/dice_model.dart';

class DiceController extends StatefulWidget {
  @override
  State<DiceController> createState() => _DiceControllerState();
}

class _DiceControllerState extends State<DiceController> {
  // List<Dice> listAllDice = [ D4(), D6(), D8(), D10(), D12(), D20(), AnonymousDice() ];

  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  // late final List<Dice> twinAll ;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(builder: (context, state) {
      // twinAll = state.listAllDice;
      // twinAll.add(AnonymousDice());
      // if(state.listAllDice.last != AnonymousDice){
      //   state.listAllDice.add(AnonymousDice());
      // }
      return Scaffold(
          backgroundColor: defPriClr,
          body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state.listAllDice.length, //listAllDice.length,
            itemBuilder: (context, index) {
              Color currentColor =
                  state.listAllDice[index].color; //colorGenerator.generate();
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
                              addCustomDiceRow(context),
                              SizedBox(
                                height: 10,
                              ),
                              addCustomSideDice(),
                            ],
                          )
                    : RowDiceCounting(
                        currentColor: currentColor,
                        dice: state.listAllDice[index],
                        index: index),
              );
            },
          ));
    });
  }

  /// Добавляем кость с настраиваемыми сторонами
  Widget addCustomSideDice() {
    return /*Bounce*/ ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          elevation: 15,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (_) => CustomSideDiceSheet(),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'customizable dice',
          style: defTs.copyWith(color: defPriClr, shadows: []),
          textAlign: TextAlign.center,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: defSecClr,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      // borderRadius: BorderRadius.circular(30),
      // color: defSecClr,
    );
  }

  Widget addCustomDiceRow(
    BuildContext context,
  ) {
    int lengthValue = 1;
    return isVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Dice number",
                      hintStyle: defTs,
                      suffixStyle: defTs,
                      labelStyle: defTs,
                      helperStyle: defTs,
                      errorStyle: defTs,
                      prefixStyle: defTs,
                      counterStyle: defTs,
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
      required this.index});

  final Color currentColor;
  final Dice dice;
  final int index;

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
                maxWidth: MediaQuery.of(context).size.width,
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
                    height: MediaQuery.of(context).size.width / 6,
                    width: MediaQuery.of(context).size.width / 6,
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
                              color: dice.runtimeType == DiceCustomSide ? defBtnClr :defSecClr,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: dice.runtimeType == DiceCustomSide? currentColor : defBtnClr,
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
                    height: MediaQuery.of(context).size.width / 6,
                    child: Image.asset(
                      dice.sides.first.image,
                      color: currentColor,
                    )),
            Container(
              width: MediaQuery.of(context).size.width / 5,
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
              height: MediaQuery.of(context).size.width / 8,
              width: MediaQuery.of(context).size.width / 2,
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
                          fixedSize: Size(MediaQuery.of(context).size.width / 7, MediaQuery.of(context).size.width / 7),
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
                            fixedSize: Size(MediaQuery.of(context).size.width /7, MediaQuery.of(context).size.width /7),
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
      // padding: EdgeInsets.only(top: 40, left: 10,right: 10 ),
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
            style: defTs.copyWith(fontSize: 18),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: defSecClr,
                inactiveTrackColor: defPriClr,
                thumbColor: defSecClr,
                overlayColor: defPriClr.withOpacity(0.5),
                thumbShape: DiamondSliderThumbShape()),
            child: Slider(
              // activeColor: defSecClr,
              // inactiveColor: defPriClr,
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

class DiamondSliderThumbShape extends SliderComponentShape {
  final double radius;

  const DiamondSliderThumbShape({this.radius = 12.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // Размер определяется диаметром ромба (радиус * 2)
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

    // Получаем цвет в зависимости от состояния (активен/неактивен)
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final color = colorTween.evaluate(enableAnimation)!;

    // Создаем путь для ромба
    final path = Path();
    // Верхняя точка
    path.moveTo(center.dx, center.dy - radius);
    // Правая точка
    path.lineTo(center.dx + radius, center.dy);
    // Нижняя точка
    path.lineTo(center.dx, center.dy + radius);
    // Левая точка
    path.lineTo(center.dx - radius, center.dy);

    path.close();

    // Рисуем и закрашиваем ромб
    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }
}
