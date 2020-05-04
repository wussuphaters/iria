import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    super.initState();
    device = Device(id: widget.device['id'], name: widget.device['name'], addr: widget.device['addr'], type: widget.device['type'], room: widget.device['room'], status: widget.device['status']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: device.getIcon(),
            color: device.getColor(),
            onPressed: () => handleToggle()
          ),
          Text(widget.device['name'])
        ],
      )
    );
  }

  void handleToggle()  {
    setState(() {
      widget.api.controlDevice([device.toggle()]);
    });
  }
}