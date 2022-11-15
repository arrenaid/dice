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
 // List<Dice> listAllDice = [ D4(), D6(), D8(), D10(), D12(), D20(), AnonymousDice() ];

  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(builder: (context, state) {
      return Scaffold(
          backgroundColor: defPriClr,
          body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.listAllDice.length,//listAllDice.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: state.listAllDice[index].runtimeType == AnonymousDice
                    ? addCustomDiceRow(context)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      state.listAllDice[index].runtimeType == DCustom
                      ? ElevatedButton(
                        onPressed: () => context.read<DiceCubit>().removeCustomDice(index),
                        child: Text("del",style: defTs,),
                        // Icon(
                        //   Icons.add,
                        //   color: defPriClr,
                        // ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defBtnClr,
                          elevation: 3,
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      )
                      : Container(
                          height: MediaQuery.of(context).size.width / 6,
                          child: Image.asset(
                              state.listAllDice[index].sides.keys.first,
                              color: defSecClr)),

                      Expanded(
                        child: Text( state.listAllDice[index].runtimeType == DCustom
                            ? "D${state.listAllDice[index].sides.length} : "
                            " ${context.read<DiceCubit>().countType(state.listAllDice[index])}"
                            : "${state.listAllDice[index].runtimeType} :"
                            " ${context.read<DiceCubit>().countType(state.listAllDice[index])}"
                          ,style: defTs.copyWith(overflow: TextOverflow.fade),
                            textAlign: TextAlign.center),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.read<DiceCubit>().addDice(
                                  state.listAllDice[index]),
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
                                  .removeDice(state.listAllDice[index]),
                              child: Icon(Icons.close, color: defPriClr)),
                        ],
                      )
                    ]),
              );
            },
          ));
    });
  }

  Widget addCustomDiceRow(BuildContext context){
    int lengthValue = 1;
    return isVisible
        ? Row(
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
              onSaved: (value) => lengthValue = int.parse(value!),
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
                isVisible = false;
                context.read<DiceCubit>().insertCustomDice(lengthValue);
              });
              ScaffoldMessenger.of(context).showSnackBar(MySnackBar("Add Custom Dice"));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(MySnackBar("error form"));
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
    )
    :Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isVisible = true;
          });
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
    );
  }
}

SnackBar MySnackBar(String title){
  return SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),),
      elevation: 35,
      duration: const Duration(seconds: 3),
      backgroundColor:defBtnClr,
      content: Text( title,
        style: defTs,
        textAlign: TextAlign.center,));
}
