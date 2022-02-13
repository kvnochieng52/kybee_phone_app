import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/ui/profile/contactDetailsPage.dart';
import 'package:kybee/widgets/drawer.dart';

// import 'forgot_password_page.dart';
// import 'profile_page.dart';
// import 'registration_page.dart';
import 'package:kybee/widgets/header_widget.dart';

class MessagesPage extends StatefulWidget {
  // const MessagesPage({Key? key}): super(key:key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),

      drawer: drawer(context),
      body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.chat, color: HexColor('#4A1F1F')),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "8th-January-2022",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor('#4A1F1F'),
                            //fontSize: 18.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.chat, color: HexColor('#4A1F1F')),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "6th-January-2022",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor('#4A1F1F'),
                            //fontSize: 18.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.chat, color: HexColor('#4A1F1F')),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "1th-January-2022",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor('#4A1F1F'),
                            //fontSize: 18.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.chat, color: HexColor('#4A1F1F')),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "21st-December-2021",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor('#4A1F1F'),
                            //fontSize: 18.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.chat, color: HexColor('#4A1F1F')),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "15th-December-2021",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor('#4A1F1F'),
                            //fontSize: 18.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
