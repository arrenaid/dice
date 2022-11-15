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
  final _sharedDCustomKey = "custom_dice_key";
  final _sharedLengthKey = "length_dice_key";

  DiceCubit()
      : super(DiceState(
      currentImg: [],
      listDice: [],
      listAllDice: [D4(), D6(), D8(), D10(), D12(), D20(), AnonymousDice()],
      rollResult: 0,
      rollMax: 12,
      status: StateStatus.initial)) {
    _loadCustomDice();
    _loadDice();
  }

  dispose() {
    _saveCustomDice(state.listAllDice);
    _saveListDice(state.listDice);
  }

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
        current.add(DiceStackWidget(
            imagePath: index > 0 ? res.substring(0, index) : res,
            value: element.rollResult,
            scale: axisCount(),
            type: element.runtimeType,
            text: "D${element.sides.length}"));
      } else if (element.runtimeType != D6) {
        current.add(DiceStackWidget(
          imagePath: index > 0 ? res.substring(0, index) : res,
          value: element.rollResult,
          scale: axisCount(),
          type: element.runtimeType,
        ));
      } else {
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
          if (type.runtimeType != DCustom) {
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
    _saveCustomDice(twin);
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
    _saveCustomDice(twin);
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
  Future<void> _saveCustomDice(List<Dice> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> result = [];
    for (var value in list) {
      if (value.runtimeType == DCustom) {
        result.add(value.sides.length.toString());
      }
    }
    prefs.setStringList(_sharedDCustomKey, result);
  }

  Future<void> _loadCustomDice() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<int> result = [];
      final List<String>? stringList = prefs.getStringList(_sharedDCustomKey);
      if (stringList!.isNotEmpty) {
        for (var value in stringList) {
          result.add(int.parse(value));
        }
      }
      for (int i in result) {
        insertCustomDice(i);
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
    }
  }
}
