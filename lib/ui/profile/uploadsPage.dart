import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:intl/intl.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/profile/contactDetailsPage.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class UploadsPage extends StatefulWidget {
  @override
  _UploadsPageState createState() => _UploadsPageState();
}

class _UploadsPageState extends State<UploadsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  File image;
  var pickedFile;
  String base64Image;
  bool _selfieImageSelected = false;

  Future _pickSelfieImage() async {
    pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        _selfieImageSelected = true;
      });
    }
  }

  Future _saveSelfieImage() async {
    Loading().loader(context, "Saving Selfie...Please wait");

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    final uri =
        Uri.parse("https://app.kybeeloans.com/api/profile/upload_image");
    var request = http.MultipartRequest('POST', uri);
    request.fields['type'] = "selfie";
    request.fields['user_id'] = user['id'].toString();
    var pic = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
      print("image Uploaded here...");
      print("Here .... B");
    } else {
      print("image Not Uploaded");
      print("Here .... C");
    }

    setState(() {
      _selfieImageSelected = false;
    });

    Navigator.pop(context);
  }

  Widget _buildBodyptions(context) {
    return ListView(children: <Widget>[
      _buildIDFrontUpload(context),
      _buildIDBackUpload(context),
      _buildSelfieUpload(context),
    ]);
  }

  Widget _buildIDFrontUpload(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 18.0,
                    color: HexColor('#000000'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Upload Your National ID (Front)",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Take Photo',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Select from Gallery',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIDBackUpload(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 18.0,
                    color: HexColor('#000000'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Upload Your National ID (Back)",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Take Photo',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Select from Gallery',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelfieUpload(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.photo_camera,
                    size: 18.0,
                    color: HexColor('#000000'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Take your recent selfie photo",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () => _pickSelfieImage(),
                      child: Text(
                        'Take Photo',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: pickedFile != null
                    ? Image.file(
                        image,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fitHeight,
                      )
                    : Text('Tap on Take photo then click on save'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _selfieImageSelected
                    ? ElevatedButton(
                        child: Text(
                          'Save Selfie',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.yellow, // foreground
                        ),
                        onPressed: () => _saveSelfieImage(),
                      )
                    : Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: drawer(context),
      appBar: AppBar(
        title: Text(
          'My Profile(Uploads)',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      body: _buildBodyptions(context),
    );
  }
}
