import 'package:dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants.dart';
import 'dice_model.dart';

class DiceController extends StatefulWidget {
  @override
  State<DiceController> createState() => _DiceControllerState();
}

class _DiceControllerState extends State<DiceController> {
  List<Dice> listAllDice = [ D4(), D6(), D8(), D10(), D12(), D20(), AnonymousDice() ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: defPriClr,
          body: ListView.builder(
            itemCount: listAllDice.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: listAllDice[index].runtimeType == AnonymousDice
                    ? addCustomDiceRow(context)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.width / 6,
                          child: Image.asset(
                              listAllDice[index].sides.keys.first,
                              color: defSecClr)),

                      Text( listAllDice[index].runtimeType == DCustom
                          ? "D${listAllDice[index].sides.length} :"
                          : "${listAllDice[index].runtimeType} :"
                          " ${context.read<DiceCubit>().countType(listAllDice[index])}",style: defTs,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.read<DiceCubit>().addDice(
                                  listAllDice[index]),
                            child: Icon(
                              Icons.add,
                              color: defPriClr,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: defSecClr,
                              elevation: 3,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30))),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: defSecClr,
                                elevation: 3,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                ),
                              ),
                              onPressed: () => context
                                  .read<DiceCubit>()
                                  .removeDice(listAllDice[index]),
                              child: Icon(Icons.close, color: defPriClr)),
                        ],
                      )
                    ]),
              );
            },
          ));
    });
  }

  Widget addCustomDiceRow(context){
    int length = 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            child: TextFormField(
              decoration: InputDecoration(hintText: "Dice number",
                hintStyle: defTs ,
                suffixStyle: defTs,
                labelStyle: defTs,
                helperStyle: defTs,
                errorStyle: defTs,
                prefixStyle: defTs,
                counterStyle: defTs,
              ),
              style: defTs,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onSaved: (value) => length = int.parse(value!),
              validator: (value) {
                if (value!.isEmpty) {
                  return "pls enter...";
                }
                if (int.parse(value) < 1) {
                  return "pls enter number > 0...";
                }
                return null;
              },
              onFieldSubmitted: (_) => _formKey.currentState!.validate(),
            ),
          ),
        ),

        ElevatedButton(
          onPressed: () {

            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              setState(() {
                listAllDice.add(DCustom(length: length));
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  elevation: 15,
                  duration: const Duration(seconds: 3),
                  content: const Text("Add new Dice",
                    style: defTs,)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  elevation: 15,
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.red.withOpacity(0.6),
                  content: const Text("error form",
                    style: defTs,)));
            }
          },
          child: Icon(
            Icons.add,
            color: defPriClr,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: defSecClr,
            elevation: 3,
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }
}
