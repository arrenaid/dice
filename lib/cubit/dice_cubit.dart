import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dice/dice_stack_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../dice_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dice_state.dart';

class DiceCubit extends Cubit<DiceState> {
  final _sharedDInfiniteKey = "custom_dice_key";
  final _sharedLengthKey = "length_dice_key";
  final _sharedDCSLengthListKey = "dcs_length_key";
  final _sharedDCSSidesKey = "dcs_sides_key_";

  DiceCubit()
      : super(DiceState(currentImg: [], listDice: [], listAllDice: [
          D4(),
          D6(),
          D8(),
          D10(),
          D12(),
          D20(),
          AnonymousDice()
        ], rollResult: 0, rollMax: 12, status: StateStatus.initial)) {
    _loadDiceInfinite();
    _loadDiceCustomSide();
    _loadDice();
  }

  dispose() {
    _saveDiceInfinite(state.listAllDice);
    _saveListDice(state.listDice);
    _saveDiceCustomSide(state.listAllDice);
  }

  int _countRollMax(List<Dice> twin) {
    int result = 0;
    for (var element in twin) {
      //result += element.sides.values.last;
      if (element.runtimeType == DiceCustomSide) {
        element as DiceCustomSide;
        var odds = 0;
        for( var value in element.sides){
          if(value.num > odds){
            odds = value.num;
          }
        }
        result += odds;
      } else
        if (element.runtimeType == DiceInfinite) {
        element as DiceInfinite;
        result += element.sideCount;
      } else {
        result += element.sides.last.num;
      }
    }
    return result;
  }

