import 'package:dice/bottom_sheet_widget.dart';
import 'package:dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants.dart';

class DiceScreen extends StatelessWidget {
  const DiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit,DiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: defPriClr,
          body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                    child: state.currentImg.isEmpty ? null
                        : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: state.listDice.length < 4 ? state.listDice
                              .length : 3,
                        ),
                        itemCount: state.currentImg.length,
                        physics: state.listDice.length < 7
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(image: state.currentImg[index].image, color: defSecClr),
                          );
                        }),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: state.currentImg.isEmpty ? null
                              : Text("${state.rollResult}",
                            style: defTs.copyWith(fontSize: 100),
                          ),
                        ),
                        Container(
                          child: state.currentImg.isEmpty ? null
                              : Text("${state.rollMax}",
                            style: defTs.copyWith(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 50,),
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),),
                    color: Colors.brown,
                    splashColor: Colors.brown[900],
                    elevation: 15,
                    enableFeedback: true,
                    textColor: Colors.white,
                    child: Text("ROLL",
                        style: defTs.copyWith(fontSize: 40,shadows: []),
                    ),
                    onPressed: () => context.read<DiceCubit>().roll(),
                    onLongPress: () {
                      showModalBottomSheet(
                              context: context,
                              elevation: 15,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (_) => DiceController(),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 10),
                ],
              )
          ),
        );
      }
    );
  }
}
