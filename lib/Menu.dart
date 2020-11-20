import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Routes.dart';
import 'package:iria/objects/User.dart';

class Menu extends StatefulWidget {
  final User user;

  Menu({this.user});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createDrawerItem(
              icon: Icons.lightbulb_outline,
              text: 'Contrôle',
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.control,
                  arguments: {"user": widget.user})),
          _createDrawerItem(
              icon: Icons.timer,
              text: 'Automatisation',
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.automate,
                  arguments: {"user": widget.user})),
          widget.user.isAdmin
              ? _createDrawerItem(
                  icon: Icons.group,
                  text: 'Utilisateurs',
                  onTap: () => Navigator.pushReplacementNamed(
                      context, Routes.users,
                      arguments: {"user": widget.user}))
              : Row(),
          widget.user.isAdmin
              ? _createDrawerItem(
                  icon: Icons.devices,
                  text: 'Appareils',
                  onTap: () => Navigator.pushReplacementNamed(
                      context, Routes.devices,
                      arguments: {"user": widget.user}))
              : Row(),
          _createDrawerItem(
              icon: Icons.account_circle,
              text: 'Profil de ${widget.user.firstName}',
              onTap: () => Navigator.pushReplacementNamed(
                  context, Routes.profile,
                  arguments: {"user": widget.user})),
          widget.user.isAdmin
              ? _createDrawerItem(
                  icon: Icons.home,
                  text: 'Pièces',
                  onTap: () => Navigator.pushReplacementNamed(
                      context, Routes.rooms,
                      arguments: {"user": widget.user}))
              : Row(),
          _createDrawerItem(
              icon: Icons.lock_outline,
              text: 'Déconnexion',
              onTap: () => showAlertDialog(context)),
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
      content:
          Text("Êtes vous sûr de vouloir vous déconnecter de l'application ?"),
      actions: <Widget>[
        FlatButton(
            child: Text("ANNULER"),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
            child: Text("OUI"), onPressed: () => widget.user.logout(context))
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
