import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/Routes.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class UsersScreen extends StatefulWidget {
  static const routeName = '/users';
  final API api;

  UsersScreen({this.api});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  User user;
  List users;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];
    
    return FutureBuilder(
      future: widget.api.getUsers(),
      builder: (context, AsyncSnapshot<Map> snapshot)  {
        if(snapshot.hasData)  {
          users = snapshot.data['users'];
          if(users == null) user.logout(context);
        }
        return Scaffold(
          appBar: AppBar(
            title : Text("Utilisateurs")
          ),
          body: snapshot.hasData ? ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index)  {
              User user = User.fromJson(users[index]);
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
                      user.expiration != null ? Row(children: <Widget>[Icon(Icons.access_time), Text(user.expiration.toString())]) : SizedBox.shrink(),
                      Row(children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.mode_edit),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.updateUser, arguments: {'user': user}).then((value) {setState(() {});});
                          }
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
            },
          ) : Center(
            child: FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)),
                builder: (context, s) => s.connectionState == ConnectionState.done
                    ? Text("Impossible de se connecter à l'API.")
                    : 
                    CircularProgressIndicator()
            )
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, Routes.addUser).then((value) {
              setState(() {});
            })
          ),
          drawer: Menu(user: user),
        );
      },
    );
  }

  void handleDelete(BuildContext context)  {
    AlertDialog deleteUserDialog = AlertDialog(
      title: Text("Supprimer l'utilisateur"),
      content: Text("Êtes vous sûr de vouloir supprimer ${user.firstName} des utilisateurs ?"),
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