import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iria/objects/API.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iria/objects/User.dart';

import 'package:iria/Routes.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';
  final API api;

  LoginScreen({this.api});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool loading = false;

  Future<User> fetchUserProfile() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null)
      return User();
    else {
      var jwtArray = jwt.split(".");

      if (jwtArray.length == 3) {
        widget.api.jwt = jwt;
        User user = await widget.api.getUser();
        return user;
      } else
        return User();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: widget.api.getAddr(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else
            widget.api.addr = snapshot.data;
          return FutureBuilder<User>(
              future: fetchUserProfile(),
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (!snapshot.hasData) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else {
                  User user = snapshot.data;
                  if (user.id != null) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(context, Routes.control,
                          arguments: {"user": user});
                    });
                  }
                  return Scaffold(
                      appBar: AppBar(title: Text('Connexion')),
                      body: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(children: [
                            TextField(
                              controller: _usernameController,
                              decoration:
                                  InputDecoration(labelText: 'Adresse email'),
                            ),
                            TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration:
                                    InputDecoration(labelText: 'Mot de passe')),
                            FlatButton(
                                child: loading
                                    ? CircularProgressIndicator()
                                    : Text("Connexion"),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  var jwt = await widget.api.login(
                                      _usernameController.text,
                                      _passwordController.text);
                                  if (jwt != null) {
                                    storage.write(key: "jwt", value: jwt);
                                    widget.api.jwt = jwt;
                                    User user = await widget.api.getUser();
                                    if (user != null) {
                                      Navigator.pushReplacementNamed(
                                          context, Routes.control,
                                          arguments: {"user": user});
                                      setState(() {
                                        loading = false;
                                      });
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      displayDialog(context, "Erreur",
                                          "Votre compte utilisateur a expiré");
                                    }
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    displayDialog(context, "Erreur",
                                        "L'adresse email et le mot de passe entrés ne sont pas valides");
                                  }
                                })
                          ])));
                }
              });
        });
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
