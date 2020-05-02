import 'package:flutter/cupertino.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class IriaApp extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iria Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,            
        builder: (context, snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          if(snapshot.data != "") {           
            var str = snapshot.data;
            var jwt = str.split(".");

            if(jwt.length !=3) {
              return LoginScreen();
            } else {
              
              var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));

              return HomeScreen(str, payload);
            }
          } else {
            return LoginScreen();
          }
        }
      ),
    );
  }
}