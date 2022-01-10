import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/ui/profile/otherDetailsPage.dart';

// import 'forgot_password_page.dart';
// import 'profile_page.dart';
// import 'registration_page.dart';
import 'package:kybee/widgets/header_widget.dart';

class ContactDetailsPage extends StatefulWidget {
  // const ContactDetailsPage({Key? key}): super(key:key);

  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _firstname;
  String _gender;
  var gender_items = ['Parents', 'Spouse', 'Friend', 'Collegue', 'Sibling'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Contact Details',
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
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                child: Text(
                  "Referees 1",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: ThemeHelper().textInputDecoration(
                            "Referee's 1 Full Legal Names",
                            'Enter Referee 1 full Legal Name.'),
                        validator: (value) => value.isEmpty
                            ? 'Enter Referee 1 full Legal Name'
                            : null,
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
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: ThemeHelper().textInputDecoration(
                            'Phone Number', 'Enter your Phone Number.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Phone Number' : null,
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
                          hint: Text("Select Relation",
                              style: TextStyle(fontSize: 16)),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select Relation' : null,
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
                padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                child: Text(
                  "Referees 2",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: ThemeHelper().textInputDecoration(
                            "Referee's 2 Full Legal Names",
                            'Enter Referee 2 full Legal Name.'),
                        validator: (value) => value.isEmpty
                            ? 'Enter Referee 2 full Legal Name'
                            : null,
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
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        decoration: ThemeHelper().textInputDecoration(
                            'Phone Number', 'Enter your Phone Number.'),
                        validator: (value) =>
                            value.isEmpty ? 'Enter Phone Number' : null,
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
                          hint: Text("Select Relation",
                              style: TextStyle(fontSize: 16)),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select Relation' : null,
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
                      'Next'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    //After successful login we will redirect to profile page. Let's create profile page now
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtherDetailsPage()));
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
