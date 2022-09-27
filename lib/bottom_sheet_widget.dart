import 'package:dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants.dart';
import 'dice_model.dart';

class DiceController extends StatelessWidget {
  final List<Dice> listAllDice = [D4(), D6(), D8(), D10(), D12(), D20()];

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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.width / 6,
                          child: Image.asset(
                              listAllDice[index].sides.keys.first,
                              color: defSecClr)),
                      Text(
                        "${listAllDice[index].runtimeType} :"
                        " ${context.read<DiceCubit>().countType(listAllDice[index])}",
                        style: defTs,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => context
                                .read<DiceCubit>()
                                .addDice(listAllDice[index]),
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
}
