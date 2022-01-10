import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/login.dart';

// import 'forgot_password_page.dart';
// import 'profile_page.dart';
// import 'registration_page.dart';
import 'package:kybee/widgets/header_widget.dart';

class BasicDetailsPage extends StatefulWidget {
  // const BasicDetailsPage({Key? key}): super(key:key);

  @override
  _BasicDetailsPageState createState() => _BasicDetailsPageState();
}

class _BasicDetailsPageState extends State<BasicDetailsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _firstname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'My Profile(Basic Details)',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: ThemeHelper().textInputDecoration(
                          'First Name', 'Enter your First Name.'),
                      validator: (value) =>
                          value.isEmpty ? 'Enter Firstname' : null,
                      onSaved: (String value) {
                        _firstname = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: ThemeHelper().textInputDecoration(
                            'Middle Name', 'Enter your Middle Name.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter MiddleName' : null,
                        onSaved: (String value) {
                          _firstname = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: ThemeHelper().textInputDecoration(
                            'Last Name', 'Enter your Last Name.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Last Name' : null,
                        onSaved: (String value) {
                          _firstname = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: ThemeHelper().textInputDecoration(
                            'ID Number', 'Enter your ID Number.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter ID Number' : null,
                        onSaved: (String value) {
                          _firstname = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
