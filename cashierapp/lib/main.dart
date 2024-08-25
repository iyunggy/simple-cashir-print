// ignore_for_file: sort_child_properties_last

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevice();
  }

  void getDevice() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thermal Printer Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<BluetoothDevice>(
                  value: selectedDevice,
                  hint: const Text('Select Thermal Printer'),
                  onChanged: (device) {
                    setState(() {
                      selectedDevice = device;
                    });
                  },
                  items: devices
                      .map((e) => DropdownMenuItem(
                            child: Text(e.name!),
                            value: e,
                          ))
                      .toList()),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    printer.connect(selectedDevice!);
                  },
                  child: const Text('Connect')),
              ElevatedButton(
                  onPressed: () {
                    printer.disconnect();
                  },
                  child: const Text('Disconnect')),
              ElevatedButton(
                  onPressed: () async {
                    if ((await printer.isConnected)!) {
                      printer.printNewLine();
                      // size
                      // 0: Normal
                      // 1: Normal Bold
                      // 2: Medium Bold
                      // 3: Large Bold

                      // align
                      // 0: left
                      // 1: center
                      // 2: right
                      printer.printCustom('Thermal Printer Demo', 0, 1);
                      printer.printQRcode('Thhermal Printer Dem', 200, 200, 1);
                      printer.printNewLine();
                      printer.printNewLine();
                    }
                  },
                  child: const Text('Print'))
            ],
          ),
        ));
  }
}
