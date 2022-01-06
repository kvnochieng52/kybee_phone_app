//import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:kybee/widgets/bottomNavigation.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:kybee/widgets/headerMain.dart';
// import 'package:kybee/widgets/progress.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Dashboard'),
      drawer: drawer(context),
      //backgroundColor: Color(0xFFF0F0F0)
      //body: _buildBodyptions(context),
    );
  }
}
