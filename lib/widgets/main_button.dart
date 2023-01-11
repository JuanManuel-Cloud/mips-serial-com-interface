import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import '../models/commands.dart';

class MainButton extends StatelessWidget {
  final Color color;
  final String text;
  final String port;
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
        onPressed: () => _sendSerialData(SerialPort(port), command),
        child: Text(
          text,
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  Future<void> _sendSerialData(SerialPort port, Commands command) async {
    try {
      port.openWrite();
      var char = _getCharFromCommand(command);
      port.write(Uint8List.fromList(utf8.encode(char)));
      if (char == 'B') {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          File file = File(result.files.single.path!);
          port.write(Uint8List.fromList(file.readAsBytesSync()));
        } else {
          print('The user did not select any file');
        }
      }
    } catch (err, _) {
      print(SerialPort.lastError);
    }
    port.close();
  }

  String _getCharFromCommand(Commands command) {
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
