import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/widgets/header_widget.dart';

class VerifyPhonePage extends StatefulWidget {
  final String phone;

  VerifyPhonePage({Key key, @required this.phone}) : super(key: key);

  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  double _headerHeight = 250;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _telephoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  void initState() {
    super.initState();
    _telephoneController.text = widget.phone;
  }

  _buidTelephone(context) {
    return Container(
      child: TextFormField(
        controller: _telephoneController,
        keyboardType: TextInputType.number,
        readOnly: true,
        decoration: ThemeHelper()
            .textInputDecoration('Telephone', 'Enter your Telephone No.'),
        validator: (value) => value.isEmpty ? 'Enter Telephone' : null,
        //initialValue: "hello",
        onSaved: (String value) {
          _telephoneController.text = value;
        },
      ),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
    );
  }

  _buidVerificationCode(context) {
    return Container(
      child: TextFormField(
        controller: _verificationCodeController,
        keyboardType: TextInputType.number,
        decoration: ThemeHelper().textInputDecoration(
            'Enter Verification Code', 'Enter Verification Code.'),
        validator: (value) => value.isEmpty ? 'Enter Verification Code' : null,
        onSaved: (String value) {
          _verificationCodeController.text = value;
        },
      ),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
    );
  }

  _buildVerifyButton(context) {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            'Verify'.toUpperCase(),
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

  _buildoginButton(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      //child: Text('Don\'t have an account? Create'),
      child: Text.rich(TextSpan(children: [
        TextSpan(
          text: 'Login',
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

  _resendVerification(context) async {
    Loading().loader(context, "Sending...Please wait");

    var data = {'telephone': _telephoneController.text};
    var res = await CallApi().postData(data, 'resend_verification');

    var body = json.decode(res.body);

    if (body['success']) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body['message'].toString()),
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
          content: Text(body['message'].toString()),
        ),
      );
    }

    Navigator.pop(context);
  }

  _buidResendVerificationCode(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      //child: Text('Don\'t have an account? Create'),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text.rich(TextSpan(children: [
          TextSpan(
            text: 'Resend Verification Code',
            recognizer: TapGestureRecognizer()
              ..onTap = () => _resendVerification(context),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
        ])),
      ),
    );
  }

  _loginUser(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Loading().loader(context, "Verifying...Please wait");

    var data = {
      'telephone': _telephoneController.text,
      'verification_code': _verificationCodeController.text
    };
    var res = await CallApi().postData(data, 'verify');

    var body = json.decode(res.body);

    if (body['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body['message'].toString()),
        ),
      );
      Navigator.pop(context);
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                        'VERIFY TELEPHONE.',
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                      Text(
                        'Verify your telephone no.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buidTelephone(context),
                              _buidResendVerificationCode(context),
                              SizedBox(height: 30.0),
                              _buidVerificationCode(context),
                              SizedBox(height: 15.0),
                              _buildVerifyButton(context),
                              _buildoginButton(context),
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
