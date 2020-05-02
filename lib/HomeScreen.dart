import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iria/LoginScreen.dart';
import 'API.dart';

class HomeScreen extends StatelessWidget {
  final api = API(addr: 'http://192.168.1.100/smart_home_api/api');
  final storage = FlutterSecureStorage();
  final String jwt;
  final Map<String, dynamic> payload;

  HomeScreen(this.jwt, this.payload);

  factory HomeScreen.fromBase64(String jwt) =>
    HomeScreen(
      jwt,
      json.decode(
        ascii.decode(
          base64.decode(base64.normalize(jwt.split(".")[1]))
        )
      )
    );

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(title: Text("Connexion réussie")),
      body: Column(
        children: [
          Text("${payload['data']['id']}"),
          FlatButton(
            onPressed: (){
              storage.delete(key: "jwt");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen()
                )
              );
            },
            child: Text("Déconnexion")
          )
        ]
      ),
    );
}