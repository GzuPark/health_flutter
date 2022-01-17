import 'package:flutter/material.dart';

Color mainColor = const Color(0xFF81d0d6);
Color subColor = const Color(0xffff9be1);
Color bgColor = Colors.white;
Color inactiveBgColor = Colors.grey.withOpacity(0.1);
Color txtColor = Colors.black;
Color inactiveTxtColor = Colors.black38;

MaterialColor mainGroupColor = MaterialColor(
  mainColor.value,
  <int, Color>{
    50: mainColor,
    100: mainColor,
    200: mainColor,
    300: mainColor,
    400: mainColor,
    500: mainColor,
    600: mainColor,
    700: mainColor,
    800: mainColor,
    900: mainColor,
  },
);

double cardSize = 130;

TextStyle sTextStyle = const TextStyle(fontSize: 12);
TextStyle mTextStyle = const TextStyle(fontSize: 16);
TextStyle lTextStyle = const TextStyle(fontSize: 20);

void changeToDarkMode() {
  bgColor = const Color(0xFF3a3a3c);
  txtColor = Colors.white;
}
