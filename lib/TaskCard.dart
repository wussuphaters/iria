import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/Task.dart';

class TaskCard extends StatefulWidget {
  final Map device;
  final API api;

  TaskCard({this.device, this.api});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Task task;

  @override
  void initState() {
    setState(() {
      task = Task.fromJson(widget.device);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return task != null
        ? ExpansionTile(
            title: Row(children: <Widget>[
              task.getIcon(),
              Text("${task.name} (${task.actionCount} actions associées)")
            ]),
            children: <Widget>[])
        : SizedBox.shrink();
  }

  void handleDelete(BuildContext context) {
    AlertDialog deleteUserDialog = AlertDialog(
      title: Text("Supprimer l'appareil"),
      content:
          Text("Êtes vous sûr de vouloir supprimer la tâche '${task.name}' ?"),
      actions: <Widget>[
        FlatButton(
            child: Text("ANNULER"),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
            child: Text("SUPPRIMER"),
            onPressed: () {
              setState(() {
                task = null;
              });
              Navigator.pop(context);
            })
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
