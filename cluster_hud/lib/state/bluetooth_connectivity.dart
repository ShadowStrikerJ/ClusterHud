import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothState with ChangeNotifier {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> devices;
  bool isConnected = false;
  BluetoothDevice curDevice;
  List<String> responses;

  BluetoothState() {
    responses = [];
    devices = [];
    getBondedDevices();
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          isConnected = true;
          notifyListeners();

          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          isConnected = false;
          notifyListeners();
          break;

        default:
          print("Bluetooth State: $state");
          break;
      }
    });

    bluetooth.onRead().listen((data) {
      print("Bluetooth: { GOT DATA: $data }");
      responses.add(data);
      notifyListeners();
    });
  }

  void getBondedDevices() async {
    print("Bluetooth: { Getting Bonded Devices }");
    try {
      devices = await bluetooth.getBondedDevices();
      print("Bluetooth: { Devices: $devices }");
      notifyListeners();
    } on PlatformException {
      print("Bluetooth: Error getting bonded devices");
    }
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    if (device == null) {
      return false;
    }

    bool connectedState = await bluetooth.isConnected;
    if (!connectedState) {
      try {
        curDevice =
            await bluetooth.connect(device).timeout(Duration(seconds: 10));
        isConnected = true;

        print("Bluetooth: Connecting to $curDevice");
        notifyListeners();
      } catch (err) {
        isConnected = false;
        notifyListeners();
        print(err);
      }
    }
    return false;
  }

  void disconnect() async {
    // Method to disconnect bluetooth
    bluetooth.disconnect();
    curDevice = null;
    isConnected = false;
    notifyListeners();
  }

  void sendMessage(String msg) async {
    bluetooth.write(msg);
  }
}
