import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:libserialport/libserialport.dart';
import '../models/commands.dart';

class ButtonAndDisplay extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color color = Colors.blue;
  final SerialPort port;
  final Commands command;

  const ButtonAndDisplay({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.port,
    required this.command,
    color,
  });

  @override
  State<ButtonAndDisplay> createState() => _ButtonAndDisplayState();
}

class _ButtonAndDisplayState extends State<ButtonAndDisplay> {
  String tmpValue = '';
  String value = '';

  @override
  Widget build(BuildContext context) {
    widget.port.openReadWrite();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: widget.color,
              minimumSize: const Size.fromHeight(1),
              padding: const EdgeInsets.all(64.0),
              textStyle: const TextStyle(
                fontSize: 24,
              ),
            ),
            onPressed: () {
              _sendSerialData(widget.port, widget.command);
              _receiveSerialData(widget.port);
            },
            child: Text(
              widget.buttonText,
            ),
          ),
          Text(
            'Value: $value',
            style: const TextStyle(fontSize: 32.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.port.close();
    super.dispose();
  }

  void _sendSerialData(SerialPort port, Commands command) {
    try {
      port.write(Uint8List.fromList(utf8.encode(_getCharFromCommand(command))));
    } catch (err, _) {
      print(SerialPort.lastError);
    }
    port.close();
  }

  void _receiveSerialData(SerialPort port) {
    try {
      SerialPortReader reader = SerialPortReader(port);
      Stream<String> upCommingData = reader.stream.map((data) {
        return String.fromCharCodes(data);
      });

      upCommingData.listen((byte) {
        tmpValue.length == 4
            ? setState(() {
                value = tmpValue;
                tmpValue = '';
              })
            : tmpValue += byte;
      });
    } catch (err, _) {
      print(SerialPort.lastError);
    }
  }

  String _getCharFromCommand(Commands command) {
    switch (command) {
      case Commands.plusOneClk:
        return 'S';
      case Commands.getPc:
        return 'P';
      case Commands.rstPc:
        return 'C';
      case Commands.minusOneReg:
        return 'E';
      case Commands.getReg:
        return 'R';
      case Commands.plusOneReg:
        return 'T';
      case Commands.minusOneMem:
        return 'N';
      case Commands.getMem:
        return 'M';
      case Commands.plusOneMem:
        return ',';
      default:
        return '';
    }
  }
}
