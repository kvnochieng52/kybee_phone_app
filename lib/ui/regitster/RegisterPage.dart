import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/ui/regitster/VerifyPhone.dart';
import 'package:kybee/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage({Key? key}): super(key:key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double _headerHeight = 250;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();

  _buildTelephone(context) {
    return Container(
      child: TextFormField(
        controller: _telephoneController,
        keyboardType: TextInputType.number,
        decoration: ThemeHelper()
            .textInputDecoration('Telephone', 'Enter your Telephone No.'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter Telephone';
          } else if (value.length < 10) {
            return 'Telephone should not be less than 10 characters';
          }

          return null;
        },
        onSaved: (String value) {
          _telephoneController.text = value;
        },
      ),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
    );
  }

  _buildPassword(context) {
    return Container(
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: ThemeHelper()
            .textInputDecoration('Password', 'Enter your password'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter Password';
          } else if (value.length < 4) {
            return 'Password should not be less than 4 characters';
          }

          return null;
        },
        onSaved: (String value) {
          _passwordController.text = value;
        },
      ),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
    );
  }

  _buildForgetPassword(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        },
        child: Text(
          "Forgot your password?",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  _buildRegisterButton(context) {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            'Register'.toUpperCase(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: () => _registerUser(context),
      ),
    );
  }

  _registerUser(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Loading().loader(context, "Logging in...Please wait");
    var data = {
      'telephone': _telephoneController.text,
      'password': _passwordController.text
    };
    var res = await CallApi().postData(data, 'register');

    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['data']));
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 8000),
          content: Text(body['message']),
          action: SnackBarAction(
            label: 'X',
            textColor: Colors.orange,
            onPressed: () {},
          ),
        ),
      );

      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyPhonePage(
              phone: _telephoneController.text,
            ),
          ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 8000),
          content: Text(body['message'].toString()),
          action: SnackBarAction(
            label: 'X',
            textColor: Colors.orange,
            onPressed: () {},
          ),
        ),
      );
    }
    Navigator.pop(context);
  }

  _buildLoginButton(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      //child: Text('Don\'t have an account? Create'),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: "Already have an account? "),
        TextSpan(
          text: 'Login Now',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'REGISTER',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                      Text(
                        'Register your free account to get started',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTelephone(context),
                              SizedBox(height: 30.0),
                              _buildPassword(context),
                              SizedBox(height: 15.0),
                              _buildForgetPassword(context),
                              _buildRegisterButton(context),
                              _buildLoginButton(context)
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
