import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Routes.dart';
import 'ControlScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';
  API api;

  LoginScreen({this.api});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final storage = FlutterSecureStorage();

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context)  {
    return FutureBuilder(
      future: jwtOrEmpty,            
      builder: (context, snapshot) {
        if(!snapshot.hasData) return CircularProgressIndicator();
        if(snapshot.data != "") {           
          var str = snapshot.data;
          var jwt = str.split(".");

          if(jwt.length == 3) return ControlScreen(api: widget.api);
        }
        return Scaffold(
          appBar: AppBar(title: Text('Connexion')),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Adresse email'
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe'
                  )
                ),
                FlatButton(
                  child: Text("Connexion"),
                  onPressed: () async {
                    var jwt = await widget.api.login(_usernameController.text, _passwordController.text);
                    if(jwt != null) {
                      storage.write(key: "jwt", value: jwt);
                      Navigator.pushReplacementNamed(context, Routes.control);
                    } else {
                      displayDialog(context, "Erreur", "L'adresse email et le mot de passe entrés ne sont pas valides");
                    }
                  }
                )
              ]
            )
          )
        );
      }
    );
  }

  void displayDialog(BuildContext context, String title, String text) => 
    showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: Text(title),
          content: Text(text)
        ),
    );
}