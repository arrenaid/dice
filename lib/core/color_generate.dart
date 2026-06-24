import 'package:flutter/material.dart';
import 'dart:math';

class ColorGenerator {
  late Map<Color,int> voteList;

  ColorGenerator(List<Color> list){
    Map<Color,int> map = {};
    for(var value in list){
      map.addAll({ value : list.length });
    }
    voteList = map;
  }
  Color generate(){
    Color result;
    List<Color> sample = [];
    for(var value in voteList.keys){
      for(int i = 0; i < voteList[value]! ; i++){
        sample.add(value);
      }
    }
    sample.shuffle();
    result = sample.elementAt(Random().nextInt(sample.length));
    voteList[result] = 0;
    for(var value in voteList.keys){
      voteList[value] = (voteList[value])! + 1;
    }
    return result;
  }
}