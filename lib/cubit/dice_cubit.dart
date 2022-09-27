import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../dice_model.dart';
part 'dice_state.dart';

class DiceCubit extends Cubit<DiceState>{
  DiceCubit() : super(DiceState(currentImg: [], listDice: [D6(),D6()],
      rollResult: 0, rollMax: 12, status: StateStatus.initial));

  int _countRollMax(List<Dice> twin){
    //emit(state.copyWith(status: StateStatus.loading));
    int result = 0;
    for (var element in twin) {
      result += element.sides.values.last;
    }
    return result;
    //emit(state.copyWith(rollMax: result, status: StateStatus.loaded));
  }

  roll(){
    emit(state.copyWith(status: StateStatus.loading));
    int count = 0;//rollResult
    List<Image> current = [];//currentImage
    for (var element in state.listDice) {
      String res = element.roll();
      count += element.sides[res]!;
      int index = res.indexOf("-");
      if(index > 0) {
        current.add(Image.asset(res.substring(0,index)));
      } else {
        current.add(Image.asset(res));
      }
    }
    emit(state.copyWith(listDice: _shake(state.listDice),
        currentImg: current,rollResult: count, status: StateStatus.rolling));
  }
  List<Dice> _shake(List<Dice> twin){
    //emit(state.copyWith(status: StateStatus.loading));
    Random random = Random();
    //List<Dice> twin = state.listDice;
    List<Dice> result = [];
    while(twin.length > 0){
      int index = random.nextInt(twin.length);
      result.add(twin.elementAt(index));
      twin.removeAt(index);
    }
    //emit(state.copyWith(listDice: result,status: StateStatus.loaded));
    return result;
  }
  addDice(Dice dice){
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listDice;
    twin.add(dice);
    emit(state.copyWith(listDice: twin, rollMax:_countRollMax(twin),
        status: StateStatus.loaded ));
    //countType(dice);
  }
  removeDice(Dice type){
    emit(state.copyWith(status: StateStatus.loading));
    List<Dice> twin = state.listDice;
      if(twin.length > 1) {
        for (int i = 0; i < twin.length; i++) {
          if (twin[i].runtimeType == type.runtimeType) {
            twin.removeAt(i);
            emit(state.copyWith(listDice: twin, rollMax: _countRollMax(twin),
                status: StateStatus.loaded));
            return;
          }
        }
      }
  }
  int countType(Dice type){
    int result =0;
    List<Dice> list = state.listDice;
    for(int i  = 0; i < list.length; i++){
      if(list[i].runtimeType == type.runtimeType){
        result += 1;
      }
    }
    return result;
  }
}
