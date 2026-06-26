import 'package:dice/core/dice_model.dart';
import 'package:dice/widget/dice_stack_widget.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class EmptyInfoWidget extends StatelessWidget {
  final double width;

  const EmptyInfoWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final fontSize = getFontSize();
    final odds = 0.7;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Press the ',
                    style: defTs.copyWith(fontSize: fontSize, color: defPriClr),
                  ),
                  TextSpan(
                    text: 'ROLL',
                    style: defTs.copyWith(fontSize: fontSize),
                  ),
                  TextSpan(
                    text: ' button to roll the dice\n\n',
                    style: defTs.copyWith(fontSize: fontSize, color: defPriClr),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Long-pressing a ',
                          style: defTs.copyWith(
                              fontSize: fontSize * odds, color: defPriClr),
                        ),
                        TextSpan(
                          text: 'ROLL',
                          style: defTs.copyWith(fontSize: fontSize * odds),
                        ),
                        TextSpan(
                          text: ' adds new dice\n\n',
                          style: defTs.copyWith(
                              fontSize: fontSize * odds, color: defPriClr),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Long-pressing a ',
                          style: defTs.copyWith(
                              fontSize: fontSize * odds, color: defPriClr),
                        ),
                        TextSpan(
                          text: 'result (7)',
                          style: defTs.copyWith(fontSize: fontSize * odds),
                        ),
                        TextSpan(
                          text: ' displays the history',
                          style: defTs.copyWith(
                              fontSize: fontSize * odds, color: defPriClr),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  double getFontSize() {
    //var width = MediaQuery.of(context).size.width;
    var odds = width / 500;
    return odds >= 1 ? 35 : 35 * odds;
  }
}
