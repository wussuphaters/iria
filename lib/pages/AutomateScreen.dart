import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';
import 'package:iria/TaskCard.dart';

class AutomateScreen extends StatefulWidget {
  static const routeName = '/automate';
  final API api;

  AutomateScreen({this.api});

  @override
  _AutomateScreenState createState() => _AutomateScreenState();
}

class _AutomateScreenState extends State<AutomateScreen> {
  User user;
  List tasks;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if (args != null) user = args['user'];

    return FutureBuilder(
      future: widget.api.getTasks(),
      builder: (context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          tasks = snapshot.data['tasks'];
          if (tasks == null) user.logout(context);
        }
        return Scaffold(
          appBar: AppBar(title: Text("Appareils")),
          body: snapshot.hasData
              ? (tasks.length > 0)
                  ? ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskCard(device: tasks[index], api: widget.api);
                      },
                    )
                  : Text("Aucune tâche programmée pour l'instant")
              : Center(
                  child: FutureBuilder(
                      future: Future.delayed(Duration(seconds: 2)),
                      builder: (context, s) =>
                          s.connectionState == ConnectionState.done
                              ? Text("Impossible de se connecter à l'API.")
                              : CircularProgressIndicator())),
          floatingActionButton:
              FloatingActionButton(child: Icon(Icons.add), onPressed: () => {}),
          drawer: Menu(user: user),
        );
      },
    );
  }
}
