import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsPage extends StatefulWidget {
  // const ContactUsPage({Key? key}): super(key:key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _initDataFetched = false;
  String _phone = 'Loading...';
  String _watsapp = 'Loading...';
  String _email = 'Loading...';

  void initState() {
    super.initState();
    _getInitData();
  }

  _getInitData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'user_id': user['id'],
    };
    var res =
        await CallApi().postData(data, 'app_settings/get_contact_details');
    var body = json.decode(res.body);

    if (body['success']) {
      setState(() {
        _initDataFetched = true;
        _phone = body['phone'];
        _watsapp = body['watsapp'];
        _email = body['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
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
                  title: Text(
                    "Phone",
                    style: TextStyle(
                      fontSize: 16.9,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _phone,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#4A1F1F'),
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.phone)),
                  trailing: Column(
                    //spacing: 12, // space between two icons
                    children: <Widget>[
                      Text(
                        "Call Us",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: HexColor('#4A1F1F'),
                        ),
                      ),

                      //Icon(Icons.chevron_right), // icon-2
                    ],
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
                  title: Text(
                    "Whatsapp",
                    style: TextStyle(
                      fontSize: 16.9,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _watsapp,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#4A1F1F'),
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.chat)),
                  trailing: Column(
                    //spacing: 12, // space between two icons
                    children: <Widget>[
                      Text(
                        "Chat with Us",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: HexColor('#4A1F1F'),
                        ),
                      ),

                      //Icon(Icons.chevron_right), // icon-2
                    ],
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
                  title: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16.9,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _email,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#4A1F1F'),
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.email_outlined)),
                  // trailing: Column(
                  //   //spacing: 12, // space between two icons
                  //   children: <Widget>[
                  //     Text(
                  //       "Send Email",
                  //       style: TextStyle(
                  //         fontSize: 15.0,
                  //         color: HexColor('#4A1F1F'),
                  //       ),
                  //     ),

                  //     //Icon(Icons.chevron_right), // icon-2
                  //   ],
                  // ),
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
