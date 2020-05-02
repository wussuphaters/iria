import 'package:flutter/material.dart';
import 'API.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final api = API(addr: 'http://192.168.1.100/smart_home_api/api');
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) =>
    Scaffold(
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
                var jwt = await api.login(_usernameController.text, _passwordController.text);
                if(jwt != null) {
                  storage.write(key: "jwt", value: jwt);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen.fromBase64(jwt)
                    )
                  );
                } else {
                  displayDialog(context, "Erreur", "L'adresse email et le mot de passe entrés ne sont pas valides");
                }
              }
            )
          ]
        )
      )
    );

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