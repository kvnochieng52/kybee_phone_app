import 'package:flutter/material.dart';

// AppBar header(context, {bool isAppTitle = false, String titleText}) {
//   return AppBar(
//     title: Text(
//       isAppTitle ? "FlutterShare" : titleText,
//       style: TextStyle(
//         color: Colors.white,
//         fontFamily: isAppTitle ? "Signatra" : "",
//         fontSize: isAppTitle ? 50.0 : 20.0,
//       ),
//     ),
//     centerTitle: true,
//     backgroundColor: Theme.of(context).accentColor,
//     leading: IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () => Navigator.pop(context, false),
//     ),
//     automaticallyImplyLeading: false,
//   );
// }

AppBar header(context, {String titleText}) {
  return AppBar(
    centerTitle: true,
    title: Image.asset(
      'images/logo_without_name.png',
      fit: BoxFit.cover,
      height: 50.0,
      width: 50.0,
    ),
    elevation: 0.0,
    actions: <Widget>[rightButtons(context, titleText)],
  );
}

Widget rightButtons(context, titleText) {
  switch (titleText) {
    case 'Farmers':
      return IconButton(
        icon: Icon(Icons.search),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed('/search_farmer');
        },
      );
      break;

    case 'Groups':
      return IconButton(
        icon: Icon(Icons.search),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed('/search_group');
        },
      );
      break;

    default:
      return IconButton(
        icon: Icon(Icons.more_vert),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () {},
      );
  }
}
