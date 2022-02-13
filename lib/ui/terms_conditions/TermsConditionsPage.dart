import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/ui/login.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/ui/progress.dart';

class TermsandConditionsPage extends StatefulWidget {
  // const TermsandConditionsPage({Key? key}): super(key:key);

  //test

  @override
  _TermsandConditionsPageState createState() => _TermsandConditionsPageState();
}

class _TermsandConditionsPageState extends State<TermsandConditionsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _terms;
  var _termsFetched = false;
  bool _accepted_terms = false;

  void initState() {
    super.initState();
    _getInitData();
  }

  _getInitData() async {
    var res = await CallApi().getData('terms_conditions_fetch');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _terms = body['terms']['setting_value'];
          _termsFetched = true;
        });
      }
    }
  }

  _checkTerms(context) {
    if (_accepted_terms == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      showAlertDialog(context);
      _accepted_terms = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: _termsFetched
          ? ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Html(
                                data: """$_terms""",
                                //padding: EdgeInsets.all(8.0),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: Text("I Accept Terms & Conditions"),
                  value: _accepted_terms,
                  onChanged: (bool value) {
                    setState(() {
                      _accepted_terms = value;
                    });
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: HexColor('#4A1F1F'), // background
                      onPrimary: HexColor('#4A1F1A'),
                      shape: StadiumBorder(), // foreground
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text(
                        'Comtinue',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () => _checkTerms(context),
                  ),
                ),
              ],
            )
          : circularProgress(),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OKAY"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Accept terms & conditions"),
      content: Text("Please Accept the Terms & Conditions to continue"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
