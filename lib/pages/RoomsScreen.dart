import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/RoomCard.dart';
import 'package:iria/Menu.dart';
import 'package:iria/Routes.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class RoomsScreen extends StatefulWidget {
  static const routeName = '/rooms';
  final API api;

  RoomsScreen({this.api});

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  User user;
  List rooms;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];
    
    return FutureBuilder(
      future: widget.api.getRooms(),
      builder: (context, AsyncSnapshot<Map> snapshot)  {
        if(snapshot.hasData)  {
          rooms = snapshot.data['rooms'];
          if(rooms == null) user.logout(context);
        }
        return Scaffold(
          appBar: AppBar(
            title : Text("Pièces")
          ),
          body: snapshot.hasData ? ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (BuildContext context, int index)  {
              return RoomCard(room: rooms[index], api: widget.api);
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
            onPressed: () => Navigator.pushNamed(context, Routes.addRoom)
          ),
          drawer: Menu(user: user),
        );
      },
    );
  }
}