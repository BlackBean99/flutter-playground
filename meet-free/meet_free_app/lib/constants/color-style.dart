import 'package:flutter/material.dart';

Size kSize = const Size(360.0, 690.0);

Size textFullFieldSize = const Size(328.0, 56.0);

const primaryBlack = Color(0xFF1F2128);
const secondaryBlue = Color(0xFF003483);
const teritaryBlue = Color(0xFF008CF7);
const pointBlue = Color(0xFF00F7FE);

const highlightTextFieldStrokeColor = Color(0xFF979797);
const defaultTextFieldStrokeColor = Color(0xFFDBDBDB);

const backgroundPrimaryWhite = Color(0xFFf9f9f9);

const kColorYoutube = '0xFFe53222';
const kColorFacebook = '0xFF4967ad';
const kColorKakao = '0xFFf3d749';
const kColorInstagram = '0xFFc92b52';
const kColorNaver = '0xFF5ac351';
const kColorGoogle = '0xFF5084ed';
const kColorDaum = '0xFF448eee';
const kColorDiscord = '0xFF667ac2';
const kColorNetflix = '0xFFa12423';

const kDuration = Duration(milliseconds: 500);

const double kRadiusValue10 = 10.0;
const double kRadiusValue15 = 15.0;
const double kRadiusValue20 = 20.0;
const double kRadiusValue40 = 40.0;

const kAddPageTitleTextStyle = TextStyle(fontSize: 35.0);
const kMemoTitleTextStyle =
    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
const kMemoIDPWTextStyle = TextStyle(fontSize: 20.0);
const kMemoTextTextStyle = TextStyle(fontSize: 15.0);
const kButtonTextStyle = TextStyle(fontSize: 25);

const defaultSymetricMargin = EdgeInsets.symmetric(horizontal: 16.0);

const spacing1 = SizedBox(height: 8.0);
const spacing2 = SizedBox(height: 16.0);
const spacing3 = SizedBox(height: 24.0);
const spacing4 = SizedBox(height: 32.0);
const spacing5 = SizedBox(height: 40.0);
const spacing6 = SizedBox(height: 48.0);

// const kTextFieldDecoration = InputDecoration(
//   contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(kRadiusValue10)),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: kColorGreen, width: 1.0),
//     borderRadius: BorderRadius.all(Radius.circular(kRadiusValue10)),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: kColorGreen, width: 2.0),
//     borderRadius: BorderRadius.all(Radius.circular(kRadiusValue10)),
//   ),
//   labelText: '',
//   labelStyle: TextStyle(fontSize: 18.0, color: Colors.white54),
//   filled: false,
// );

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(kRadiusValue10)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: defaultTextFieldStrokeColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(kRadiusValue10)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: highlightTextFieldStrokeColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(kRadiusValue10)),
  ),
  labelText: 'default-text',
  labelStyle: TextStyle(fontSize: 12.0, color: Colors.white54),
  filled: false,
  // input button size


);
