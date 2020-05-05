import 'package:flutter/material.dart';

class Device    {
  String id;
  String name;
  String addr;
  String type;
  String room;
  Map<String, dynamic> status;

  Device({this.id, this.name, this.addr, this.type, this.room, this.status});

  Widget getIcon()  {
    IconData iconData;
    if(status.length == 0) iconData = Icons.warning;
    else if(type == "light-xiaomi" || type == "light-philips") {
      iconData = Icons.lightbulb_outline;
    } else if(type == "lock") {
      if(status['state'] == "lock") iconData = Icons.lock;
      else iconData = Icons.lock_open;
    }

    return Icon(iconData);
  }

  MaterialColor getColor()  {
    MaterialColor color;
    if(status.length == 0) color = Colors.grey;
    else if((type == "light-xiaomi" || type == "light-philips") && status['power'] == "on")  {
      color = Colors.amber;
    } else color = Colors.grey;

    return color;
  }

  Map toggle() {
    Map payload;
    if(status.length == 0) payload = {};
    else if(type == "light-xiaomi" || type == "light-philips") {
      if(status['power'] == "on") payload = {'id': id, 'power': "off"};
      else payload = {'id': id, 'power': "on"};
    } else if(type == "lock") {
      if(status['state'] == "unlock") payload = {'id': id, 'state': "lock"};
      else payload = {'id': id, 'state': "unlock"};
    } else payload = {};

    return payload;
  }
}