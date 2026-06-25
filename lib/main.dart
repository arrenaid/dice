import 'package:dice/cubit/dice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/dice_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiceCubit>(
      create: (context) => DiceCubit(),
      child: MaterialApp(
        title: 'Dice',
        debugShowCheckedModeBanner: false,
        home: DiceScreen(),
      ),
    );
  }
}
