import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../dice_model.dart';
part 'dice_state.dart';

class DiceCubit extends Cubit<DiceState> {
  DiceCubit()
      : super(DiceState(currentImg: [], listDice: [D6(), D6()],
      listAllDice: [D4(), D6(), D8(), D10(), D12(), D20(), AnonymousDice()],
      rollResult: 0, rollMax: 12, status: StateStatus.initial));

  int _countRollMax(List<Dice> twin) {
    int result = 0;
    for (var element in twin) {
      result += element.sides.values.last;
    }
    return result;
  }

  roll() {
    emit(state.copyWith(status: StateStatus.loading));
    int count = 0; //rollResult
    List<Widget> current = []; //currentImage
    for (var element in state.listDice) {
      String res = element.roll();
      count += element.sides[res]!;
      int index = res.indexOf("-");
      if (element.runtimeType == DCustom) {
        //DCustom ?proxy = element as DCustom;
        current.add(_stackPaint(index > 0 ? res.substring(0, index) : res,
            element.rollResult, axisCount(), text:"D${element.sides.length}"));
      }else if(element.runtimeType != D6) {
        current.add(_stackPaint(index > 0 ? res.substring(0, index) : res,
            element.rollResult, axisCount()));
      }
      else {
        current.add(Image.asset(index > 0 ? res.substring(0, index) : res,
            color: defSecClr));
      }
    }
    emit(state.copyWith(
        listDice: _shake(state.listDice),
        currentImg: current,
        rollResult: count,
        status: StateStatus.rolling));
  }

  List<Dice> _shake(List<Dice> twin) {
    Random random = Random();
    List<Dice> result = [];
    while (twin.length > 0) {
      int index = random.nextInt(twin.length);
      result.add(twin.elementAt(index));
      twin.removeAt(index);
    }
    return result;
  }

  addDice(Dice dice, {int? length}) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listDice;
    if (length != null)
      twin.add(DCustom(length: length));
    else
      twin.add(dice);
    emit(state.copyWith(
        listDice: twin,
        rollMax: _countRollMax(twin),
        status: StateStatus.loaded));
  }

  removeDice(Dice type) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listDice;
    if (twin.length > 1) {
      for (int i = 0; i < twin.length; i++) {
        if (twin[i].runtimeType == type.runtimeType) {
          if (type.runtimeType != DCustom) {
            twin.removeAt(i);
          } else if (twin[i] == type) {
            twin.removeAt(i);
          } else {
            continue;
          }
          emit(state.copyWith(
              listDice: twin,
              rollMax: _countRollMax(twin),
              status: StateStatus.loaded));
          return;
        }
      }
    }
  }

  int countType(Dice type) {
    int result = 0;
    List<Dice> list = state.listDice;
    for (int i = 0; i < list.length; i++) {
      if (type.runtimeType != DCustom) {
        if (list[i].runtimeType == type.runtimeType) {
          result += 1;
        }
      } else {
        if (list[i] == type) {
          result += 1;
        }
      }
    }
    return result;
  }

  int axisCount() {
    int len = state.listDice.length;
    int result = 1;
    if (len != 1 && len <= 4)
      result = 2;
    else {
      if (len > 4) {
        result = 3;
        if (len > 9) {
          result = 4;
        }
      }
    }
    return result;
  }

  insertCustomDice(int value) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    twin.removeLast();
    twin.add(DCustom(length: value));
    twin.add(AnonymousDice());
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  removeCustomDice(int index) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    Dice removeType = twin.removeAt(index);
    if (state.listDice.length == countType(removeType)) {
      addDice(D6());
    }
    while (countType(removeType) != 0) {
      removeDice(removeType);
    }
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  Widget _stackPaint(String imagePath, int i, int scale, {String? text}) {
    double size = 76.0 / scale;
    return Stack(
      children: [
        Image.asset(imagePath, color: defSecClr),
        Center(
          child: Container(
            height: size + 5,
            width: size + 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              color: defSecClr,
            ),
          ),
        ),
        Center(
            child: Text(
          i.toString(),
          style: TextStyle(
            color: defPriClr,
            fontSize: size,
            fontFamily: "MarkoOne",
            fontWeight: FontWeight.bold,
          ),
        )),
        text != null
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text.toString(),
                  style: TextStyle(
                    color: defSecClr,
                    fontSize: size/2,
                    fontFamily: "MarkoOne",
                    fontWeight: FontWeight.bold,
                  ),
                ))
            : Container(),
      ],
    );
  }
}
