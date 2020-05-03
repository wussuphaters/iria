import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/users';
  String jwt;
  API api;

  UserScreen({this.api, this.jwt});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Utilisateurs")
      ),
      body: Text("Page utilisateurs"),
      drawer: Menu(admin: true),
    );
  }
}