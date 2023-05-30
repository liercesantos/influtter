import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  final Function(String, String, String) onAddTask;
  final Function(int, Task) onEditTask;
  final List<Task> tasks;

  TaskScreen(
      {Key? key,
      required this.onAddTask,
      required this.onEditTask,
      required this.tasks})
      : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  int _editingIndex = -1;

  void _prepareTask() {
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

    if (_editingIndex != -1) {
      widget.onEditTask(
          _editingIndex,
          Task(
              name: _nameController.text,
              dateTime: _dateTimeController.text,
              location: _locationController.text));
    } else {
      widget.onAddTask(newTask, newDateTime, newLocation);
    }

    _nameController.clear();
    _dateTimeController.clear();
    _locationController.clear();
    _editingIndex = -1;
  }

  void _editTask(int index) {
    Task task = widget.tasks[index];

    setState(() {
      _nameController.text = task.name;
      _dateTimeController.text = task.dateTime;
      _locationController.text = task.location;
      _editingIndex = index;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _nameController.clear();
        _dateTimeController.clear();
        _locationController.clear();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          key: widget.key,
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
              child: Text(_editingIndex != -1
                  ? 'Atualizar Tarefa'
                  : 'Adicionar Tarefa'),
              onPressed: _prepareTask,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.tasks.length,
                itemBuilder: (context, index) {
                  Task task = widget.tasks[index];
                  return ListTile(
                    title: Text(task.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Data e Hora: ${task.dateTime}'),
                        Text('Local: ${task.location}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editTask(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
