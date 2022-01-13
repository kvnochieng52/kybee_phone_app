import 'package:flutter/cupertino.dart';
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

class ContactUsPage extends StatefulWidget {
  // const ContactUsPage({Key? key}): super(key:key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _firstname;
  String _county;
  var county_items = [
    'Nairobi',
    'Kisumu',
    'Mombasa',
    'Kitui',
    'Embu',
    'Machakos',
    'Nyandarua',
    'Kirinyaga',
    'Muranga'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Contact Us',
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
                    "Phone",
                    style: TextStyle(
                      fontSize: 16.9,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "0712345678",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#4A1F1F'),
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.phone)),
                  trailing: Column(
                    //spacing: 12, // space between two icons
                    children: <Widget>[
                      Text(
                        "Call Us",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: HexColor('#4A1F1F'),
                        ),
                      ),

                      //Icon(Icons.chevron_right), // icon-2
                    ],
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "Whatsapp",
                    style: TextStyle(
                      fontSize: 16.9,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "0718765432",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#4A1F1F'),
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.chat)),
                  trailing: Column(
                    //spacing: 12, // space between two icons
                    children: <Widget>[
                      Text(
                        "Chat with Us",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: HexColor('#4A1F1F'),
                        ),
                      ),

                      //Icon(Icons.chevron_right), // icon-2
                    ],
                  ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16.9,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "support@kybeeloans.com",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#4A1F1F'),
                      ),
                    ),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(Icons.email_outlined)),
                  // trailing: Column(
                  //   //spacing: 12, // space between two icons
                  //   children: <Widget>[
                  //     Text(
                  //       "Send Email",
                  //       style: TextStyle(
                  //         fontSize: 15.0,
                  //         color: HexColor('#4A1F1F'),
                  //       ),
                  //     ),

                  //     //Icon(Icons.chevron_right), // icon-2
                  //   ],
                  // ),
                  onTap: () => null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