  roll() {
    emit(state.copyWith(status: StateStatus.loading));
    int count = 0; //rollResult
    List<Widget> current = []; //currentImage
    for (var element in state.listDice) {
      // String res = element.getSide();
      // count += element.sides[res]!;
      Side res = element.getSide();
      count += res.num;
      int index = res.image.indexOf("-");
      if (element.runtimeType == DiceInfinite) {
        //DCustom ?proxy = element as DCustom;
        current.add(DiceStackWidget(
            imagePath: index > 0 ? res.image.substring(0, index) : res.image,
            value: res.num,
            //element.rollResult,
            scale: axisCount(),
            type: element.runtimeType,
            text: "D${InfiniteLength(element)}"));
      } else if (element.runtimeType == DiceCustomSide) {
        //DCustom ?proxy = element as DCustom;
        current.add(DiceStackWidget(
            imagePath: index > 0 ? res.image.substring(0, index) : res.image,
            value: res.num,
            //element.rollResult,
            scale: axisCount(),
            type: element.runtimeType,
            text: "Dc${element.sides.length}"));
      } else if (element.runtimeType != D6) {
        current.add(DiceStackWidget(
          imagePath: index > 0 ? res.image.substring(0, index) : res.image,
          value: res.num, //element.rollResult,
          scale: axisCount(),
          type: element.runtimeType,
        ));
      } else {
        current.add(Image.asset(
            index > 0 ? res.image.substring(0, index) : res.image,
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
    if (length != null) {
      twin.add(DiceInfinite(length: length));
    } else {
      twin.add(dice);
    }
    _saveListDice(twin);
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
          if (type.runtimeType != DiceInfinite
              && type.runtimeType != DiceCustomSide) {
            twin.removeAt(i);
          } else if (twin[i] == type) {
            twin.removeAt(i);
          } else {
            continue;
          }
          _saveListDice(twin);
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
    for(var element in list){
      if(type.runtimeType != AnonymousDice){
        if(element == type){
          result += 1;
        }
      }
    }

    // for (int i = 0; i < list.length; i++) {
    //   if (type.runtimeType != DiceInfinite
    //       && type.runtimeType != DiceCustomSide) {
    //     if (list[i].runtimeType == type.runtimeType) {
    //       result += 1;
    //     }
    //   } else {
    //     if (list[i] == type) {
    //       result += 1;
    //     }
    //   }
    // }
    return result;
  }

  int axisCount() {
    int len = state.listDice.length;
    int result = 1;
    if (len != 1 && len <= 4) {
      result = 2;
    } else {
      if (len > 4) {
        result = 3;
        if (len > 9) {
          result = 4;
        }
      }
    }
    return result;
  }

  insertDiceInfinite(int value) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    twin.removeLast();
    twin.add(DiceInfinite(length: value));
    twin.add(AnonymousDice());
    _saveDiceInfinite(twin);
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  removeDiceInfinite(int index) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    Dice removeType = twin.removeAt(index);
    if (state.listDice.length == countType(removeType)) {
      addDice(D6());
    }
    while (countType(removeType) != 0) {
      removeDice(removeType);
    }

    if(removeType.runtimeType == DiceInfinite) {
      _saveDiceInfinite(twin);
    }else if(removeType.runtimeType == DiceCustomSide) {
      _saveDiceCustomSide(twin);
    }
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  insertDiceCustomSide(List<int> valueList) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    twin.removeLast();
    twin.add(DiceCustomSide(valueList));
    twin.add(AnonymousDice());
    _saveDiceCustomSide(twin);
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  Future<void> _saveListDice(List<Dice> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonDataListLength = list
        .map((dice) => jsonEncode({
              "type": dice.runtimeType.toString(),
              "count": countType(dice),
              "length": dice.sides.length,
            }))
        .toList();
    prefs.setStringList(_sharedLengthKey, jsonDataListLength);
  }

  Future<void> _saveDiceInfinite(List<Dice> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = [];
    for (var value in list) {
      if (value.runtimeType == DiceInfinite) {
        value as DiceInfinite;
        result.add(value.sideCount.toString());
      }
    }
    prefs.setStringList(_sharedDInfiniteKey, result);
  }

  Future<void> _saveDiceCustomSide(List<Dice> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> countDcsList = [];
    List<DiceCustomSide> listDcs = [];
    for (var value in list) {
      if (value.runtimeType == DiceCustomSide) {
        countDcsList.add(value.sides.length.toString());
        listDcs.add(value as DiceCustomSide);
      }
    }
    prefs.setStringList(_sharedDCSLengthListKey, countDcsList);
    for (var dice in listDcs) {
      List<String> result = [];
      for (var side in dice.sides) {
        result.add(side.num.toString());
      }
      prefs.setStringList(
          _sharedDCSSidesKey + dice.sides.length.toString(), result);
    }
  }

  Future<void> _loadDiceInfinite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<int> result = [];
      final List<String>? stringList = prefs.getStringList(_sharedDInfiniteKey);
      if (stringList!.isNotEmpty) {
        for (var value in stringList) {
          result.add(int.parse(value));
        }
      }
      for (int i in result) {
        insertDiceInfinite(i);
      }
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      print("--error--$e");
    }
  }
  Future<void> _loadDiceCustomSide() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? stringListLength = prefs.getStringList(_sharedDCSLengthListKey);
      List<List<int>> data = [];
      if (stringListLength!.isNotEmpty) {
        for (var value in stringListLength) {
          final List<String>? sides = prefs.getStringList(_sharedDCSSidesKey + value);
          if(sides!.isNotEmpty){
            List<int> _dataCast = List.generate(sides.length, (index)
            => int.parse(sides[index]));
            data.add(_dataCast);
          }
        }
      }
      for(var side in data){
        insertDiceCustomSide(side);
      }
    } catch (e) {
      print("--error--$e");
    }
  }

  Future<void> _loadDice() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<int, int> mapCustom = {};
      List<Dice> all = state.listAllDice;
      final List<String>? jsonStringList =
          prefs.getStringList(_sharedLengthKey);
      if (jsonStringList!.isNotEmpty) {
        for (var jPost in jsonStringList) {
          final Map<String, dynamic> map =
              await json.decode(jPost) as Map<String, dynamic>;
          final count = map["count"] as int;
          final len = map["length"] as int;
          mapCustom.addAll({len: count});
        }
      }
      for (var value in mapCustom.keys) {
        for (var el in all) {
          if (value == el.sides.length) {
            for (int i = 0; i < mapCustom[value]!; i++) {
              addDice(el);
            }
            break;
          }
        }
      }
    } catch (e) {
      print("--error-dice-length--$e");
      addDice(D6());
      addDice(D6());
      //addDice(AnonymousDice());
    }
  }

  int InfiniteLength(Dice dice) {
    dice as DiceInfinite;
    return dice.sideCount;
  }
}
