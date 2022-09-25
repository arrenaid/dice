
import 'package:flutter/material.dart';
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
      //TODO: go str.substring(0,str.indexOf("-"))
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
      for(int i  = 0; i < _listDice.length; i++){
        if(_listDice[i].runtimeType == type.runtimeType){
          _listDice.removeAt(i);
          return;
        }
      }
      _countType(type);
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
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder){
          return Scaffold(
            backgroundColor: Colors.brown[600],
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("dice: ${_listDice.length}"),
                      ElevatedButton(onPressed: (){}, child: Text("clear")),
                    ]
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container( height: 100, child: Image.asset(D4().sides.keys.first)),
                        Text("${_countType(D4())}"),
                        ElevatedButton(onPressed: () => _addDice(D4()), child: Text("+")),
                        ElevatedButton(onPressed: ()=> _removeDice(D4()), child: Text("-")),
                      ]
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 100,child: Image.asset(D6().sides.keys.last)),
                        Text("${_countType(D6())}"),
                        ElevatedButton(onPressed: ()=> _addDice(D6()), child: Text("+")),
                        ElevatedButton(onPressed: ()=> _removeDice(D6()), child: Text("-")),
                      ]
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 100,child: Image.asset(D8().sides.keys.first)),
                        Text("${_countType(D8())}"),
                        ElevatedButton(onPressed: ()=> _addDice(D8()), child: Text("+")),
                        ElevatedButton(onPressed: ()=> _removeDice(D8()), child: Text("-")),
                      ]
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 100,child: Image.asset(D10().sides.keys.first)),
                        Text("${_countType(D10())}"),
                        ElevatedButton(onPressed: () => _addDice(D10()), child: Text("+")),
                        ElevatedButton(onPressed: ()=> _removeDice(D10()), child: Text("-")),
                      ]
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 100,child: Image.asset(D12().sides.keys.first,color: Colors.white)),
                        Text("${_countType(D12())}"),
                        ElevatedButton(onPressed: () => _addDice(D12()), child: Text("+")),
                        ElevatedButton(onPressed: () => _removeDice(D12()), child: Text("-")),
                      ]
                  ),
                  Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 100,child: Image.asset(D20().sides.keys.first,color: Colors.white)),
                        Text("${_countType(D20())}"),
                        ElevatedButton(onPressed: () => _addDice(D20()), child: Text("+")),
                        ElevatedButton(onPressed: () => _removeDice(D20()), child: Text("-")),
                      ]
                  ),
                ],
              ),
            ),
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
      backgroundColor: Colors.brown[400],
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
