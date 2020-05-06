import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';

class RoomCard extends StatefulWidget  {
  final Map room;
  final API api;

  RoomCard({this.room, this.api});

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  Map room;

  @override
  void initState() {
    setState(() {
      room = widget.room;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(room);
    return room != null ? Row(
      children: <Widget>[
        Text(room['name']),
        Text("${room['deviceCount']} appareils"),
        IconButton(
          icon: Icon(Icons.mode_edit),
          onPressed: () {
            
          }
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => handleDelete(context)
        )
      ],
    ) : SizedBox.shrink();
  }

  void handleDelete(BuildContext context)  {
    AlertDialog deleteUserDialog = AlertDialog(
      title: Text("Supprimer la pièce"),
      content: Text("Êtes vous sûr de vouloir supprimer la pièce '${room['name']}' ? Les appareils de cette pièce devront être réattribués à une autre"),
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
            widget.api.deleteRoom(room['id']);
            setState(() {
              room = null;
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