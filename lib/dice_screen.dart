import 'dart:math';
import 'package:flutter/material.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({Key? key}) : super(key: key);

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  Map<String,int> mapDice = {
    "dice/dice1.png" : 1,
    "dice/dice2.png" : 2,
    "dice/dice3.png" : 3,
    "dice/dice4.png" : 4,
    "dice/dice5.png" : 5,
    "dice/dice6.png" : 6,
  };
  late List<String> current=[];
  int diceLength = 2;

  void roll(){
    Random random = Random();
    setState(() {
      current = [];
      for(var index = 0; index < diceLength; index++) {
        current.add(mapDice.keys.elementAt(random.nextInt(mapDice.length)));
      }
    });
  }

  int getAmount(){
    int result = 0;
    current.forEach((element) {
      result += mapDice[element]!;
    });
    return result;
  }
  void shift(){
    if(current.isNotEmpty){
      setState(() {
        try{
          if (mapDice[current[0]]! < mapDice[current[1]]!) {
            diceLength--;
          } else {
            diceLength++;
          }
        }catch(e){
          diceLength = 2;
        }
        if(diceLength < 1 ) diceLength = 2;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[400],
      body: SafeArea(
        child: Container(
          //height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(20.0),
                child: current.isEmpty ? null
                    : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: diceLength < 4 ? diceLength : 3,
                    ),
                    itemCount: current.length,
                    physics: diceLength < 7 ? const NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                       return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(current[index]),
                      );
                    }),
              ),
              Center(
                child: Container(
                  child: current.isEmpty ? null
                      : Text("${getAmount()}",
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
                onLongPress: shift,
              )
            ],
          ),
        )
      ),
    );
  }
}
