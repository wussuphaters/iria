import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class AddUserScreen extends StatefulWidget {
  static const routeName = '/addUser';
  final API api;

  AddUserScreen({this.api});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Ajouter un utilisateur")
      ),
      body: Text("Page ajout")
    );
  }
}