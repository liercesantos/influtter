import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TaskCreationScreen extends StatefulWidget {
  final Function(String, String, String) onAddTask;

  const TaskCreationScreen({Key? key, required this.onAddTask})
      : super(key: key);

  @override
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
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
      // ignore: use_build_context_synchronously
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
    String newTask = _nameController.text;
    String newDateTime = _dateTimeController.text;
    String newLocation = _locationController.text;

    if (newTask.isEmpty || newDateTime.isEmpty || newLocation.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, preencha todos os campos obrigatórios.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    widget.onAddTask(newTask, newDateTime, newLocation);

    _nameController.clear();
    _dateTimeController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
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
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Local',
                ),
              )),
              ElevatedButton(
                child: Text('Local Atual'),
                onPressed: _getCurrentLocation,
              )
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Adicionar Tarefa'),
            onPressed: _addTask,
          ),
        ],
      ),
    );
  }
}
