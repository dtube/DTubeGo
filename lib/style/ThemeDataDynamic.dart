import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';

Color globalBlue = Color.fromRGBO(34, 49, 84, 1);
Color globalRed = Color.fromRGBO(240, 26, 48, 1);
Color globalAlmostWhite = Color.fromRGBO(230, 230, 230, 1);
Color globalAlmostBlack = Color.fromRGBO(29, 35, 51, 1);
Color globalBGColor = Color.fromRGBO(29, 35, 51, 1);
Color globalBGColorNoOpacity = Color.fromRGBO(29, 35, 51, 0);

Color globalTextColor = Colors.white;
double globalIconSizeSmall = 20.sp;
double globalIconSizeMedium = 23.sp;
double globalIconSizeBig = 25.sp;

final ThemeData dtubeDarkTheme = ThemeData(
  primarySwatch: MaterialColor(4280361249, {
    50: Color(0xfff2f2f2),
    100: Color(0xffe6e6e6),
    200: Color(0xffcccccc),
    300: Color(0xffb3b3b3),
    400: Color(0xff999999),
    500: Color(0xff808080),
    600: Color(0xff666666),
    700: Color(0xff4d4d4d),
    800: Color(0xff333333),
    900: Color(0xff191919)
  }),
  brightness: Brightness.dark,
  primaryColor: Color(0xff212121),
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: Color(0xff9e9e9e),
  primaryColorDark: Color(0xff000000),
  accentColor: Color(0xffef1a30),
  accentColorBrightness: Brightness.light,
  canvasColor: globalBGColor,
  scaffoldBackgroundColor: globalBGColor,
  cardColor: Color(0xff424242),
  dividerColor: Color(0x1fffffff),
  highlightColor: Color(0x40cccccc),
  splashColor: Color(0x40cccccc),
  selectedRowColor: Color(0xfff5f5f5),
  unselectedWidgetColor: globalTextColor,
  disabledColor: Color(0x4dffffff),
  buttonColor: Color(0xff223153),
  toggleableActiveColor: Color(0xffef192f),
  secondaryHeaderColor: Color(0xff616161),
  backgroundColor: Color(0xff616161),
  dialogBackgroundColor: Color(0xff424242),
  indicatorColor: Color(0xff64ffda),
  hintColor: Color(0x80ffffff),
  errorColor: Color(0xffd32f2f),
  appBarTheme: AppBarTheme(backgroundColor: globalBGColor, elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    alignment: Alignment.center,
    elevation: 8,
    primary: globalRed,
  )),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    minWidth: 88.0,
    height: 36.0,
    padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 16.0, right: 16.0),
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Color(0xff000000),
        width: 0.0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
    alignedDropdown: false,
    buttonColor: Color(0xff223153),
    disabledColor: Color(0x4dffffff),
    highlightColor: Color(0x29ffffff),
    splashColor: Color(0x1fffffff),
    colorScheme: ColorScheme(
      primary: Color(0xff212140),
      primaryVariant: Color(0xff000000),
      secondary: Color(0xff64ffda),
      secondaryVariant: Color(0xff00bfa5),
      surface: Color(0xff424242),
      background: Color(0xff616161),
      error: Color(0xffd32f2f),
      onPrimary: globalTextColor,
      onSecondary: Color(0xff000000),
      onSurface: globalTextColor,
      onBackground: globalTextColor,
      onError: Color(0xff000000),
      brightness: Brightness.dark,
    ),
  ),
  textTheme: TextTheme(
      headline1: TextStyle(
        color: globalTextColor,
        fontSize: 30.sp,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
      ),
      headline2: TextStyle(
        color: globalTextColor,
        fontSize: 30.sp,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      ),
      headline3: TextStyle(
        color: globalTextColor,
        fontSize: 25.sp,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
      ),
      headline4: TextStyle(
        color: globalTextColor,
        fontSize: 25.sp,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      ),
      headline5: TextStyle(
        color: globalTextColor,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      ),
      headline6: TextStyle(
        color: globalTextColor,
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      ),
      subtitle1: TextStyle(
        color: globalTextColor,
        fontSize: 17.sp,
        fontWeight: FontWeight.w200,
        fontStyle: FontStyle.normal,
      ),
      bodyText1: TextStyle(
        color: globalTextColor,
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      bodyText2: TextStyle(
        color: globalTextColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      caption: TextStyle(
        color: globalTextColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      button: TextStyle(
        color: globalTextColor,
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      subtitle2: TextStyle(
        color: globalTextColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      overline: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.blue,
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      )),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    helperStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hintStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorMaxLines: null,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    isDense: false,
    contentPadding:
        EdgeInsets.only(top: 12.0, bottom: 12.0, left: 0.0, right: 0.0),
    isCollapsed: false,
    prefixStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    suffixStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    counterStyle: TextStyle(
      color: globalTextColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    filled: false,
    fillColor: Color(0x00000000),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff000000),
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: globalRed,
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff000000),
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff000000),
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff000000),
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff000000),
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
  iconTheme: IconThemeData(
    color: globalTextColor,
    opacity: 1.0,
    size: 24.0,
  ),
  primaryIconTheme: IconThemeData(
    color: globalTextColor,
    opacity: 1.0,
    size: 24.0,
  ),
  accentIconTheme: IconThemeData(
    color: Color(0xff000000),
    opacity: 1.0,
    size: 24.0,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: globalTextColor,
    inactiveTrackColor: Color(0x3d212121),
    disabledActiveTrackColor: Color(0x52000000),
    disabledInactiveTrackColor: Color(0x1f000000),
    activeTickMarkColor: Color(0xff223054),
    inactiveTickMarkColor: Color(0x8a212121),
    disabledActiveTickMarkColor: Color(0x1f9e9e9e),
    disabledInactiveTickMarkColor: Color(0x1f000000),
    thumbColor: Color(0xfff01930),
    disabledThumbColor: Color(0x52000000),
    thumbShape: RoundSliderThumbShape(),
    overlayColor: Color(0x29212121),
    valueIndicatorColor: Color(0xff223053),
    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
    showValueIndicator: ShowValueIndicator.onlyForDiscrete,
    valueIndicatorTextStyle: TextStyle(
      color: Color(0xffcdcdcd),
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: globalTextColor,
    unselectedLabelColor: Color(0xb2ffffff),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xff223154),
    brightness: Brightness.dark,
    deleteIconColor: Color(0xdeffffff),
    disabledColor: Color(0x0cffffff),
    labelPadding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
    labelStyle: TextStyle(
      color: Color(0xdeffffff),
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0, right: 4.0),
    secondaryLabelStyle: TextStyle(
      color: Color(0xff223153),
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    secondarySelectedColor: Color(0xff223053),
    selectedColor: Color(0xff223153),
    shape: StadiumBorder(
        side: BorderSide(
      color: Color(0xff000000),
      width: 0.0,
      style: BorderStyle.none,
    )),
  ),
  dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
    side: BorderSide(
      color: Color(0xff000000),
      width: 0.0,
      style: BorderStyle.none,
    ),
    borderRadius: BorderRadius.all(Radius.circular(0.0)),
  )),
);
