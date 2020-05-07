import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/UserForm.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class AddUserScreen extends StatefulWidget {
  static const routeName = '/users/add';
  final API api;

  AddUserScreen({this.api});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  User user;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];

    return Scaffold(
      appBar: AppBar(
        title : Text("Ajouter un utilisateur")
      ),
      body: UserForm(api: widget.api)
    );
  }
}