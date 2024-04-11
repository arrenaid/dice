import 'dart:math';
class Side{
  final String image;
  final int num;

  Side(this.image, this.num);
}

abstract class Dice {
  //abstract final Map<String,int> sides;
  abstract final List<Side> sides;

  //late int _rollResult;
  //int get rollResult => _rollResult;


  // Dice(String img, int length){
  //   for(int i = 1; i <= length; i++){
  //     sides.add(Side(img, i));
  //   }
  // }

  Side getSide(){
    var result = sides.elementAt(Random().nextInt(sides.length));
    //_rollResult = result.num;
    return result;
  }
  // String roll(){
  //   String roll = sides.keys.elementAt(Random().nextInt(sides.length));
  //   _rollResult = sides[roll]!;
  //   return roll;
  // }
}
class D6 extends Dice{
  @override
  List<Side> sides = [
      Side("dice/dice1.png" , 1),
      Side("dice/dice2.png" , 2),
      Side("dice/dice3.png" , 3),
      Side("dice/dice4.png" , 4),
      Side("dice/dice5.png" , 5),
      Side("dice/dice6.png" , 6),
  ];
  // Map<String, int> sides  = {
  //   "dice/dice1.png" : 1,
  //   "dice/dice2.png" : 2,
  //   "dice/dice3.png" : 3,
  //   "dice/dice4.png" : 4,
  //   "dice/dice5.png" : 5,
  //   "dice/dice6.png" : 6,
  // };
}
class D4 extends Dice{
  @override
  List<Side> sides = [
    Side("dice/d4.png" , 1),
    Side("dice/d4.png-1" , 2),
    Side("dice/d4.png-2" , 3),
    Side("dice/d4.png-3" , 4)
  ];

