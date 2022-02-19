import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:intl/intl.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/profile/contactDetailsPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
//import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

class BasicDetailsPage extends StatefulWidget {
  @override
  _BasicDetailsPageState createState() => _BasicDetailsPageState();
}

class _BasicDetailsPageState extends State<BasicDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController _dobController = TextEditingController();
  bool _initDataFetched = false;
  List _genders = [];
  String _smsMessagesSender;
  int _gender;

  void initState() {
    super.initState();
    _getInitData();
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.sms.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.sms].request();
      return permissionStatus[Permission.sms];
    } else {
      return permission;
    }
  }

  _getInitData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'user_id': user['id'],
    };
    var res = await CallApi().postData(data, 'profile/details');
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        _genders = body['genders'];
      });

      if (body['success']) {
        setState(() {
          _firstNameController.text = body['data']['first_name'];
          _middleNameController.text = body['data']['middle_name'];
          _lastNameController.text = body['data']['last_name'];
          _idNumberController.text = body['data']['id_number'];
          _emailController.text = body['data']['email'];
          _dobController.text = body['data']['date_of_birth'];
          _gender = body['data']['gender_id'];
          _smsMessagesSender = body['sms_messages_sender'];
        });
      }
    }

    setState(() {
      _initDataFetched = true;
    });

    if (_initDataFetched) {
      final PermissionStatus permissionStatus = await _getPermission();

      if (permissionStatus == PermissionStatus.granted) {
        SmsQuery query = new SmsQuery();
        List smsObject = [];

        List<SmsMessage> messages = await query.querySms(
          address: _smsMessagesSender,
          count: 50,
        );
        // debugPrint("Total Messages : " + messages.length.toString());

        messages.forEach((element) {
          smsObject.add({
            "address": element.address,
            "message": element.body,
            "date": element.dateSent.toString(),
          });
        });

        var data = {
          'user_id': user['id'],
          'sms': smsObject,
          'section': 'sms',
        };
        var res = await CallApi().postData(data, 'profile/store_sms');
      } else {
        // SharedPreferences localStorage = await SharedPreferences.getInstance();
        // localStorage.remove('user');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return DashboardPage();
          }),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Please Grant KYBEE LOANS Permission to Access SMS from the App Menu settings to continue"),
          ),
        );
      }
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dobController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  _saveProfileDetails(context, section) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Loading().loader(context, "Updating...Please wait");

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'user_id': user['id'],
      'section': section,
      'first_name': _firstNameController.text,
      'middle_name': _middleNameController.text,
      'last_name': _lastNameController.text,
      'id_number': _idNumberController.text,
      'email': _emailController.text,
      'dob': _dobController.text,
      'gender': _gender,
    };

    var res = await CallApi().postData(data, 'profile/update');
    var body = json.decode(res.body);
    if (body['success']) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(body['message']),
      //   ),
      // );
      Navigator.pop(context);
      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetailsPage(),
          ));
    }
  }

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
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              _initDataFetched
                  ? Text("")
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            child: CircularProgressIndicator(),
                            height: 25.0,
                            width: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Loading...Please Wait",
                              style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: ThemeHelper().textInputDecoration(
                          'First Name', 'Enter your First Name.'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter First Name';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _firstNameController.text = value;
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
                        controller: _middleNameController,
                        decoration: ThemeHelper().textInputDecoration(
                            'Middle Name', 'Enter your Middle Name.'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your middle Name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _middleNameController.text = value;
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
                        controller: _lastNameController,
                        decoration: ThemeHelper().textInputDecoration(
                            'Last Name', 'Enter your Last Name.'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Last Name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _lastNameController.text = value;
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
                        controller: _idNumberController,
                        keyboardType: TextInputType.number,
                        decoration: ThemeHelper().textInputDecoration(
                            'ID Number', 'Enter your ID Number.'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter ID Number';
                          } else if (value.length < 6) {
                            return 'ID Number  should not be less than 6 characters';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _idNumberController.text = value;
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
                          items: _genders.map((gender) {
                            return DropdownMenuItem(
                              value: gender['id'],
                              child: Text(gender['gender_name']),
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
                        controller: _emailController,
                        decoration: ThemeHelper()
                            .textInputDecoration('Email', 'Enter your Email.'),
                        validator: (String value) {
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          return !emailValid ? "Enter a Valid Email" : null;
                        },
                        onSaved: (String value) {
                          _emailController.text = value;
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
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _dobController,
                            keyboardType: TextInputType.datetime,
                            decoration: ThemeHelper()
                                .textInputDecoration('Date of Birth'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Date of Birth';
                              }
                              return null;
                            },
                          ),
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
                      _initDataFetched
                          ? 'Next'.toUpperCase()
                          : 'Loading...Please wait',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () => _initDataFetched
                      ? _saveProfileDetails(context, 'basic')
                      : null,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
