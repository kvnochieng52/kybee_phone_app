import 'dart:convert';

import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/profile/otherDetailsPage.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contacts_service/contacts_service.dart' as contactService;

class ContactDetailsPage extends StatefulWidget {
  @override
  _ContactDetailsPageState createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _refOneNameController = TextEditingController();
  final _refOneMobileController = TextEditingController();

  final _refTwoNameController = TextEditingController();
  final _refTwoMobileController = TextEditingController();

  final ContactPicker _contactPicker = new ContactPicker();

  List _relationTypes = [];

  int _relationOne;
  int _relationTwo;

  bool _initDataFetched = false;
  List contactsList = [];

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
    var res = await CallApi().postData(data, 'profile/details');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      setState(() {
        _relationTypes = body['relation_types'];
      });

      if (body['success']) {
        if (body['user_referees'].length > 0) {
          setState(() {
            _refOneNameController.text =
                body['user_referees'][0]['referee_name'];
            _refOneMobileController.text =
                body['user_referees'][0]['telephone'];
            _relationOne = body['user_referees'][0]['relationship_type_id'];

            _refTwoNameController.text =
                body['user_referees'][1]['referee_name'];
            _refTwoMobileController.text =
                body['user_referees'][1]['telephone'];
            _relationTwo = body['user_referees'][1]['relationship_type_id'];
          });
        }
      }
    }

    setState(() {
      _initDataFetched = true;
    });

    if (_initDataFetched) {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        Iterable<contactService.Contact> contacts =
            await contactService.ContactsService.getContacts();

        setState(() {
          contactsList = contacts.toList();
        });

        List contactsObject = [];

        contactsList.map((element) {
          if (element.phones.length > 0) {
            contactsObject.add({
              "name": element.displayName.toString(),
              "phone": element.phones.first.value.toString(),
            });
          }
        }).toList();

        var data = {
          'user_id': user['id'],
          'contacts': contactsObject,
          'section': 'phone_book',
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
                "Please Grant KYBEE LOANS Permission to Access Contacts from the App Menu settings"),
          ),
        );
      }
    }
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
      'ref_one_name': _refOneNameController.text,
      'ref_one_mobile_no': _refOneMobileController.text,
      'ref_one_relation': _relationOne,
      'ref_two_name': _refTwoNameController.text,
      'ref_two_mobile_no': _refTwoMobileController.text,
      'ref_two_relation': _relationTwo,
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
            builder: (context) => OtherDetailsPage(),
          ));
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      return permission;
    }
  }

  _selectRefOneContact(context) async {
    Loading().loader(context, "Loading contacts...Please wait");
    // final PermissionStatus permissionStatus = await _getPermission();
    // if (permissionStatus == PermissionStatus.granted) {
    //   Contact contact = await _contactPicker.selectContact();

    //   if (contact != null) {
    //     setState(() {
    //       _refOneMobileController.text = contact.phoneNumber.number
    //           .toString()
    //           .replaceAll(new RegExp(r"\s+"), "");
    //     });
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("Please Grant KYBEE LOANS Permission to read contacts"),
    //     ),
    //   );
    // }

    Navigator.pop(context);
  }

  _selectRefTwoContact(context) async {
    Loading().loader(context, "Loading contacts...Please wait");
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Contact contact = await _contactPicker.selectContact();

      if (contact != null) {
        setState(() {
          _refTwoMobileController.text = contact.phoneNumber.number
              .toString()
              .replaceAll(new RegExp(r"\s+"), "");
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Grant KYBEE LOANS Permission to read contacts"),
        ),
      );
    }
    Navigator.pop(context);
  }

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
                        controller: _refOneNameController,
                        decoration: ThemeHelper().textInputDecoration(
                            "Referee's 1 Full Legal Names",
                            'Enter Referee 1 full Legal Name.'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter Referee 1 full Legal Name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _refOneNameController.text = value;
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
                      child: GestureDetector(
                        onTap: () => _selectRefOneContact(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _refOneMobileController,
                            keyboardType: TextInputType.datetime,
                            decoration: ThemeHelper()
                                .textInputDecoration("Referee's 1 Mobile No."),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter Referee's 1 Mobile No.";
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
                          value: _relationOne,
                          isExpanded: true,
                          hint: Text("Select Relation"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select Relation' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _relationOne = value;
                            });
                          },
                          items: _relationTypes.map((relation) {
                            return DropdownMenuItem(
                              value: relation['id'],
                              child: Text(relation['relationship_type_name']),
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
                        controller: _refTwoNameController,
                        decoration: ThemeHelper().textInputDecoration(
                            "Referee's 2 Full Legal Names",
                            'Enter Referee 2 full Legal Name.'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Referee's 1 Mobile No.";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _refTwoNameController.text = value;
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
                      child: GestureDetector(
                        onTap: () => _selectRefTwoContact(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _refTwoMobileController,
                            keyboardType: TextInputType.datetime,
                            decoration: ThemeHelper()
                                .textInputDecoration("Referee's 2 Mobile No."),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter Referee's 2 Mobile No.";
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
                          value: _relationTwo,
                          isExpanded: true,
                          hint: Text("Select Relation"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select Relation' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _relationTwo = value;
                            });
                          },
                          items: _relationTypes.map((relation) {
                            return DropdownMenuItem(
                              value: relation['id'],
                              child: Text(relation['relationship_type_name']),
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
                      _initDataFetched
                          ? 'Next'.toUpperCase()
                          : 'Loading...Please wait',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () => _initDataFetched
                      ? _saveProfileDetails(context, 'contacts')
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
