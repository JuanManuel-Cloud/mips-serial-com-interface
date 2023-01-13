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
              _sendSerialData();
              _receiveSerialData();
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

  void _sendSerialData() {
    if (widget.port.isOpen) widget.port.close();

    widget.port.open(mode: SerialPortMode.write);

    try {
      widget.port.write(Uint8List.fromList(utf8.encode(_getCharFromCommand())));
      widget.port.drain();
    } catch (err, _) {
      print(SerialPort.lastError);
    }
  }

  void _receiveSerialData() {
    try {
      if (widget.port.isOpen) widget.port.close();
      widget.port.open(mode: SerialPortMode.read);

      SerialPortReader reader = SerialPortReader(widget.port);
      Stream<String> upCommingData = reader.stream.map((data) {
        return String.fromCharCodes(data);
      });

      upCommingData.listen((byte) {
        print('byte leído: $byte');
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

  String _getCharFromCommand() {
    switch (widget.command) {
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
