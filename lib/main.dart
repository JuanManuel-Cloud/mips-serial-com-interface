import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'widgets/button_and_display.dart';
import 'widgets/main_button.dart';
import 'models/commands.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MIPS Debug Serial Interface'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  static const String _baudRate = '9600';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> availablePorts = [];
  String? selectedPort;

  _MyHomePageState() {
    availablePorts = SerialPort.availablePorts;
    selectedPort = availablePorts[0];
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              DropdownButton<String>(
                value: selectedPort,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: availablePorts.map((String? item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item ?? 'Port wasn\'t found'),
                  );
                }).toList(),
                onTap: () => setState(() {
                  availablePorts = SerialPort.availablePorts;
                }),
                onChanged: (String? newValue) => setState(() {
                  selectedPort = newValue;
                }),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: GridView.count(
                  childAspectRatio: 2.0,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 3,
                  children: [
                    ButtonAndDisplay(
                      color: Colors.orangeAccent,
                      onPressed: () {},
                      buttonText: '+1 Clk',
                      port: SerialPort(selectedPort!),
                      command: Commands.plusOneClk,
                    ),
                    ButtonAndDisplay(
                        color: Colors.orangeAccent,
                        onPressed: () {},
                        buttonText: 'Get PC',
                        port: SerialPort(selectedPort!),
                        command: Commands.getPc),
                    ButtonAndDisplay(
                      color: Colors.orangeAccent,
                      onPressed: () {},
                      buttonText: 'Rst PC',
                      port: SerialPort(selectedPort!),
                      command: Commands.rstPc,
                    ),
                    ButtonAndDisplay(
                      color: Colors.indigoAccent,
                      onPressed: () {},
                      buttonText: '-1 Reg ptr',
                      port: SerialPort(selectedPort!),
                      command: Commands.minusOneReg,
                    ),
                    ButtonAndDisplay(
                      color: Colors.indigoAccent,
                      onPressed: () {},
                      buttonText: 'Get Reg',
                      port: SerialPort(selectedPort!),
                      command: Commands.getReg,
                    ),
                    ButtonAndDisplay(
                      color: Colors.indigoAccent,
                      onPressed: () {},
                      buttonText: '+1 Reg ptr',
                      port: SerialPort(selectedPort!),
                      command: Commands.plusOneReg,
                    ),
                    ButtonAndDisplay(
                        color: Colors.pinkAccent,
                        onPressed: () {},
                        buttonText: '-1 Mem ptr',
                        port: SerialPort(selectedPort!),
                        command: Commands.minusOneMem),
                    ButtonAndDisplay(
                      color: Colors.pinkAccent,
                      onPressed: () {},
                      buttonText: 'Get Mem',
                      port: SerialPort(selectedPort!),
                      command: Commands.getMem,
                    ),
                    ButtonAndDisplay(
                      color: Colors.pinkAccent,
                      onPressed: () {},
                      buttonText: '+1 Mem ptr',
                      port: SerialPort(selectedPort!),
                      command: Commands.plusOneMem,
                    ),
                  ],
                ),
              ),
              MainButton(
                text: "BootLoader",
                color: Colors.greenAccent,
                command: Commands.bootloader,
                port: selectedPort!,
              ),
              MainButton(
                text: "Run",
                color: Colors.blueAccent,
                command: Commands.bootloader,
                port: selectedPort!,
              ),
              MainButton(
                text: "Flush",
                color: Colors.redAccent,
                command: Commands.bootloader,
                port: selectedPort!,
              ),
            ],
          );
        },
      ),
    );
  }
}
