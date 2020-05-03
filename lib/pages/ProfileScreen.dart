import 'package:flutter/material.dart';

import 'Menu.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Mon profil")
      ),
      body: Text("Page profil utilisateur"),
      drawer: Menu(),
    );
  }

}