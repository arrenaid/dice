
import 'dart:math';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'dice_model.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({Key? key}) : super(key: key);

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  // Map<String,int> mapDice = {
  //   //   "dice/dice1.png" : 1,
  //   //   "dice/dice2.png" : 2,
  //   //   "dice/dice3.png" : 3,
  //   //   "dice/dice4.png" : 4,
  //   //   "dice/dice5.png" : 5,
  //   //   "dice/dice6.png" : 6,
  //   // };
  late List<String> current=[];
  //int diceLength = 2;
  List<Dice> _listDice = [D6(),D20()];
  int _rollResult = 0;

  void roll(){
    //Random random = Random();
    _rollResult = 0;
    setState(() {
      current = [];
      // for(var index = 0; index < diceLength; index++) {
      //   current.add(mapDice.keys.elementAt(random.nextInt(mapDice.length)));
      // }
      for (var element in _listDice) {
        String res = element.roll();
        _rollResult += element.sides[res]!;
        int index = res.indexOf("-");
        if(index > 0) {
          current.add(res.substring(0,index));
        } else {
          current.add(res);
        }
      }
      _shake();
    });
  }
  void _shake(){
    Random random = Random();
    List<Dice> twin = _listDice;
    List<Dice> result = [];
    while(twin.length > 0){
      int index = random.nextInt(twin.length);
      result.add(twin.elementAt(index));
      twin.removeAt(index);
    }
    setState(() {
      _listDice = result;
    });
  }
  void _addDice(Dice dice){
    setState(() {
      _listDice.add(dice);
      _countType(dice);
    });
  }
  void _removeDice(Dice type){
    setState(() {
      if(_listDice.length > 1) {
        for (int i = 0; i < _listDice.length; i++) {
          if (_listDice[i].runtimeType == type.runtimeType) {
            _listDice.removeAt(i);
            return;
          }
        }
      }
    });
  }
  int _countType(Dice type){
    int result =0;
    for(int i  = 0; i < _listDice.length; i++){
      if(_listDice[i].runtimeType == type.runtimeType){
        result += 1;
      }
    }
    return result;
  }

  void _modalBottomSheetMenu(){
    final List<Dice> listAllDice = [D4(),D6(),D8(),D10(),D12(),D20()];
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder){
          return Scaffold(
            backgroundColor: defPriClr,
            body: ListView.builder(
              itemCount: listAllDice.length,
                itemBuilder: (context,index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical:5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 100,
                              child: Image.asset(listAllDice[index].sides.keys.first, color: defSecClr)),
                          Text("${listAllDice[index].runtimeType} : ${_countType(listAllDice[index])}",
                              style: defTs,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _addDice(listAllDice[index]);
                                    });
                                  },
                                  child: Icon(Icons.add,color:defPriClr,),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: defSecClr,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30) )),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: defSecClr,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _removeDice(listAllDice[index]);
                                      });
                                    },
                                    child: Icon(Icons.close,color: defPriClr)
                                ),
                              ),
                            ],
                          )
                        ]
                    ),
                  );
                },
            )
            //
            // GridView.builder(
            //   itemCount: listAllDice.length,
            //   physics: BouncingScrollPhysics(),
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     crossAxisSpacing: 5.0,
            //     mainAxisSpacing: 5.0,
            //   ),
            //   itemBuilder: (context,index) {
            //     return Row(
            //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //             height: 150,
            //               child: Image.asset(listAllDice[index].sides.keys.first, color: Colors.white)),
            //           Text("${_countType(listAllDice[index])}",
            //             style: TextStyle(
            //                 fontSize: 18,
            //                 fontFamily: "MarkoOne",
            //                 fontWeight: FontWeight.bold
            //             )
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               ElevatedButton(
            //                 onPressed: () => _addDice(listAllDice[index]),
            //                 child: Container(child: Icon(Icons.add,color: Colors.brown[700],),
            //                   //padding: EdgeInsets.all(20),
            //                   height: 40, width: 40,
            //                 ),
            //                 style: ElevatedButton.styleFrom(
            //                   backgroundColor: Colors.white,
            //                     elevation: 3,
            //                     shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(30)),
            //                 ),
            //               ),
            //               ElevatedButton(
            //                   style: ElevatedButton.styleFrom(
            //                     backgroundColor: Colors.white,
            //                     elevation: 3,
            //                     shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(30)),
            //                   ),
            //                   onPressed: () => _removeDice(listAllDice[index]),
            //                   child: Icon(Icons.close,color: Colors.brown[700])
            //               ),
            //             ],
            //           )
            //         ]
            //     );
            //   },




              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,

              // children: [
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("dice: ${_listDice.length}"),
              //       ElevatedButton(onPressed: (){}, child: Text("clear")),
              //     ]
              //   ),
              //   Divider(),

            //),
          );
        }
    );
  }
  // int getAmount(){
  //   int result = 0;
  //   current.forEach((element) {
  //     result += mapDice[element]!;
  //   });
  //   return result;
  // }
  // void shift(){
  //   if(current.isNotEmpty){
  //     setState(() {
  //       try{
  //         if (mapDice[current[0]]! < mapDice[current[1]]!) {
  //           diceLength--;
  //         } else {
  //           diceLength++;
  //         }
  //       }catch(e){
  //         diceLength = 2;
  //       }
  //       if(diceLength < 1 ) diceLength = 2;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defPriClr,
      body: SafeArea(
        child: Container(
          //height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2,
                padding: const EdgeInsets.all(20.0),
                child: current.isEmpty ? null
                    : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _listDice.length < 4 ? _listDice.length : 3,
                    ),
                    itemCount: current.length,
                    physics: _listDice.length < 7 ? const NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                       return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(current[index],color: Colors.white,),
                      );
                    }),
              ),
              Center(
                child: Container(
                  child: current.isEmpty ? null
                      : Text("${_rollResult}",
                  style: const TextStyle(
                    shadows: [Shadow(
                      offset: Offset(10.0, 10.0),
                      blurRadius: 8.0,
                      color: Colors.brown,
                    ),],
                    color: Colors.white,
                    fontSize: 100,
                    fontFamily: "MarkoOne",
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              SizedBox( height: 20,),
              MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),),
                color: Colors.brown,
                splashColor: Colors.brown[900],
                elevation: 15,
                enableFeedback: true,
                textColor: Colors.white,
                child: Text("ROLL",style: TextStyle(
                  fontSize: 40,
                  fontFamily: "MarkoOne",
                  fontWeight: FontWeight.bold
                ),),
                  onPressed: roll,
                onLongPress: _modalBottomSheetMenu,
              ),
              SizedBox( height: 100,),
            ],
          ),
        )
      ),
    );
  }
}
