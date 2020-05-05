import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
              ) : FutureBuilder(
                future: Future.delayed(Duration(seconds: 5)),
                builder: (context, s) => s.connectionState == ConnectionState.done
                    ? IconButton(
                      icon: device.getIcon(),
                      color: device.getColor(),
                      onPressed: () => handleToggle()
                    )
                    : 
                    CircularProgressIndicator()
              ),
                Text(device.name)
              ]
            ),
            children: <Widget>[
              Text("Luminosité"),
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
              ),
              Text("Température"),
              Slider(
                min: 1700,
                max: 6500,
                value: device.status.containsKey("ct") ? device.status['ct'] : 3500,
                divisions: 100,
                onChanged: (device.status.containsKey('power') && device.status['power'] == "on" && !_loading) ? (value){
                  device.status['ct'] = value;
                  status = null;
                  setState(() {
                  });
                } : null,
                onChangeEnd: (value) => (device.status.containsKey('power') && device.status['power'] == "on" && !_loading) ? handleTemperatureChange(value) : null
              ),
              Text("Couleur"),
              RawMaterialButton(
                onPressed: () => openColorPicker(),
                elevation: 2.0,
                fillColor: device.status.containsKey('rgb') ? Color(int.parse(device.status['rgb'], radix: 16) + 0xFF000000) : Colors.blue,
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              )              
            ]
          );
        else return Row(
          children: <Widget>[
            device.status.containsKey('state') ? IconButton(
                icon: device.getIcon(),
                color: device.getColor(),
                onPressed: () => handleToggle()
              ) : FutureBuilder(
                future: Future.delayed(Duration(seconds: 5)),
                builder: (context, s) => s.connectionState == ConnectionState.done
                    ? IconButton(
                      icon: device.getIcon(),
                      color: device.getColor(),
                      onPressed: () => handleToggle()
                    )
                    : 
                    CircularProgressIndicator()
              ),
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

  void handleTemperatureChange(double value) async  {
    setState(() {
      _loading = true;
    });
    device.status['ct'] = value;
    await widget.api.controlDevice([{'id': device.id, 'ct': value}]);
    status = widget.api.getDeviceStatus(device.id);
    setState(() {
      _loading = true;
    });
  }

  void handleColorChange() async {
    setState(() {
      _loading = true;
    });
    await widget.api.controlDevice([{'id': device.id, 'color': device.status['rgb']}]);
    status = widget.api.getDeviceStatus(device.id);
    setState(() {
      _loading = true;
    });
  }

  void openColorPicker()  {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Couleur"),
          content: BlockPicker(
            availableColors: [
              Colors.red, Colors.green, Colors.blue, Colors.cyan,
              Colors.indigo, Colors.pink[100], Colors.purple, Colors.lightGreen[300],
            ],
            pickerColor: Color(int.parse(device.status['rgb'], radix: 16) + 0xFF000000),
            onColorChanged: (color) {
              setState(() {
                device.status['rgb'] = color.toString().substring(color.toString().length-8, color.toString().length-2);
                handleColorChange();
              });
            }
          ),
          actions: [
            FlatButton(
              child: Text('FERMER'),
              onPressed: Navigator.of(context).pop,
            )
          ],
        );
      },
    );
  }
}