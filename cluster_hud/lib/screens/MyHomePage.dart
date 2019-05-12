import 'package:cluster_hud/state/bluetooth_connectivity.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothDevice _device;
  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems(
      List<BluetoothDevice> deviceList) {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (deviceList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      deviceList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  _getMessages(List<String> resps) {
    return ListView.builder(
      itemCount: resps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(resps[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bleConnectivity = Provider.of<BluetoothState>(context);
    TextEditingController _msgEdit = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'DevAddress: ${bleConnectivity.curDevice != null ? bleConnectivity.curDevice.address : "none"}',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Device:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton(
                  items: _getDeviceItems(bleConnectivity.devices),
                  onChanged: (value) {
                    print("New value: $value");
                    setState(() => _device = value);
                  },
                  value: _device,
                ),
                RaisedButton(
                  onPressed: () {
                    if (!bleConnectivity.isConnected) {
                      print(
                          "Connect pressed { ${bleConnectivity.isConnected} ");
                      bleConnectivity.connectToDevice(_device);
                    } else {
                      print(
                          "Disconnect pressed!{ ${bleConnectivity.isConnected} ");
                      bleConnectivity.disconnect();
                    }
                  },
                  child: Text(
                      bleConnectivity.isConnected ? 'Disconnect' : 'Connect'),
                ),
              ],
            ),
            Text(
              bleConnectivity.isConnected ? "CONNECTED!" : "NOT CONNECTED :C",
            ),
            TextFormField(
              controller: _msgEdit,
            ),
            Expanded(child: _getMessages(bleConnectivity.responses))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bleConnectivity.sendMessage(_msgEdit.text);
        },
        tooltip: 'Send Message',
        child: Icon(Icons.add),
      ),
    );
  }
}
