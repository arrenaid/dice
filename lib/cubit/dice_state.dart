part of 'dice_cubit.dart';

enum StateStatus{ initial, loaded, loading, error, rolling}

class DiceState extends Equatable {
  final List<Widget> currentImg;
  final List<Dice> listAllDice;
  final List<Dice> listDice;
  final int rollResult ;
  final int rollMax;
  final StateStatus status;

  const DiceState({required this.currentImg,
        required this.listDice,
        required this.rollResult,
        required this.rollMax,
        required this.status,
    required this.listAllDice
  });

  @override
  List<Object?> get props => [currentImg,listDice,rollResult,rollMax,status];
  DiceState copyWith({
    List<Widget>? currentImg,
    List<Dice>? listDice,
    int? rollResult,
    int? rollMax,
    StateStatus? status,
    List<Dice>? listAllDice
  }){
    return DiceState(currentImg: currentImg ?? this.currentImg,
        listDice: listDice ?? this.listDice,
        rollResult: rollResult ?? this.rollResult,
        rollMax: rollMax ?? this.rollMax,
        status: status ?? this.status,
        listAllDice: listAllDice ?? this.listAllDice
    );
  }

}