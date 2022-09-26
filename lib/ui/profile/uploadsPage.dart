import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/models/configuration.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class UploadsPage extends StatefulWidget {
  @override
  _UploadsPageState createState() => _UploadsPageState();
}

class _UploadsPageState extends State<UploadsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _initDataFetched = false;

  File image;
  File iDFrontImage;
  File iDBackImage;

  var pickedFile;
  var iDFrontPickedFile;
  var iDBackPickedFile;

  bool _selfieImageSelected = false;
  bool _iDFrontImageSelected = false;
  bool _iDBackImageSelected = false;

  String _uploadedSelfieImage;
  String _uploadedIDFrontImage;
  String _uploadedIDBackImage;

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
      setState(() {
        _initDataFetched = true;
      });

      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _uploadedSelfieImage = body['data']['selfie'];
          _uploadedIDFrontImage = body['data']['id_front'];
          _uploadedIDBackImage = body['data']['id_back'];
        });
      }
    }
  }

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

    final uri = Uri.parse(Configuration.API_URL + "profile/upload_image");
    var request = http.MultipartRequest('POST', uri);
    request.fields['type'] = "selfie";
    request.fields['user_id'] = user['id'].toString();
    var pic = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
    } else {}

    setState(() {
      _selfieImageSelected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Selfie image  Successfully Saved"),
      ),
    );

    Navigator.pop(context);
  }

  _showSelfieImage(context) {
    if (pickedFile != null) {
      return Image.file(
        image,
        fit: BoxFit.cover,
        height: 250,
        width: 300,
      );
    } else {
      if (_uploadedSelfieImage != null) {
        return CachedNetworkImage(
          imageUrl: Configuration.WEB_URL + _uploadedSelfieImage,
          placeholder: (context, url) => Text("loading image... please wait"),
          fit: BoxFit.cover,
          height: 250,
          //width: ,
          //errorWidget: (context, url, error) => new Icon(Icons.error),
        );
      }
    }
    return Text("");
  }

  Future _pickIDFrontImage() async {
    iDFrontPickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (iDFrontPickedFile != null) {
      setState(() {
        iDFrontImage = File(iDFrontPickedFile.path);
        _iDFrontImageSelected = true;
      });
    }
  }

  Future _saveIDFrontImage() async {
    Loading().loader(context, "Saving ID Front...Please wait");

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    final uri = Uri.parse(Configuration.API_URL + "profile/upload_image");
    var request = http.MultipartRequest('POST', uri);
    request.fields['type'] = "id_front";
    request.fields['user_id'] = user['id'].toString();
    var pic = await http.MultipartFile.fromPath("image", iDFrontImage.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
    } else {}

    setState(() {
      _iDFrontImageSelected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("ID Front image  Successfully Saved"),
      ),
    );

    Navigator.pop(context);
  }

  _showIDFrontImage(context) {
    if (iDFrontPickedFile != null) {
      return Image.file(
        iDFrontImage,
        fit: BoxFit.cover,
        height: 250,
        width: 300,
      );
    } else {
      if (_uploadedIDFrontImage != null) {
        return CachedNetworkImage(
          imageUrl: Configuration.WEB_URL + _uploadedIDFrontImage,
          placeholder: (context, url) => Text("loading image... please wait"),
          fit: BoxFit.cover,
          height: 250,
          //width: ,
          //errorWidget: (context, url, error) => new Icon(Icons.error),
        );
      }
    }
    return Text("");
  }

  Future _pickIDBackImage() async {
    iDBackPickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (iDBackPickedFile != null) {
      setState(() {
        iDBackImage = File(iDBackPickedFile.path);
        _iDBackImageSelected = true;
      });
    }
  }

  _showIDBackImage(context) {
    if (iDBackPickedFile != null) {
      return Image.file(
        iDBackImage,
        fit: BoxFit.cover,
        height: 250,
        width: 300,
      );
    } else {
      if (_uploadedIDBackImage != null) {
        return CachedNetworkImage(
          imageUrl: Configuration.WEB_URL + _uploadedIDBackImage,
          placeholder: (context, url) => Text("loading image... please wait"),
          fit: BoxFit.cover,
          height: 250,
          //width: ,
          //errorWidget: (context, url, error) => new Icon(Icons.error),
        );
      }
    }
    return Text("");
  }

  Future _saveIDBackImage() async {
    Loading().loader(context, "Saving ID Back...Please wait");

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    final uri = Uri.parse(Configuration.API_URL + "profile/upload_image");
    var request = http.MultipartRequest('POST', uri);
    request.fields['type'] = "id_back";
    request.fields['user_id'] = user['id'].toString();
    var pic = await http.MultipartFile.fromPath("image", iDBackImage.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
    } else {}

    setState(() {
      _iDBackImageSelected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("ID Back image  Successfully Saved"),
      ),
    );

    Navigator.pop(context);
  }

  Widget _buildBodyptions(context) {
    return ListView(children: <Widget>[
      _buildIDFrontUpload(context),
      _buildIDBackUpload(context),
      _buildSelfieUpload(context),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: HexColor('#4A1F1F'), // background
            onPrimary: HexColor('#4A1F1A'),
            shape: StadiumBorder(), // foreground
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(
              'Submit'.toUpperCase(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return DashboardPage();
              }),
            )
          },
        ),
      ),
    ]);
  }

  Widget _buildIDFrontUpload(context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
            left: 5.0,
            right: 5.0,
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
                      onPressed: () => _pickIDFrontImage(),
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
                child: _showIDFrontImage(context),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: _iDFrontImageSelected
                    ? ElevatedButton(
                        child: Text(
                          'Save ID Front',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.yellow, // foreground
                        ),
                        onPressed: () => _saveIDFrontImage(),
                      )
                    : Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIDBackUpload(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 4.0,
            left: 8.0,
            right: 8.0,
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
                      onPressed: () => _pickIDBackImage(),
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
                child: _showIDBackImage(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _iDBackImageSelected
                    ? ElevatedButton(
                        child: Text(
                          'Save ID Back',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.yellow, // foreground
                        ),
                        onPressed: () => _saveIDBackImage(),
                      )
                    : Text(""),
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
                child: _showSelfieImage(context),
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
      body: _initDataFetched
          ? _buildBodyptions(context)
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
    );
  }
}
