import 'package:flutter/material.dart';
import 'package:iria/Routes.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class UserCard extends StatefulWidget  {
  final Map user;
  final API api;

  UserCard({this.user, this.api});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  User user;

  @override
  void initState() {
    setState(() {
      user = User(widget.user);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null ? ExpansionTile(
      title: Row(
        children: <Widget>[
          Icon(user.isAdmin ? Icons.verified_user : Icons.account_circle),
          Text("${user.firstName} ${user.lastName}")
        ]
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(children: <Widget>[Icon(Icons.email), Text(user.email)]),
            Row(children: <Widget>[Icon(Icons.phone), Text(user.phoneNumber)]),
            Row(children: <Widget>[Icon(Icons.access_time), Text(user.expiration)]),
            Row(children: <Widget>[
              IconButton(
                icon: Icon(Icons.mode_edit),
                onPressed: () => Navigator.pushNamed(context, Routes.updateUser),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => handleDelete(context)
              )
            ])
          ],
        )
      ]
    ) : SizedBox.shrink();
  }

  void handleDelete(BuildContext context)  {
    AlertDialog deleteUserDialog = AlertDialog(
      title: Text("Supprimer l'utilisateur"),
      content: Text("Êtes vous sûr de vouloir supprimer ${user.firstName} ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("ANNULER"),
          onPressed: (){
            Navigator.pop(context);
          }
        ),
        FlatButton(
          child: Text("SUPPRIMER"),
          onPressed: () {
            widget.api.deleteUser(user.id);
            setState(() {
              user = null;
            });
            Navigator.pop(context);
          }
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return deleteUserDialog;
      },
    );
  }
}