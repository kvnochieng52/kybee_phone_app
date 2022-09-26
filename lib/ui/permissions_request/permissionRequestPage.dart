import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/ui/login.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestPage extends StatefulWidget {
  @override
  _PermissionRequestPageState createState() => _PermissionRequestPageState();
}

class _PermissionRequestPageState extends State<PermissionRequestPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _finishedContactListPerm = false;
  bool _continue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        Text(
                          "PERMISSIONS REQUEST",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "For the purpose of your credit risk assessment and facilitate faster loan disbursal, we require the following data permissions from you. ",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "1. Contacts & Contact List",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Our app requires this permission to detect reference and auto fill the data during your loan application process for seamless user journey. Also app collects and monitor your contacts information including name, contact list, phone numbers to enrich your financial profile and help us determining loan eligibility and risk assessment. We collect contact information only after obtaining your additional explicit consent.",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "2. Camera",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Our app requires this permission to Enable you to capture your National ID and your recent selfie. The images will be uploaded to https://app.kybeeloans.com and will be deleted after we have determined your risk profile",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: HexColor('#4A1F1F'), // background
                  onPrimary: HexColor('#4A1F1A'),
                  shape: StadiumBorder(), // foreground
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: Text(
                    'Request Permission',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onPressed: () => _requestPermission(context),
              ),
            ),
          ],
        ));
  }

  _requestPermission(context) async {
    var permissionStatus = await _getPermission();
    if (permissionStatus == 1) {
      _finishedContactListPerm = true;
      _continue = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 5000),
          content: Text(
            "Please Grant KYBEE LOANS Permission to Access Conatcts  to continue",
          ),
          action: SnackBarAction(
            label: 'TAKE ME THERE',
            textColor: Colors.orange,
            onPressed: () async {
              await openAppSettings();
            },
          ),
        ),
      );
      _continue = false;
    }

    if (_finishedContactListPerm) {
      var cameraPermissionStatus = await _getCameraPermission();
      if (cameraPermissionStatus == 1) {
        _continue = true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(milliseconds: 5000),
            content: Text(
              "Please Grant KYBEE LOANS Permission to Access Camera  to continue",
            ),
            action: SnackBarAction(
              label: 'TAKE ME THERE',
              textColor: Colors.orange,
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ),
        );
        _continue = false;
      }
    }

    if (_continue) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;

    int _permStatus = 0;
    if (permission == PermissionStatus.granted) {
      _permStatus = 1;
    } else if (permission == PermissionStatus.permanentlyDenied) {
      _permStatus = 3;
    } else {
      final status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
        _permStatus = 1;
      } else {
        _permStatus = 2;
      }
    }

    return _permStatus;
  }

  _getCameraPermission() async {
    final PermissionStatus campermission = await Permission.camera.status;

    int _permStatus = 0;
    if (campermission == PermissionStatus.granted) {
      _permStatus = 1;
    } else if (campermission == PermissionStatus.permanentlyDenied) {
      _permStatus = 3;
    } else {
      final status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        _permStatus = 1;
      } else {
        _permStatus = 2;
      }
    }

    return _permStatus;
  }
}
