import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Routes.dart';

class Menu extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createDrawerItem(
            icon: Icons.lightbulb_outline,
            text: 'Contrôle',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.control)
          ),
          _createDrawerItem(
            icon: Icons.account_circle,
            text: 'Mon profil',
            onTap: () => Navigator.pushReplacementNamed(context, Routes.profile)
          ),
          _createDrawerItem(
            icon: Icons.lock_outline,
            text: 'Déconnexion',
            onTap: () => showAlertDialog(context)
          ),
        ],
      ),
    );
  }
  
  Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog logoff = AlertDialog(
      title: Text("Déconnexion"),
      content: Text("Êtes vous sûr de vouloir vous déconnecter de l'application ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("ANNULER"),
          onPressed: (){}
        ),
        FlatButton(
          child: Text("OUI"),
          onPressed: (){
            FlutterSecureStorage().delete(key: "jwt");
            Navigator.pushNamedAndRemoveUntil(context, Routes.login, ModalRoute.withName(Routes.login));
          }
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return logoff;
      },
    );
  }
}