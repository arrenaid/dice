import 'dart:math';
import 'package:flutter/material.dart';

abstract class Dice {
  abstract final Map<String,int> sides;
  String roll(){
    return sides.keys.elementAt(Random().nextInt(sides.length));
  }
}
class D6 extends Dice{
  @override
  Map<String, int> sides  = {
    "dice/dice1.png" : 1,
    "dice/dice2.png" : 2,
    "dice/dice3.png" : 3,
    "dice/dice4.png" : 4,
    "dice/dice5.png" : 5,
    "dice/dice6.png" : 6,
  };
}
class D4 extends Dice{
  @override
  Map<String, int> sides = {
    "dice/d4.png" : 1,
    "dice/d4.png-1" : 2,
    "dice/d4.png-2" : 3,
    "dice/d4.png-3" : 4
  };
}
class D8 extends Dice{
  @override
  Map<String, int> sides = {
    "dice/d8.png" : 1,
    "dice/d8.png-1" : 2,
    "dice/d8.png-2" : 3,
    "dice/d8.png-3" : 4,
    "dice/d8.png-4" : 5,
    "dice/d8.png-5" : 6,
    "dice/d8.png-6" : 7,
    "dice/d8.png-7" : 8
  };
}
class D10 extends Dice{
  @override
  Map<String, int> sides = {
    "dice/d10.png" : 1,
    "dice/d10.png-1" : 2,
    "dice/d10.png-2" : 3,
    "dice/d10.png-3" : 4,
    "dice/d10.png-4" : 5,
    "dice/d10.png-5" : 6,
    "dice/d10.png-6" : 7,
    "dice/d10.png-7" : 8,
    "dice/d10.png-8" : 9,
    "dice/d10.png-9" : 10
  };
}
class D12 extends Dice{
  @override
  Map<String, int> sides = {
    "dice/d12.png" : 1,
    "dice/d12.png-1" : 2,
    "dice/d12.png-2" : 3,
    "dice/d12.png-3" : 4,
    "dice/d12.png-4" : 5,
    "dice/d12.png-5" : 6,
    "dice/d12.png-6" : 7,
    "dice/d12.png-7" : 8,
    "dice/d12.png-8" : 9,
    "dice/d12.png-9" : 10,
    "dice/d12.png-10" : 11,
    "dice/d12.png-11" : 12
  };
}
class D20 extends Dice{
  @override
  Map<String, int> sides = {
    "dice/d20.png" : 1,
    "dice/d20.png-1" : 2,
    "dice/d20.png-2" : 3,
    "dice/d20.png-3" : 4,
    "dice/d20.png-4" : 5,
    "dice/d20.png-5" : 6,
    "dice/d20.png-6" : 7,
    "dice/d20.png-7" : 8,
    "dice/d20.png-8" : 9,
    "dice/d20.png-9" : 10,
    "dice/d20.png-10" : 11,
    "dice/d20.png-11" : 12,
    "dice/d20.png-12" : 13,
    "dice/d20.png-13" : 14,
    "dice/d20.png-14" : 15,
    "dice/d20.png-15" : 16,
    "dice/d20.png-16" : 17,
    "dice/d20.png-17" : 18,
    "dice/d20.png-18" : 19,
    "dice/d20.png-19" : 20
  };
}