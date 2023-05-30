import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/task.dart';

class TaskCreationScreen extends StatelessWidget {
  const TaskCreationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _dateTimeController = TextEditingController();
    TextEditingController _locationController = TextEditingController();

    Future<void> _selectDateTime(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

      if (picked != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final DateTime selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          final formattedDateTime =
              DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);

          _dateTimeController.text = formattedDateTime;
        }
      }
    }

    Future<Position?> _getCurrentLocation() async {
      Position position;
      String _location = 'N/E';

      try {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }

        position = await Geolocator.getCurrentPosition();

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          print(placemarks);
          _location =
              '${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}';
        }
      } catch (e) {
        print('Erro ao obter a localização: $e');
        return null;
      }

      _locationController.text = _location;

      return position;
    }

    void _addTask() {
      String name = _nameController.text;
      String dateTime = _dateTimeController.text;
      String location = _locationController.text;

      Navigator.pop(
        context,
        Task(
          name: name,
          dateTime: dateTime,
          location: location,
        ),
      );
    }

    return Container(
      key: key,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Tarefa',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _dateTimeController,
            onTap: () {
              _selectDateTime(context);
            },
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Data e Hora',
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Local',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Adicionar Tarefa'),
            onPressed: _addTask,
          ),
          ElevatedButton(
            child: Text('Local Atual'),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
    );
  }
}
