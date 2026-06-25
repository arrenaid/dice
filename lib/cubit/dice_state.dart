part of 'dice_cubit.dart';

enum StateStatus { initial, loaded, loading, error, rolling }

class DiceState extends Equatable {
  final List<DiceStackWidget> currentImg;
  final List<Dice> listAllDice;
  final List<Dice> listDice;
  final int rollResult;

  final int rollMax;
  final StateStatus status;
  final double successThreshold;
  final List<RollHistory> past;

  const DiceState({
    required this.currentImg,
    required this.listDice,
    required this.rollResult,
    required this.rollMax,
    required this.status,
    required this.listAllDice,
    required this.successThreshold,
    required this.past,
  });

  @override
  List<Object?> get props =>
      [currentImg, listDice, rollResult, rollMax, status];

  DiceState copyWith(
      {List<DiceStackWidget>? currentImg,
      List<Dice>? listDice,
      int? rollResult,
      int? rollMax,
      StateStatus? status,
      List<Dice>? listAllDice,
      double? successThreshold,
      List<RollHistory>? past}) {
    return DiceState(
        currentImg: currentImg ?? this.currentImg,
        listDice: listDice ?? this.listDice,
        rollResult: rollResult ?? this.rollResult,
        rollMax: rollMax ?? this.rollMax,
        status: status ?? this.status,
        listAllDice: listAllDice ?? this.listAllDice,
        successThreshold: successThreshold ?? this.successThreshold,
        past: past ?? this.past);
  }
}
