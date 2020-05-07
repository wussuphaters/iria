import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/Routes.dart';
import 'package:iria/UserCard.dart';
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
              return UserCard(user: users[index], api: widget.api);
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
}