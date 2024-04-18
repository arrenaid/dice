import 'package:dice/color_generate.dart';
import 'package:flutter/material.dart';
// const Color defPriClr = Color(0xFF8D6E63);//
// const Color defSecClr = Color(0xFFCDF0EA); // EEE3CB // CDF0EA
// //const Color defBtnClr = Color(0xFF3E2723);
// const Color defBtnClr = Colors.brown;
// //blue
// const Color defPriClr = Color(0xFF3F72AF);
// const Color defSecClr = Color(0xFFDBE2EF);
// const Color defBtnClr = Color(0xFF112D4E);
// //blue
// //pink-milk
// const Color defPriClr = Color(0xFFEDEDED);
// const Color defSecClr = Color(0xFFFF8787);
// const Color defBtnClr = Color(0xFFD8D9CF);
// //pink-milk
//green


const Color col1 = Color(0xFF222831);//
const Color col2 = Color(0xFF393E46);
const Color col3 = Color(0xFFB71C1C);//B71C1C//FFD369
const Color col4 = Color(0xFFa15501);
const Color col5 = Color(0xFFd0902f);


const Color defPriClr = Color(0xFF307672);
const Color defSecClr = Color(0xFFE4EDDB);
const Color defBtnClr = Color(0xFF144D53);
// const Color defPriClr = col1;
// const Color defSecClr =col5;
// const Color defBtnClr = col3;

const List<Color> colorsDice = [
    // Color(0xFFFECACA),
    // Color(0xFFFED7AA),
    // Color(0xFFFDE68A),
    // Color(0xFFFEF08A),
    // Color(0xFFD9F99D),
    // Color(0xFFBBF7D0),
    // Color(0xFFA7F3D0),
    // Color(0xFF99F6E4),
    // Color(0xFFA5F3FC),
    // Color(0xFFBAE6FD),
    // Color(0xFFBFDBFE),
    // Color(0xFFC7D2FE),
    // Color(0xFFDDD6FE),
    // Color(0xFFE9D5FF),
    // Color(0xFFF5D0FE),
    // Color(0xFFFBCFE8),
    // Color(0xFFFECDD3),
    Color(0xFFFEE2E2),
    Color(0xFFFFEDD5),
    Color(0xFFFEF3C7),
    Color(0xFFFEF9C3),
    Color(0xFFECFCCB),
    Color(0xFFDCFCE7),
    Color(0xFFD1FAE5),
    Color(0xFFD1FAE5),
    Color(0xFFCFFAFE),
    Color(0xFFE0F2FE),
    Color(0xFFDBEAFE),
    Color(0xFFE0E7FF),
    Color(0xFFDDD6FE),
    Color(0xFFE9D5FF),
    Color(0xFFFAE8FF),
    Color(0xFFFCE7F3),
    Color(0xFFFFE4E6),
];
//
const TextStyle defTs =  TextStyle(
    color: defSecClr,
    fontSize: 24,
    fontFamily: "MarkoOne",
    fontWeight: FontWeight.bold,
    shadows: [Shadow(
      offset: Offset(10.0, 10.0),
      blurRadius: 8.0,
      color: defBtnClr ),],
);

const String sharedDiceInfiniteKey = "dice_infinite_key";
const String sharedLengthKey = "length_dice_key";
const String sharedDiceCustomSideKey = "dice_custom_side_key";
//const String sharedDCSSidesKey = "dcs_sides_key_";
const String jsonCountType = "type";
const String jsonCountCount = "count";
const String jsonCountKey = "key";
const String jsonInfiniteLength = 'infinite_length';
const String jsonInfiniteKey = 'infinite_key';
const String jsonDcsKey ='dcs_key';
const String jsonDcsSides ='dcs_sides';
const int maxIntRandom = 0x3FFFFFFF;

final ColorGenerator colorGenerator = ColorGenerator(colorsDice);
