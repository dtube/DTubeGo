import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

Color globalBlue = Color.fromRGBO(34, 49, 84, 1);
Color globalRed = Color.fromRGBO(240, 26, 48, 1);
Color globalAlmostWhite = Color.fromRGBO(230, 230, 230, 1);
Color globalAlmostBlack = Color.fromRGBO(29, 35, 51, 1);
Color globalBGColor = Color.fromRGBO(29, 35, 51, 1);
Color globalBGColorHalfOpacity = Color.fromRGBO(29, 35, 51, 0.5);
Color globalBGColorNoOpacity = Color.fromRGBO(29, 35, 51, 0);

List<Color> globalBlueShades = [
  Color(0xff58bfd3),
  Color(0xff00899c),
  Color(0xff005c83),
  Color(0xff223154)
];

List<Color> globalRedShades = [
  Colors.red[300]!,
  Colors.red[600]!,
  Colors.red[800]!,
  Colors.red[900]!,
];

Color globalTextColor = globalAlmostWhite;
double globalIconSizeSmall = 15;
double globalIconSizeMedium = 20;
double globalIconSizeBig = 30;

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
  primaryColorLight: Color(0xff9e9e9e),
  primaryColorDark: Color(0xff000000),
  canvasColor: globalBGColor,
  scaffoldBackgroundColor: globalBGColor,

  cardColor: Color(0xff424242),
  dividerColor: Color(0x1fffffff),
  highlightColor: Color(0x40cccccc),
  splashColor: Color(0x40cccccc),
  selectedRowColor: Color(0xfff5f5f5),
  unselectedWidgetColor: globalTextColor,
  disabledColor: Color(0x4dffffff),
  toggleableActiveColor: Color(0xffef192f),
  secondaryHeaderColor: Color(0xff616161),
  backgroundColor: Color(0xff616161),
  dialogBackgroundColor: Color(0xff424242),
  indicatorColor: Color(0xff64ffda),
  hintColor: Color(0x80ffffff),
  errorColor: Color(0xffd32f2f),
  // appBarTheme: AppBarTheme(backgroundColor: globalBGColor, elevation: 0),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
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
      primary: globalBlue,
      secondary: Color(0xff64ffda),
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
    headline1: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 25,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
    ),
    headline2: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 23,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    ),
    headline3: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 21,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
    ),
    headline4: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 19,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    ),
    headline5: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    ),
    headline6: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
    ),
    subtitle1: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 15,
      fontWeight: FontWeight.w200,
      fontStyle: FontStyle.normal,
    ),
    bodyText1: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    bodyText2: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    caption: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    button: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    subtitle2: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    overline: GoogleFonts.workSans(
      decoration: TextDecoration.underline,
      color: globalTextColor,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    helperStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    hintStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    errorMaxLines: null,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    isDense: false,
    contentPadding:
        EdgeInsets.only(top: 12.0, bottom: 12.0, left: 0.0, right: 0.0),
    isCollapsed: false,
    prefixStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    suffixStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    counterStyle: GoogleFonts.workSans(
      color: globalTextColor,
      fontSize: 16,
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
    valueIndicatorTextStyle: GoogleFonts.workSans(
      color: Color(0xffcdcdcd),
      fontSize: 14,
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
    labelStyle: GoogleFonts.workSans(
      color: Color(0xdeffffff),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    ),
    padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0, right: 4.0),
    secondaryLabelStyle: GoogleFonts.workSans(
      color: Color(0xff223153),
      fontSize: 14,
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
