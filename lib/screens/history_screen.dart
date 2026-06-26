import 'package:dice/constants.dart';
import 'package:dice/core/roll_history.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<RollHistory> past;
  final double width;

  const HistoryScreen({super.key, required this.past, required this.width});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defPriClr,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Text(
              'roll history ${past.length}'.toUpperCase(),
              style: defTs.copyWith(color: defSecClr, shadows: []),
              textAlign: TextAlign.center,
            ),
            past.isEmpty
                ? Center(
                    child: Text(
                      'empty'.toUpperCase(),
                      style: defTs.copyWith(color: defBtnClr, shadows: []),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: past.length,
                    itemBuilder: (context, index) {
                      int xedni = past.length - index - 1;
                      return HistoryRow(past: past[xedni], maxWidth: width,);
                    },
                    separatorBuilder: (c, i) => SizedBox(height: 10),
                  ),
          ],
        ),
      ),
    );
  }
}

class HistoryRow extends StatelessWidget {
  const HistoryRow({
    super.key,
    required this.past,
    required this.maxWidth,
  });

  final RollHistory past;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    bool isWin = past.result >= past.max * past.threshold;
    return SizedBox(
      height: 120,
      child: OverflowBox(
        maxWidth: maxWidth,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 30),
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: isWin ? defSecClr : defBtnClr,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(
                      "${past.result}",
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        fontFamily: "MarkoOne",
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: isWin ? defBtnClr : defSecClr,
                      ),
                    ),
                    Text(
                      "st:${past.threshold} max:${past.max}",
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                        fontFamily: "MarkoOne",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isWin ? defBtnClr : defSecClr,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: past.side.length,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    past.side[index].setFontSize(25);
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: past.side[index],
                    );
                  },
                  separatorBuilder: (c, i) => SizedBox(width: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
