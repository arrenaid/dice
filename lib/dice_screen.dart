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

  late List<String> current=[];
  List<Dice> _listDice = [D6(),D20()];
  int _rollResult = 0;
  int _rollMax = 26;


  int _countRollMax(){
    int result = 0;
    for (var element in _listDice) {
      result += element.sides.values.last;
    }
    setState(() {
      _rollMax = result;
    });
    return result;
  }

  void roll(){
    _rollResult = 0;
    setState(() {
      current = [];
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
      _countRollMax();
    });
  }
  void _removeDice(Dice type){
    setState(() {
      if(_listDice.length > 1) {
        for (int i = 0; i < _listDice.length; i++) {
          if (_listDice[i].runtimeType == type.runtimeType) {
            _listDice.removeAt(i);
            _countRollMax();
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
                              ElevatedButton(
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
                              ElevatedButton(
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
                            ],
                          )
                        ]
                    ),
                  );
                },
            )
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defPriClr,
      body: SafeArea(
        child: Container(
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
                        child: Image.asset(current[index],color: defSecClr),
                      );
                    }),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: current.isEmpty ? null
                          : Text("${_rollResult}",
                      style: defTs.copyWith(fontSize: 100),
                      ),
                    ),
                    Container(
                      child: current.isEmpty ? null
                          : Text("${_rollMax}",
                        style: defTs.copyWith(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox( height: MediaQuery.of(context).size.height/50,),
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
              SizedBox( height: MediaQuery.of(context).size.height/10),
            ],
          ),
        )
      ),
    );
  }
}
