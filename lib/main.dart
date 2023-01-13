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
  final SerialPortConfig serialPortConfig = SerialPortConfig();
  final SerialPort com4 = SerialPort('COM4');
  List<String> availablePorts = [];
  String? selectedPort;
  SerialPort? port;

  _MyHomePageState() {
    serialPortConfig.baudRate = 9600;
    serialPortConfig.bits = 8;
    serialPortConfig.stopBits = 1;
    serialPortConfig.parity = 0;
    serialPortConfig.xonXoff = 0;
    serialPortConfig.setFlowControl(0);
    serialPortConfig.dtr = 0;
    serialPortConfig.rts = 0;

    com4.config = serialPortConfig;

    availablePorts = SerialPort.availablePorts;
    selectedPort = availablePorts[0];
    port = SerialPort(selectedPort!);
    port?.config = serialPortConfig;
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
                      port: com4,
                      command: Commands.plusOneClk,
                    ),
                    ButtonAndDisplay(
                        color: Colors.orangeAccent,
                        onPressed: () {},
                        buttonText: 'Get PC',
                        port: com4,
                        command: Commands.getPc),
                    ButtonAndDisplay(
                      color: Colors.orangeAccent,
                      onPressed: () {},
                      buttonText: 'Rst PC',
                      port: com4,
                      command: Commands.rstPc,
                    ),
                    ButtonAndDisplay(
                      color: Colors.indigoAccent,
                      onPressed: () {},
                      buttonText: '-1 Reg ptr',
                      port: com4,
                      command: Commands.minusOneReg,
                    ),
                    ButtonAndDisplay(
                      color: Colors.indigoAccent,
                      onPressed: () {},
                      buttonText: 'Get Reg',
                      port: com4,
                      command: Commands.getReg,
                    ),
                    ButtonAndDisplay(
                      color: Colors.indigoAccent,
                      onPressed: () {},
                      buttonText: '+1 Reg ptr',
                      port: com4,
                      command: Commands.plusOneReg,
                    ),
                    ButtonAndDisplay(
                        color: Colors.pinkAccent,
                        onPressed: () {},
                        buttonText: '-1 Mem ptr',
                        port: com4,
                        command: Commands.minusOneMem),
                    ButtonAndDisplay(
                      color: Colors.pinkAccent,
                      onPressed: () {},
                      buttonText: 'Get Mem',
                      port: com4,
                      command: Commands.getMem,
                    ),
                    ButtonAndDisplay(
                      color: Colors.pinkAccent,
                      onPressed: () {},
                      buttonText: '+1 Mem ptr',
                      port: com4,
                      command: Commands.plusOneMem,
                    ),
                  ],
                ),
              ),
              MainButton(
                text: "BootLoader",
                color: Colors.greenAccent,
                command: Commands.bootloader,
                port: com4,
              ),
              MainButton(
                text: "Run",
                color: Colors.blueAccent,
                command: Commands.run,
                port: com4,
              ),
              MainButton(
                text: "Flush",
                color: Colors.redAccent,
                command: Commands.flush,
                port: com4,
              ),
            ],
          );
        },
      ),
    );
  }
}
