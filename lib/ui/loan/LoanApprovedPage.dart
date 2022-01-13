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

class LoanApprovedPage extends StatefulWidget {
  // const LoanApprovedPage({Key? key}): super(key:key);

  @override
  _LoanApprovedPageState createState() => _LoanApprovedPageState();
}

class _LoanApprovedPageState extends State<LoanApprovedPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Loan Approved',
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
                    "LOAN APPROVED!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor('#4A1F1F'),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "Your Loan has been approved and disbursed to your M-pesa number",
                      style: TextStyle(
                        fontSize: 16.9,
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.check)),
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
