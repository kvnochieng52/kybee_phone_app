import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/regitster/RegisterPage.dart';
import 'package:kybee/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();

  _buidTelephone(context) {
    return Container(
      child: TextFormField(
        controller: _telephoneController,
        keyboardType: TextInputType.number,
        decoration: ThemeHelper()
            .textInputDecoration('Telephone', 'Enter your Telephone No.'),
        validator: (value) => value.isEmpty ? 'Enter Telephone' : null,
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
            return 'Enter Paasword';
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

  _buildLoginButton(context) {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            'Login'.toUpperCase(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: () => _loginUser(context),

        // {
        //   //After successful login we will redirect to profile page. Let's create profile page now
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(builder: (context) => DashboardPage()));
        // },
      ),
    );
  }

  _buildRegisterButton(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      //child: Text('Don\'t have an account? Create'),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: "Don\'t have an account? "),
        TextSpan(
          text: 'Register Now',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ])),
    );
  }

  _loginUser(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Loading().loader(context, "Logging in...Please wait");

    var data = {
      'telephone': _telephoneController.text,
      'password': _passwordController.text
    };
    var res = await CallApi().postData(data, 'login');

    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['data']));
      Navigator.pop(context);
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body['message'].toString()),
        ),
      );
    }

    Navigator.pop(context);
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
                        'LOGIN',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                      Text(
                        'Login into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buidTelephone(context),
                              SizedBox(height: 30.0),
                              _buildPassword(context),
                              SizedBox(height: 15.0),
                              _buildForgetPassword(context),
                              _buildLoginButton(context),
                              _buildRegisterButton(context),
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
