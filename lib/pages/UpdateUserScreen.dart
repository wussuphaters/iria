import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class UpdateUserScreen extends StatefulWidget {
  static const routeName = '/users/update';
  final API api;

  UpdateUserScreen({this.api});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Modifier l'utilisateur")
      ),
      body: Text("Page modif")
    );
  }
}