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
              Color currentColor =  state.listAllDice[index].color;//colorGenerator.generate();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: state.listAllDice[index].runtimeType == AnonymousDice
                    ? Column(
                        children: [
                          addCustomDiceRow(context),
                          SizedBox(
                            height: 10,
                          ),
                          addCustomSideDice(),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            state.listAllDice[index].runtimeType ==
                                        DiceInfinite ||
                                    state.listAllDice[index].runtimeType ==
                                        DiceCustomSide
                                ? SizedBox(
                                  height:
                                  MediaQuery.of(context).size.width / 6,
                                  width:
                  MediaQuery.of(context).size.width / 6,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                          state.listAllDice[index].sides.first.image,
                                      color: currentColor,//defSecClr,
                                      ),
                                      Align(
                                        alignment: const FractionalOffset(0.5,0.5),
                                        child: /*Bounce*/IconButton(
                                          onPressed: () => context
                                              .read<DiceCubit>()
                                              .removeDiceInfinite(index),
                                          icon: const Icon(
                                            CupertinoIcons.delete_solid,
                                            color: defSecClr,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: defBtnClr,
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
                                    height:
                                        MediaQuery.of(context).size.width / 6,
                                    child: Image.asset(
                                        state.listAllDice[index].sides.first
                                            .image,
                                        color: currentColor, /*defSecClr*/)),
                            Expanded(
                              child: Text(
                              state.listAllDice[index].runtimeType ==
                                  DiceInfinite
                                  ? "D${context.read<DiceCubit>().infiniteLength(state.listAllDice[index])} -"
                                  " ${context.read<DiceCubit>().countType(state.listAllDice[index])}"
                                  : state.listAllDice[index].runtimeType ==
                                  DiceCustomSide
                                  ? "Dc${state.listAllDice[index].sides.length} -"
                                  " ${context.read<DiceCubit>().countType(state.listAllDice[index])}"
                                  : "${state.listAllDice[index].runtimeType} -"
                                  " ${context.read<DiceCubit>().countType(state.listAllDice[index])}",
                              style: defTs.copyWith(
                                shadows: [],
                                  color: currentColor,
                                  overflow: TextOverflow.fade),
                              textAlign: TextAlign.center),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<DiceCubit>()
                                      .addDice(state.listAllDice[index]),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentColor /*defSecClr*/,
                                    elevation: 3,
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
                                      backgroundColor: currentColor,/*defSecClr,*/
                                      elevation: 3,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30)),
                                      ),
                                    ),
                                    onPressed: () => context
                                        .read<DiceCubit>()
                                        .removeDice(state.listAllDice[index]),
                                    child: const Icon(Icons.close, color: defPriClr)),
                              ],
                            )
                          ]),
              );
            },
          ));
    });
  }

  /// Добавляем кость с настраиваемыми сторонами
  Widget addCustomSideDice() {
    return /*Bounce*/ElevatedButton(
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)),
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
            child:  /*Bounce*/ElevatedButton(
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

SnackBar MySnackBar(String title) {
  return
    SnackBar(
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
