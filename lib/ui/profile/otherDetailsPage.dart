import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherDetailsPage extends StatefulWidget {
  @override
  _OtherDetailsPageState createState() => _OtherDetailsPageState();
}

class _OtherDetailsPageState extends State<OtherDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _companyAddressController = TextEditingController();
  final _userAddressController = TextEditingController();

  List _counties = [];
  List _maritalStatuses = [];
  List _educationLevels = [];
  List _employmentStatuses = [];
  List _salaryRanges = [];
  int _companyCounty;
  int _userCounty;
  int _maritalStatus;
  int _educationLevel;
  int _employmentStatus;
  int _salaryRange;
  bool _initDataFetched = false;

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
        _counties = body['counties'];
        _maritalStatuses = body['marital_statuses'];
        _educationLevels = body['education_levels'];
        _employmentStatuses = body['employment_statuses'];
        _salaryRanges = body['salary_ranges'];
      });

      if (body['success']) {
        setState(() {
          _companyAddressController.text = body['data']['company_address'];
          _userAddressController.text = body['data']['home_address'];
          _maritalStatus = body['data']['marital_status_id'];
          _educationLevel = body['data']['education_level_id'];
          _employmentStatus = body['data']['employment_status_id'];
          _salaryRange = body['data']['salary_range'];
          _companyCounty = body['data']['company_county_id'];
          _userCounty = body['data']['county_id'];
        });
      }
    }
    setState(() {
      _initDataFetched = true;
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
      'company_county': _companyCounty,
      'company_address': _companyAddressController.text,
      'user_county': _userCounty,
      'user_address': _userAddressController.text,
      'marital_status': _maritalStatus,
      'education_level': _educationLevel,
      'employment_status': _employmentStatus,
      'salary_range': _salaryRange,
    };

    var res = await CallApi().postData(data, 'profile/update');
    var body = json.decode(res.body);
    if (body['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Details Successfully Saved"),
        ),
      );
      Navigator.pop(context);
      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                          value: _maritalStatus,
                          isExpanded: true,
                          hint: Text("Select Marital Status"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select Marital Status' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _maritalStatus = value;
                            });
                          },
                          items: _maritalStatuses.map((status) {
                            return DropdownMenuItem(
                              value: status['id'],
                              child: Text(status['marital_status_name']),
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
                          value: _educationLevel,
                          isExpanded: true,
                          hint: Text("Select Education Level"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Education Level' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _educationLevel = value;
                            });
                          },
                          items: _educationLevels.map((level) {
                            return DropdownMenuItem(
                              value: level['id'],
                              child: Text(level['education_level_name']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                          value: _employmentStatus,
                          isExpanded: true,
                          hint: Text("Employment Status"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Employment Status' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _employmentStatus = value;
                            });
                          },
                          items: _employmentStatuses.map((status) {
                            return DropdownMenuItem(
                              value: status['id'],
                              child: Text(status['employment_status_name']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                          value: _salaryRange,
                          isExpanded: true,
                          hint: Text("Salary Range"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Salary range' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _salaryRange = value;
                            });
                          },
                          items: _salaryRanges.map((range) {
                            return DropdownMenuItem(
                              value: range['id'],
                              child: Text(range['salary_range']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Company Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          value: _companyCounty,
                          isExpanded: true,
                          hint: Text("Select County"),
                          style: TextStyle(color: Colors.green),
                          // validator: (value) =>
                          //     value == null ? 'Select Relation' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _companyCounty = value;
                            });
                          },
                          items: _counties.map((county) {
                            return DropdownMenuItem(
                              value: county['id'],
                              child: Text(county['county_name']),
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
                        controller: _companyAddressController,
                        decoration: ThemeHelper().textInputDecoration(
                            'Company Address', 'Enter your Company Address.'),
                        // validator: (value) {
                        //   if (value.isEmpty) {
                        //     return 'Please enter Company Address';
                        //   }
                        //   return null;
                        // },
                        onSaved: (String value) {
                          _companyAddressController.text = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Your Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          value: _userCounty,
                          isExpanded: true,
                          hint: Text("Select County"),
                          style: TextStyle(color: Colors.green),
                          validator: (value) =>
                              value == null ? 'Select County' : null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _userCounty = value;
                            });
                          },
                          items: _counties.map((county) {
                            return DropdownMenuItem(
                              value: county['id'],
                              child: Text(county['county_name']),
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
                        controller: _userAddressController,
                        decoration: ThemeHelper().textInputDecoration(
                            'Your Address', 'Enter  your Address.'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Address';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _userAddressController.text = value;
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
                      _initDataFetched
                          ? 'Submit'.toUpperCase()
                          : "Loading...Please Wait",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () => _initDataFetched
                      ? _saveProfileDetails(context, 'other_details')
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
