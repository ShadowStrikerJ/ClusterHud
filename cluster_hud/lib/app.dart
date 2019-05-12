import 'package:cluster_hud/screens/BluetoothApp.dart';
import 'package:cluster_hud/state/bluetooth_connectivity.dart';
import 'package:provider/provider.dart';
import 'package:cluster_hud/screens/MyHomePage.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        child: MyHomePage(),
        builder: (BuildContext context) {
          return BluetoothState();
        },
      ),
    );
  }
}
