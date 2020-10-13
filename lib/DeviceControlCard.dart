import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/Device.dart';

class DeviceControlCard extends StatefulWidget {
  final Map device;
  final API api;

  DeviceControlCard({this.device, this.api});

  @override
  _DeviceControlCardState createState() => _DeviceControlCardState();
}

class _DeviceControlCardState extends State<DeviceControlCard> {
  Future<Map> status;
  Device device;
  bool _loading = true;

  @override
  void initState() {
    setState(() {
      device = Device(
          id: widget.device['id'],
          name: widget.device['name'],
          addr: widget.device['addr'],
          type: widget.device['type'],
          room: widget.device['room'],
          status: Map<String, dynamic>());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.api.getDeviceStatus(device.id),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            device.status = snapshot.data;
            _loading = false;
          }
          return ExpansionTile(
              title: Row(children: <Widget>[
                device.status.containsKey('state') ||
                        device.status.containsKey('power')
                    ? IconButton(
                        icon: device.getIcon(),
                        color: device.getColor(),
                        onPressed: () => !_loading ? handleToggle() : null)
                    : FutureBuilder(
                        future: Future.delayed(Duration(seconds: 5)),
                        builder: (context, s) =>
                            s.connectionState == ConnectionState.done
                                ? IconButton(
                                    icon: device.getIcon(),
                                    color: device.getColor(),
                                    onPressed: () =>
                                        !_loading ? handleToggle() : null)
                                : CircularProgressIndicator()),
                Text(device.name)
              ]),
              children: (device.type == "light-xiaomi" ||
                      device.type == "light-philips")
                  ? <Widget>[
                      Row(
                        children: [
                          Text("Luminosité"),
                          Slider(
                              min: 1,
                              max: 100,
                              value: device.status.containsKey("bright")
                                  ? device.status['bright']
                                  : 50,
                              divisions: 100,
                              onChanged: (device.status.containsKey('power') &&
                                      device.status['power'] == "on" &&
                                      !_loading)
                                  ? (value) {
                                      device.status['bright'] = value;
                                      status = null;
                                      setState(() {});
                                    }
                                  : null,
                              onChangeEnd: (value) =>
                                  (device.status.containsKey('power') &&
                                          device.status['power'] == "on" &&
                                          !_loading)
                                      ? handleBrightnessChange(value)
                                      : null)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Température"),
                          Slider(
                              min: 1700,
                              max: 6500,
                              value: device.status.containsKey("ct")
                                  ? device.status['ct']
                                  : 3500,
                              divisions: 100,
                              onChanged: (device.status.containsKey('power') &&
                                      device.status['power'] == "on" &&
                                      !_loading)
                                  ? (value) {
                                      device.status['ct'] = value;
                                      status = null;
                                      setState(() {});
                                    }
                                  : null,
                              onChangeEnd: (value) =>
                                  (device.status.containsKey('power') &&
                                          device.status['power'] == "on" &&
                                          !_loading)
                                      ? handleTemperatureChange(value)
                                      : null)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Couleur"),
                          RawMaterialButton(
                            onPressed: () => device.status['power'] == "on"
                                ? openColorPicker()
                                : null,
                            elevation: 2.0,
                            fillColor: device.status.containsKey('rgb')
                                ? Color(
                                    int.parse(device.status['rgb'], radix: 16) +
                                        0xFF000000)
                                : Colors.blue,
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          )
                        ],
                      )
                    ]
                  : ((device.type == "lock")
                      ? <Widget>[
                          Row(
                            children: [
                              Text("Définir mon empreinte digitale"),
                              IconButton(
                                  icon: Icon(Icons.fingerprint),
                                  color: device.getColor(),
                                  onPressed: () => !_loading
                                      ? handleFingerprintEnroll()
                                      : null)
                            ],
                          ),
                          Row(
                            children: [
                              Text("Supprimer mon empreinte digitale"),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  color: device.getColor(),
                                  onPressed: () => !_loading
                                      ? handleFingerprintDelete()
                                      : null)
                            ],
                          )
                        ]
                      : <Widget>[
                          Text("Aucune action disponible pour cet appareil")
                        ]));
        });
  }

  void handleToggle() async {
    setState(() {
      _loading = true;
    });
    bool res = await widget.api.controlDevice([device.toggle()]);

    if (!res) Fluttertoast.showToast(msg: widget.api.lastErrorMsg);
  }

  void handleFingerprintEnroll() async {
    bool res = await widget.api.controlDevice([
      {'id': device.id, 'enroll': ""}
    ]);

    if (!res) Fluttertoast.showToast(msg: widget.api.lastErrorMsg);
  }

  void handleFingerprintDelete() async {
    bool res = await widget.api.controlDevice([
      {'id': device.id, "delete": ""}
    ]);

    if (!res)
      Fluttertoast.showToast(msg: widget.api.lastErrorMsg);
    else
      Fluttertoast.showToast(msg: "Votre empreinte a bien été supprimée");
  }

  void handleBrightnessChange(double value) async {
    setState(() {
      _loading = true;
    });
    device.status['bright'] = value;
    bool res = await widget.api.controlDevice([
      {'id': device.id, 'brightness': value}
    ]);

    if (!res) Fluttertoast.showToast(msg: widget.api.lastErrorMsg);
  }

  void handleTemperatureChange(double value) async {
    setState(() {
      _loading = true;
    });
    device.status['ct'] = value;
    bool res = await widget.api.controlDevice([
      {'id': device.id, 'ct': value}
    ]);

    if (!res) Fluttertoast.showToast(msg: widget.api.lastErrorMsg);
  }

  void handleColorChange() async {
    setState(() {
      _loading = true;
    });
    bool res = await widget.api.controlDevice([
      {'id': device.id, 'color': device.status['rgb']}
    ]);

    if (!res) Fluttertoast.showToast(msg: widget.api.lastErrorMsg);
  }

  void openColorPicker() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Couleur"),
          content: BlockPicker(
              availableColors: [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.cyan,
                Colors.indigo,
                Colors.pink[100],
                Colors.purple,
                Colors.lightGreen[300],
              ],
              pickerColor: Color(
                  int.parse(device.status['rgb'], radix: 16) + 0xFF000000),
              onColorChanged: (color) {
                setState(() {
                  device.status['rgb'] = color.toString().substring(
                      color.toString().length - 8, color.toString().length - 2);
                  handleColorChange();
                });
              }),
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
