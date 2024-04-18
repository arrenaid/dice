import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dice/dice_stack_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import '../constants.dart';
import '../dice_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dice_state.dart';

class DiceCubit extends Cubit<DiceState> {
  // static const String sharedCountType = "type";
  // static const String sharedCountCount = "count";
  // static const String sharedCountKey = "key";

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
    _loadDiceCount();
  }

  dispose() {
    _saveDiceInfinite(state.listAllDice);
    _saveDiceCustomSide(state.listAllDice);
    _saveListDiceCount();//state.listDice
  }

  int _countRollMax(List<Dice> twin) {
    int result = 0;
    for (var element in twin) {
      //result += element.sides.values.last;
      if (element.runtimeType == DiceCustomSide) {
        element as DiceCustomSide;
        var odds = 0;
        for (var value in element.sides) {
          if (value.num > odds) {
            odds = value.num;
          }
        }
        result += odds;
      } else if (element.runtimeType == DiceInfinite) {
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
      // int index = res.image.indexOf("-");
      if (element.runtimeType == DiceInfinite) {
        //DCustom ?proxy = element as DCustom;
        current.add(DiceStackWidget(
          imagePath: res.image,
          value: res.num,
          //element.rollResult,
          scale: axisCount(),
          type: element.runtimeType,
          text: "D${infiniteLength(element)}",
          color: element.color,
        ));
      } else if (element.runtimeType == DiceCustomSide) {
        //DCustom ?proxy = element as DCustom;
        current.add(DiceStackWidget(
          imagePath: res.image,
          value: res.num,
          //element.rollResult,
          scale: axisCount(),
          type: element.runtimeType,
          text: "Dc${element.sides.length}",
          color: element.color,
        ));
      } else if (element.runtimeType != D6) {
        current.add(DiceStackWidget(
          imagePath: res.image,
          value: res.num,
          scale: axisCount(),
          type: element.runtimeType,
          color: element.color,
        ));
      } else {
        current.add(SimpleShadow(
            offset: const Offset(9, 9), // Default: Offset(2, 2)
            color: Colors.black,//defBtnClr,
            sigma: 3.5,
            child:  Image.asset(res.image, color: element.color)));
      }
    }
    emit(state.copyWith(
        listDice: _shake(state.listDice),
        currentImg:  current,
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
    _saveListDiceCount();
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
          if (type.runtimeType != DiceInfinite &&
              type.runtimeType != DiceCustomSide) {
            twin.removeAt(i);
          } else if (twin[i] == type) {
            twin.removeAt(i);
          } else {
            continue;
          }
          _saveListDiceCount(/*twin*/);
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
    for (var element in list) {
      if (type.runtimeType != AnonymousDice) {
        if (element == type) {
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

  insertDiceInfinite(int value, {int key = 0}) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    twin.removeLast();
    twin.add(DiceInfinite(length: value, key: key));
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

    if (removeType.runtimeType == DiceInfinite) {
      _saveDiceInfinite(twin);
    } else if (removeType.runtimeType == DiceCustomSide) {
      _saveDiceCustomSide(twin);
    }
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  insertDiceCustomSide(List<int> valueList, {int key = 0}) {
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listAllDice;
    twin.removeLast();
    twin.add(DiceCustomSide(valueList, key: key));
    twin.add(AnonymousDice());
    _saveDiceCustomSide(twin);
    emit(state.copyWith(status: StateStatus.loaded, listAllDice: twin));
  }

  Future<void> _saveListDiceCount() async {
    try {
      List<Dice> twin = state.listAllDice;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> jsonDataListLength = twin
          .map((dice) => jsonEncode({
                jsonCountType /*"type"*/ : dice.runtimeType.toString(),
                jsonCountCount /*"count"*/ : countType(dice),
                jsonCountKey /*"key"*/ : _getDiceKey(dice)
              }))
          .toList();
      prefs.setStringList(sharedLengthKey, jsonDataListLength);
    } catch (e) {
      print("--error-save-count-$e");
    }
  }

  Future<void> _saveDiceInfinite(List<Dice> list) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<DiceInfinite> listInfinite =
          List.from(list.where((dice) => dice.runtimeType == DiceInfinite).toList());

      List<String> jsonDataListInfinite = listInfinite
          .map((dice) => jsonEncode({
                jsonInfiniteLength: dice.sideCount,
                jsonInfiniteKey: dice.keyValue,
              }))
          .toList();

      prefs.setStringList(sharedDiceInfiniteKey, jsonDataListInfinite);
    } catch (e) {
      print("--error-save-infinite-$e");
    }
  }

  Future<void> _saveDiceCustomSide(List<Dice> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<DiceCustomSide> listDcs = List.from(list.where((dice) =>
      dice.runtimeType == DiceCustomSide));

    List<String> jsonDataListDcs = listDcs
        .map((dice) => jsonEncode({
              jsonDcsKey: dice.keyValue,
              jsonDcsSides: List.generate(dice.sides.length, (index) => dice.sides[index].num),
            }))
        .toList();

    prefs.setStringList(sharedDiceCustomSideKey, jsonDataListDcs);

    // List<String> countDcsList = [];
    // List<DiceCustomSide> listDcs = [];
    //
    // for (var value in list) {
    //   if (value.runtimeType == DiceCustomSide) {
    //     countDcsList.add(value.sides.length.toString());
    //     listDcs.add(value as DiceCustomSide);
    //   }
    // }
    //
    // prefs.setStringList(sharedDCSLengthListKey, countDcsList);
    //
    // for (var dice in listDcs) {
    //   List<String> result = [];
    //   for (var side in dice.sides) {
    //     result.add(side.num.toString());
    //   }
    //   prefs.setStringList(
    //       sharedDCSSidesKey + dice.sides.length.toString(), result);
    // }
  }

  Future<void> _loadDiceInfinite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<int, int> mapInfinite = {};
      final List<String>? jsonStringList =
          prefs.getStringList(sharedDiceInfiniteKey);

      if (jsonStringList!.isNotEmpty) {
        for (var jPost in jsonStringList) {
          final Map<String, dynamic> map =
              await json.decode(jPost) as Map<String, dynamic>;
          if (map.isNotEmpty) {
            final key = map[jsonInfiniteKey] as int;
            final length = map[jsonInfiniteLength] as int;
            mapInfinite.addAll({key: length});
          }
        }
      }

      mapInfinite.forEach((key, value) {
        insertDiceInfinite(value, key: key);
      });
    } catch (e) {
      print("--error-load-infinite-$e");
    }
  }

  Future<void> _loadDiceCustomSide() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<int, List<int>> mapDcs = {};
      final List<String>? jsonStringList =
      prefs.getStringList(sharedDiceCustomSideKey);

      if (jsonStringList!.isNotEmpty) {
        for (var jPost in jsonStringList) {
          final Map<String, dynamic> map =
          await json.decode(jPost) as Map<String, dynamic>;
          if (map.isNotEmpty) {
            final key = map[jsonDcsKey] as int;
            final list = map[jsonDcsSides];
            List<int> sides = List.castFrom<dynamic, int>(list).toList();
            mapDcs.addAll({key: sides});
          }
        }
      }

      mapDcs.forEach((key, value) {
        insertDiceCustomSide(value, key: key);
      });

      // final List<String>? stringListLength =
      //     prefs.getStringList(sharedDiceCustomSideKey);
      // List<List<int>> data = [];
      // if (stringListLength!.isNotEmpty) {
      //   for (var value in stringListLength) {
      //     final List<String>? sides =
      //         prefs.getStringList(sharedDCSSidesKey + value);
      //     if (sides!.isNotEmpty) {
      //       List<int> _dataCast =
      //           List.generate(sides.length, (index) => int.parse(sides[index]));
      //       data.add(_dataCast);
      //     }
      //   }
      // }
      // if (data.isNotEmpty) {
      //   for (var sides in data) {
      //     insertDiceCustomSide(sides);
      //   }
      // }
    } catch (e) {
      print("--error-load-dcs-$e");
      //addDice(D20());
    }
  }

  Future<void> _loadDiceCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //final Map<String, int> mapTypeCount = {};
      final List<String> types = [];
      final List<int> counters = [];
      final List<int> keys = [];
      List<Dice> allTwin = state.listAllDice;
      final List<String>? jsonStringList = prefs.getStringList(sharedLengthKey);
      if (jsonStringList!.isNotEmpty) {
        for (var jPost in jsonStringList) {
          final Map<String, dynamic> map =
              await json.decode(jPost) as Map<String, dynamic>;
          if (map.isNotEmpty) {
            if(map[jsonCountCount] > 0) {
              types.add(map[jsonCountType] as String);
              counters.add(map[jsonCountCount] as int);
              keys.add(map[jsonCountKey]);
            }
          }
        }
      }
      int counter = 0;
      for (int index = 0; index < types.length; index++) {
        for (var dice in allTwin) {
          if (types[index] == dice.runtimeType.toString()) {
            if (dice.runtimeType == DiceInfinite ||
                dice.runtimeType == DiceCustomSide) {
              if (ValueKey(_getDiceKey(dice)) == ValueKey(keys[index])) {
                counter = counters[index];
              } else {
                continue;
              }
            } else {
              counter = counters[index];
            }
            for (int i = counter; i > 0; i--) {
              addDice(dice);
            }
            break;
          }
        }
      }
    } catch (e) {
      print("--error-load-count--$e");
      if (state.listDice.isEmpty) {
        addDice(D6());
        addDice(D6());
      }
    }
  }

  int infiniteLength(Dice dice) {
    dice as DiceInfinite;
    return dice.sideCount;
  }

  int _getDiceKey(Dice dice) {
    if (dice.runtimeType == DiceInfinite) {
      dice as DiceInfinite;
      return dice.keyValue;
    }
    if (dice.runtimeType == DiceCustomSide) {
      dice as DiceCustomSide;
      return dice.keyValue;
    }
    return 0;
  }
}
