import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class UsersScreen extends StatefulWidget {
  static const routeName = '/users';
  final API api;

  UsersScreen({this.api});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  User user;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];
    
    return Scaffold(
      appBar: AppBar(
        title : Text("Utilisateurs")
      ),
      body: Text("Page utilisateurs"),
      drawer: Menu(user: user),
    );
  }
}