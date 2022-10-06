import 'package:dice/constants.dart';
import 'package:flutter/material.dart';

class SplashAnimationWidget extends StatelessWidget {
  SplashAnimationWidget({
    Key? key,
    required this.controller,
    required this.context,
  })  : width = Tween<double>(
          begin: 100.0,
          end: MediaQuery.of(context).size.width,
        ).animate(controller),
        height =
            Tween<double>(begin: 0.0, end: MediaQuery.of(context).size.height)
                .animate(controller),
        super(key: key);

  final BuildContext context;
  final Animation<double> controller;
  final Animation<double> height;
  final Animation<double> width;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      width: width.value,
      height: height.value,
      color: Colors.brown[600],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