  // Map<String, int> sides = {
  //   "dice/d4.png" : 1,
  //   "dice/d4.png-1" : 2,
  //   "dice/d4.png-2" : 3,
  //   "dice/d4.png-3" : 4
  // };
}
class D8 extends Dice{
  @override
  List<Side> sides = [
    Side("dice/d8.png" , 1),
    Side("dice/d8.png-1" , 2),
    Side("dice/d8.png-2" , 3),
    Side("dice/d8.png-3" , 4),
    Side("dice/d8.png-4" , 5),
    Side("dice/d8.png-5" , 6),
    Side("dice/d8.png-6" , 7),
    Side("dice/d8.png-7" , 8)
  ];
  // Map<String, int> sides = {
  //   "dice/d8.png" : 1,
  //   "dice/d8.png-1" : 2,
  //   "dice/d8.png-2" : 3,
  //   "dice/d8.png-3" : 4,
  //   "dice/d8.png-4" : 5,
  //   "dice/d8.png-5" : 6,
  //   "dice/d8.png-6" : 7,
  //   "dice/d8.png-7" : 8
  // };
}
class D10 extends Dice{
  @override
  List<Side> sides = [
    Side("dice/d10.png" , 1),
    Side("dice/d10.png-1" , 2),
    Side("dice/d10.png-2" , 3),
    Side("dice/d10.png-3" , 4),
    Side("dice/d10.png-4" , 5),
    Side("dice/d10.png-5" , 6),
    Side("dice/d10.png-6" , 7),
    Side("dice/d10.png-7" , 8),
    Side("dice/d10.png-8" , 9),
    Side("dice/d10.png-9" , 10)
  ];
  // Map<String, int> sides = {
  //   "dice/d10.png" : 1,
  //   "dice/d10.png-1" : 2,
  //   "dice/d10.png-2" : 3,
  //   "dice/d10.png-3" : 4,
  //   "dice/d10.png-4" : 5,
  //   "dice/d10.png-5" : 6,
  //   "dice/d10.png-6" : 7,
  //   "dice/d10.png-7" : 8,
  //   "dice/d10.png-8" : 9,
  //   "dice/d10.png-9" : 10
  // };
}
class D12 extends Dice{
  @override
  List<Side> sides = [
    Side("dice/d12.png" , 1),
    Side("dice/d12.png-1" , 2),
    Side("dice/d12.png-2" , 3),
    Side("dice/d12.png-3" , 4),
    Side("dice/d12.png-4" , 5),
    Side("dice/d12.png-5" , 6),
    Side("dice/d12.png-6" , 7),
    Side("dice/d12.png-7" , 8),
    Side("dice/d12.png-8" , 9),
    Side("dice/d12.png-9" , 10),
    Side("dice/d12.png-10" , 11),
    Side("dice/d12.png-11" , 12)
  ];
  // Map<String, int> sides = {
  //   "dice/d12.png" : 1,
  //   "dice/d12.png-1" : 2,
  //   "dice/d12.png-2" : 3,
  //   "dice/d12.png-3" : 4,
  //   "dice/d12.png-4" : 5,
  //   "dice/d12.png-5" : 6,
  //   "dice/d12.png-6" : 7,
  //   "dice/d12.png-7" : 8,
  //   "dice/d12.png-8" : 9,
  //   "dice/d12.png-9" : 10,
  //   "dice/d12.png-10" : 11,
  //   "dice/d12.png-11" : 12
  // };
}
class D20 extends Dice{
  @override
  List<Side> sides = [
    Side("dice/d20.png", 1),
    Side("dice/d20.png-1", 2),
    Side("dice/d20.png-2", 3),
    Side("dice/d20.png-3", 4),
    Side("dice/d20.png-4", 5),
    Side("dice/d20.png-5", 6),
    Side("dice/d20.png-6", 7),
    Side("dice/d20.png-7", 8),
    Side("dice/d20.png-8", 9),
    Side("dice/d20.png-9", 10),
    Side("dice/d20.png-10", 11),
    Side("dice/d20.png-11", 12),
    Side("dice/d20.png-12", 13),
    Side("dice/d20.png-13", 14),
    Side("dice/d20.png-14", 15),
    Side("dice/d20.png-15", 16),
    Side("dice/d20.png-16", 17),
    Side("dice/d20.png-17", 18),
    Side("dice/d20.png-18", 19),
    Side("dice/d20.png-19", 20)
  ];
  // Map<String, int> sides = {
  //   "dice/d20.png" : 1,
  //   "dice/d20.png-1" : 2,
  //   "dice/d20.png-2" : 3,
  //   "dice/d20.png-3" : 4,
  //   "dice/d20.png-4" : 5,
  //   "dice/d20.png-5" : 6,
  //   "dice/d20.png-6" : 7,
  //   "dice/d20.png-7" : 8,
  //   "dice/d20.png-8" : 9,
  //   "dice/d20.png-9" : 10,
  //   "dice/d20.png-10" : 11,
  //   "dice/d20.png-11" : 12,
  //   "dice/d20.png-12" : 13,
  //   "dice/d20.png-13" : 14,
  //   "dice/d20.png-14" : 15,
  //   "dice/d20.png-15" : 16,
  //   "dice/d20.png-16" : 17,
  //   "dice/d20.png-17" : 18,
  //   "dice/d20.png-18" : 19,
  //   "dice/d20.png-19" : 20
  // };
}
///кость любым числом сторон
class DiceInfinite extends Dice {
  //Хранит число сторон
  late int sideCount;
  final _img =  "dice/dicecustom.png";
  @override
  List<Side> sides = [];

  DiceInfinite({int? length = 100} ){
    sides.add(Side(_img, 1));
    sideCount = length!;

  // Map<String, int> sides = {};
  //
  // DiceInfinite({int? length = 100} ){
  //   Map<String, int> map = {
  //     "dice/dicecustom.png" : 1
  //   };
  //   while(map.length != length) {
  //     map.addAll({"dice/dicecustom.png-${map.length + 1}": map.length + 1} );
  //   }
  //   sideLength = length!;
  //   sides = map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceInfinite &&
          runtimeType == other.runtimeType &&
          sides == other.sides;

  @override
  int get hashCode => sides.hashCode;

  @override
  Side getSide(){
    //получаем хранимую картинку
    //sides.keys.elementAt(Random().nextInt(sides.length));
    //_rollResult = Random().nextInt(sideLength);
    Side result = Side(_img,Random().nextInt(sideCount));
    sides.add(result);
    return result;
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
  final _img = "dice/dicepentagon.png";
  late int check = 0;
  @override
  List<Side> sides = [];
  DiceCustomSide(List<int> sideList){
    for(var value in sideList){
      sides.add(Side(_img, value));
      check += value;
    }
    check = (check/sideList.length).ceil();
  }
  // Map<String, int> sides = {};
  //
  //
  // DiceCustomSide(List<int> sideList){
  //   Map<String, int> map = {};
  //   for(int side in sideList){
  //     map.addAll({
  //       map.length == 0
  //         ? "dice/dicepentagon.png"
  //         :"dice/dicepentagon.png-${map.length}": side} );
  //   }
  //   sides = map;
  // }

  @override
  int get hashCode => sides.hashCode;

}