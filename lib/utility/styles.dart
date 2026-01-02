import 'package:evahan/size_config.dart';
import 'package:flutter/material.dart';

Color kblack = Color(0xff000000);
Color kwhite = Color(0xffFFFFFF);
Color klightgrey = Color.fromARGB(255, 162, 162, 162);
Color kyellow = Color(0xffFFD700);
Color kgreen = Color(0xff48B33B);
Color kgreen2 = Color(0xff81E04B);
Color klightgreen = Color(0xff9CBA01);
Color kblue = Color(0xff50C8FF);
Color kdarkblue = Color(0xff1556BE);
Color kpurple = Color(0xffBE158E);
Color kgrey = Color(0xffF3F3F3);
Color kred = Color(0xffAD0606);
Color kmenu = Color(0xff554040);
Color kblackgrey = Color(0xffEAEAEA);
Color bg = const Color.fromARGB(255, 233, 233, 233);

//Font Sizes

double get fs4  => SizeConfig.sp(4);
double get fs5  => SizeConfig.sp(5);
double get fs6  => SizeConfig.sp(6);
double get fs7  => SizeConfig.sp(7);
double get fs8  => SizeConfig.sp(8);
double get fs10 => SizeConfig.sp(10);
double get fs12 => SizeConfig.sp(12);
double get fs14 => SizeConfig.sp(14);
double get fs15 => SizeConfig.sp(15);
double get fs16 => SizeConfig.sp(16);
double get fs18 => SizeConfig.sp(18);
double get fs20 => SizeConfig.sp(20);
double get fs22 => SizeConfig.sp(22);
double get fs24 => SizeConfig.sp(24);
double get fs25 => SizeConfig.sp(25);

//custom text style

customtext(
  double size,
  Color color,
  [ FontWeight weight = FontWeight.normal ]
) => TextStyle(
  color: color,
  fontSize: size,
  fontWeight: weight
);

//Text Styles

TextStyle headlineLarge22 = TextStyle(
  color: kblack,
  fontSize: fs22,
  fontWeight: FontWeight.bold
);

TextStyle headlineBold16 = TextStyle(
  color: kblack,
  fontSize: fs16,
  fontWeight: FontWeight.bold
);

TextStyle textfield8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.w500
);

TextStyle textfield10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.w500
);

TextStyle textfield12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.w500,
);

TextStyle buttonblacktext = TextStyle(
  color: kblack,
  fontSize: fs14,
  fontWeight: FontWeight.w500
);

TextStyle textbold10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.bold
);

TextStyle textmedium6 = TextStyle(
  color: kblack,
  fontSize: fs6,
  fontWeight: FontWeight.w500
);

TextStyle textmedium8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.w500
);

TextStyle textmedium10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.w500
);

TextStyle textmedium12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.w500
);

TextStyle textmedium14 = TextStyle(
  color: kblack,
  fontSize: fs14,
  fontWeight: FontWeight.w500
);

TextStyle textmedium16 = TextStyle(
  color: kblack,
  fontSize: fs16,
  fontWeight: FontWeight.w500
);

TextStyle text6 = TextStyle(
  color: kblack,
  fontSize: fs6,
  fontWeight: FontWeight.normal
);

TextStyle text7 = TextStyle(
  color: kblack,
  fontSize: fs7,
  fontWeight: FontWeight.normal
);

TextStyle text8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.normal
);

TextStyle text10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.normal
);

TextStyle text12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.normal
);

TextStyle textsemibold16 = TextStyle(
  color: kblack,
  fontSize: fs16,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold14 = TextStyle(
  color: kblack,
  fontSize: fs14,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold10 = TextStyle(
  color: kblack,
  fontSize: fs10,
  fontWeight: FontWeight.w600,
);

TextStyle textsemibold8 = TextStyle(
  color: kblack,
  fontSize: fs8,
  fontWeight: FontWeight.w600,
);

TextStyle textbold12 = TextStyle(
  color: kblack,
  fontSize: fs12,
  fontWeight: FontWeight.bold
);