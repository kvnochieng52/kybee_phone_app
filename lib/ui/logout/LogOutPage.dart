import 'package:flutter/material.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:kybee/widgets/headerMain.dart';
import 'package:kybee/widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogOutState();
  }
}

class _LogOutState extends State<LogOutPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _logoutUser() async {
    Loading().loader(context, "Updating Profile...Please wait");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Widget _buildLogoutButton(context) {
    //final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  "You are about log out to continue please Tap on  Logout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
              ),
              Center(
                  child: ElevatedButton(
                //  color: Colors.red,
                child: Text(
                  "LOGOUT",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _logoutUser(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: 'Logout'),
      drawer: drawer(context),
      backgroundColor: Color(0xFFF0F0F0),
      body: _buildLogoutButton(context),
    );
  }
}
