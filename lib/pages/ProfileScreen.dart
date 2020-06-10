import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  final API api;

  ProfileScreen({this.api});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];

    return Scaffold(
      appBar: AppBar(
        title : Text("Mon profil")
      ),
      body: Text("profil"),
      drawer: Menu(user: user),
    );
  }
}