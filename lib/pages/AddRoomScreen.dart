import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';

class AddRoomScreen extends StatefulWidget {
  static const routeName = '/rooms/add';
  final API api;

  AddRoomScreen({this.api});

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Ajouter une pièce")
      ),
      body: Text("Page ajout")
    );
  }
}