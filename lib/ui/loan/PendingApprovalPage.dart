import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/ui/profile/contactDetailsPage.dart';

// import 'forgot_password_page.dart';
// import 'profile_page.dart';
// import 'registration_page.dart';
import 'package:kybee/widgets/header_widget.dart';

class PendingApprovalPage extends StatefulWidget {
  // const PendingApprovalPage({Key? key}): super(key:key);

  @override
  _PendingApprovalPageState createState() => _PendingApprovalPageState();
}

class _PendingApprovalPageState extends State<PendingApprovalPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _initDataFetched = false;
  String _message;

  void initState() {
    super.initState();
    _getInitData();
  }

  _getInitData() async {
    var data = {
      'code': 'PENDING_REVIEW_MSG',
    };
    var res = await CallApi().postData(data, 'app_settings/get_settings');
    var body = json.decode(res.body);

    if (body['success']) {
      setState(() {
        _initDataFetched = true;
        _message = body['data']['setting_value'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Loan Pending Approval',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "LOAN PENDING APPROVAL!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor('#4A1F1F'),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _initDataFetched ? _message : "Loading...",
                      style: TextStyle(
                        fontSize: 16.9,
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.info_outline)),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: HexColor('#4A1F1F'), // background
                onPrimary: HexColor('#4A1F1A'),
                shape: StadiumBorder(), // foreground
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Text(
                  'Okay'.toUpperCase(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              onPressed: () {
                //After successful login we will redirect to profile page. Let's create profile page now
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashboardPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
