import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/User.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _birthDateController;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];
    
    _firstNameController = new TextEditingController(text: user.firstName);
    _lastNameController = new TextEditingController(text: user.lastName);
    _emailController = new TextEditingController(text: user.email);
    _phoneNumberController = new TextEditingController(text: user.phoneNumber);
    _birthDateController = new TextEditingController(text: user.birthDate);

    return Scaffold(
      appBar: AppBar(
        title : Text("Mon profil")
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: "Prénom"
            )
          ),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: "Nom"
            )
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Adresse email"
            )
          ),
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              labelText: "Numéro de téléphone"
            )
          ),
          TextField(
            controller: _birthDateController,
            decoration: InputDecoration(
              labelText: "Date de naissance"
            )
          )
        ]
      ),
      drawer: Menu(user: user),
    );
  }
}