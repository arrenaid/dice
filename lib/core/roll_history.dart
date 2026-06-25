import 'package:dice/widget/dice_stack_widget.dart';

///храним результаты каждого броска
class RollHistory {
  final List<DiceStackWidget> side;
  final double threshold;
  final int result;
  final int max;

  RollHistory(
      {required this.side,
      required this.threshold,
      required this.result,
      required this.max});
}
