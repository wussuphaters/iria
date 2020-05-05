import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/Device.dart';

class DeviceCard extends StatefulWidget  {
  final Map device;
  final API api;
  final Future<Map> status;

  DeviceCard({this.device, this.api, this.status});

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Future<Map> status;
  Device device;
  bool _loading = true;

  @override
  void initState() {
    setState(() {
      device = Device(id: widget.device['id'], name: widget.device['name'], addr: widget.device['addr'], type: widget.device['type'], room: widget.device['room'], status: Map<String, dynamic>());
      status = widget.status;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: status,
      builder: (context, AsyncSnapshot<Map> snapshot) {
        if(snapshot.hasData)  {
          device.status = snapshot.data;
          _loading = false;
        }

        if(device.type == "light-xiaomi" || device.type == "light-philips")
          return ExpansionTile(
            title: Row(
              children: <Widget>[
                device.status.containsKey('power') ? IconButton(
                    icon: device.getIcon(),
                    color: device.getColor(),
                    onPressed: () => handleToggle()
                  ) : CircularProgressIndicator(),
                Text(device.name)
              ]
            ),
            children: <Widget>[
              Slider(
                min: 1,
                max: 100,
                value: device.status.containsKey("bright") ? device.status['bright'] : 50,
                divisions: 100,
                onChanged: (device.status.containsKey('power') && device.status['power'] == "on" && !_loading) ? (value){
                  device.status['bright'] = value;
                  status = null;
                  setState(() {
                  });
                } : null,
                onChangeEnd: (value) => (device.status.containsKey('power') && device.status['power'] == "on" && !_loading) ? handleBrightnessChange(value) : null
              )
            ]
          );
        else return Row(
          children: <Widget>[
            snapshot.hasData ? IconButton(
                icon: device.getIcon(),
                color: device.getColor(),
                onPressed: () => handleToggle()
              ) : CircularProgressIndicator(),
            Text(device.name)
          ]);
      }
    );
  }

  void handleToggle() async {
    setState(() {
      _loading = true;
    });
    await widget.api.controlDevice([device.toggle()]);
    status = widget.api.getDeviceStatus(device.id);
    setState(() {
      _loading = true;
    });
  }

  void handleBrightnessChange(double value) async {
    setState(() {
      _loading = true;
    });
    device.status['bright'] = value;
    await widget.api.controlDevice([{'id': device.id, 'brightness': value}]);
    status = widget.api.getDeviceStatus(device.id);
    setState(() {
      _loading = true;
    });
  }
}