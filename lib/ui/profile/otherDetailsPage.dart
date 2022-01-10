import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/ui/profile/contactDetailsPage.dart';

// import 'forgot_password_page.dart';
// import 'profile_page.dart';
// import 'registration_page.dart';
import 'package:kybee/widgets/header_widget.dart';

class OtherDetailsPage extends StatefulWidget {
  // const OtherDetailsPage({Key? key}): super(key:key);

  @override
  _OtherDetailsPageState createState() => _OtherDetailsPageState();
}

class _OtherDetailsPageState extends State<OtherDetailsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _firstname;
  String _gender;
  var gender_items = [
    'Male',
    'Female',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Other Details',
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
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 0.80),
                        ),
                        child: DropdownButtonFormField(
                          value: _gender,
                          isExpanded: true,
                          hint: Text("Select Gender"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select Gender' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          items: gender_items.map((gender) {
                            return DropdownMenuItem(
                              value: gender.toString(),
                              child: Text(gender),
                            );
                          }).toList(),
                        ),
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
                        decoration: ThemeHelper()
                            .textInputDecoration('Email', 'Enter your Email.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Email' : null,
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
                            'Date Of Birth', 'Enter your Date Of Birth.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Date Of Birth' : null,
                        onSaved: (String value) {
                          _firstname = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('#4A1F1F'), // background
                    onPrimary: HexColor('#4A1F1A'),
                    shape: StadiumBorder(), // foreground
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Text(
                      'Submit'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    //After successful login we will redirect to profile page. Let's create profile page now
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()));
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
