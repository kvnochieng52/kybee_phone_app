import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:kybee/ui/splashScreen.dart';

void main() {
  runApp(LoginUiApp());
}

//https://pub.dev/packages/flutter_html/example

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#4A1F1F');
  Color _accentColor = HexColor('#4A1F1F');

  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8');

  // Our Logo Blue Color
  //Color _primaryColor= HexColor('#651BD2');
  //Color _accentColor= HexColor('#320181');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
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
