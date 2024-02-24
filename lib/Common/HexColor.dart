import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static HexColor goodColor = HexColor("#F1FAEE");
  static HexColor middleColor = HexColor("#A8DADC");
  static HexColor badColor = HexColor("#457B9D");
  static HexColor mainAnswerColor = HexColor("#F6F2D4");
  static HexColor greenSelectAnswer = HexColor("#03fccf");
  static HexColor defaultAnswer = HexColor("#f2f5a4");
  static HexColor processScreenColor = HexColor("#7F9195");

}