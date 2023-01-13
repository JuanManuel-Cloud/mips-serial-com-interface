import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:libserialport/src/config.dart';
import '../models/commands.dart';

class MainButton extends StatelessWidget {
  final Color color;
  final String text;
  final SerialPort port;
  final Commands command;

  const MainButton({
    Key? key,
    this.color = Colors.blue,
    required this.port,
    required this.text,
    required this.command,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(1),
          backgroundColor: color,
        ),
        onPressed: () => _sendSerialData(),
        child: Text(
          text,
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Future<void> _sendSerialData() async {
    try {
      if (port.isOpen) port.close();
      port.open(mode: SerialPortMode.write);

      var char = _getCharFromCommand();
      Uint8List dataToSend;
      var charWrited = port.write(_stringToUint8List(char));
      print('charWrited: $charWrited');
      port.drain();

      if (command == Commands.bootloader) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          var filteBytes = File(result.files.single.path!).readAsBytesSync();
          var fileWritedBytes = port.write(filteBytes);
          port.drain();
          print('fileWritedBytes: $fileWritedBytes');
        } else {
          print('The user did not select any file');
        }
      }
    } catch (err, _) {
      print(SerialPort.lastError);
    }
  }

  Uint8List _stringToUint8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }

  String _getCharFromCommand() {
    switch (command) {
      case Commands.bootloader:
        return 'B';
      case Commands.run:
        return 'G';
      case Commands.flush:
        return 'F';
      default:
        return '';
    }
  }
}
