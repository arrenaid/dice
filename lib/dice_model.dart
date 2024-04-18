import 'dart:math';

import 'package:dice/constants.dart';
class Side{
  final String image;
  final int num;

  Side(this.image, this.num);

  @override
  String toString() {
    return 'Side{image: $image, num: $num}';
  }
  // Map<String,dynamic> toJson(){
  //   return{ 'image': image, 'num': num };
  // }
}

abstract class Dice {
  abstract final List<Side> sides;
  //abstract final String img;
  final color = colorGenerator.generate();


  Side getSide(){
    var result = sides.elementAt(Random().nextInt(sides.length));
    return result;
  }
}
class D6 extends Dice{
  @override
  List<Side> sides = [
      Side("dice/d6_1.png" , 1),
      Side("dice/d6_2.png" , 2),
      Side("dice/d6_3.png" , 3),
      Side("dice/d6_4.png" , 4),
      Side("dice/d6_5.png" , 5),
      Side("dice/d6_6.png" , 6),
  ];
}
class D4 extends Dice{
  @override
  List<Side> sides = List<Side>.generate(4,(counter) =>
      Side("dice/d4.png" , counter + 1));

}
class D8 extends Dice{

  @override
  List<Side> sides = List<Side>.generate(8,(counter) =>
  Side("dice/d8.png" , counter + 1));

}
class D10 extends Dice{
  @override
  List<Side> sides = List<Side>.generate(10,(counter) =>
      Side("dice/d10.png" , counter + 1));
}
class D12 extends Dice{
  @override
  List<Side> sides = List<Side>.generate(12,(counter) =>
      Side("dice/d12.png" , counter + 1));
}
class D20 extends Dice{
  @override
  List<Side> sides =List.generate(20, (counter) =>
      Side("dice/d20.png", counter + 1));
}
///кость любым числом сторон
class DiceInfinite extends Dice {
  ///Хранит число сторон для того что бы генерировать сторону только когда она будет вызвана
  late int sideCount;
  final img =  "dice/dice_infinite.png";
  late final int keyValue;
  @override
  List<Side> sides = [];

  DiceInfinite({int length = 100, int key = 0} ){
    sides.add(Side(img, 1));
    sideCount = length;
    keyValue = key == 0 ? Random().nextInt(maxIntRandom) : key;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceInfinite &&
          runtimeType == other.runtimeType &&
          sides == other.sides;

  @override
  int get hashCode => sides.hashCode + keyValue.hashCode ;

  @override
  Side getSide(){
    Side result = Side(img,Random().nextInt(sideCount+1));
    sides.add(result);
    return result ;
  }

}
class AnonymousDice extends Dice{
  @override
  List<Side> get sides => throw UnimplementedError();
}

/// кость с задаваемым числом стороны
/// предыдущие кости в качестве числа стороны имели свой порядковый номер
///
class DiceCustomSide extends Dice{
  final img = "dice/dice_pentagon.png";
  late final int keyValue;
  late int check = 0;
  @override
  List<Side> sides = [];
  DiceCustomSide(List<int> sideList, { int key = 0}){
    for(var value in sideList){
      sides.add(Side(img, value));
      check += value;
    }
    check = (check/sideList.length).ceil();
    keyValue = key == 0
        ? Random().nextInt(maxIntRandom)
        : key;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DiceCustomSide &&
              runtimeType == other.runtimeType &&
              check == other.check &&
              sides == other.sides;

  @override
  int get hashCode => sides.hashCode + sides.first.hashCode
      + check.hashCode.hashCode + keyValue.hashCode;

}