import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:kybee/ui/splashScreen.dart';

void main() {
  runApp(LoginUiApp());
}

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#4A1F1F');
  Color _accentColor = HexColor('#4A1F1F');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kybee Loans',
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
    );
  }
}
