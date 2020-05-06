import 'package:flutter/material.dart';
import 'package:iria/Routes.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/Device.dart';

class DeviceCard extends StatefulWidget  {
  final Map device;
  final API api;

  DeviceCard({this.device, this.api});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Device device;

  @override
  void initState() {
    setState(() {
      device = Device.fromJson(widget.device);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return device != null ? ExpansionTile(
      title: Row(
        children: <Widget>[
          Text("${device.name}")
        ]
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(children: <Widget>[Icon(Icons.email), Text(device.addr)]),
            Row(children: <Widget>[
              IconButton(
                icon: Icon(Icons.mode_edit),
                onPressed: () => Navigator.pushNamed(context, Routes.updateDevice, arguments: {'device': device}),
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
      title: Text("Supprimer l'appareil"),
      content: Text("Êtes vous sûr de vouloir supprimer l'appareil '${device.name}' ?"),
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
            widget.api.deleteDevice(int.parse(device.id));
            setState(() {
              device = null;
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