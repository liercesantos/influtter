import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  List<Task> _tasks = [];
  int _editingIndex = -1;

  void _addTask() {
    String name = _nameController.text;
    String dateTime = _dateTimeController.text;
    String location = _locationController.text;

    setState(() {
      if (_editingIndex != -1) {
        _tasks[_editingIndex] = Task(
          name: name,
          dateTime: dateTime,
          location: location,
        );
        _editingIndex = -1;
      } else {
        _tasks.add(
          Task(
            name: name,
            dateTime: dateTime,
            location: location,
          ),
        );
      }

      _nameController.clear();
      _dateTimeController.clear();
      _locationController.clear();
    });
  }

  void _editTask(int index) {
    Task task = _tasks[index];
    _nameController.text = task.name;
    _dateTimeController.text = task.dateTime;
    _locationController.text = task.location;

    setState(() {
      _editingIndex = index;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
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

  Future<void> _getCurrentLocation() async {
    Position position;

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error: $e');
      return;
    }

    final List<Placemark> placemarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude);

    final Placemark placemark = placemarks.first;
    final String address =
        '${placemark.thoroughfare}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';

    setState(() {
      _locationController.text = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Task',
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
            labelText: 'Date and Time',
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location',
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          child: Text(_editingIndex != -1 ? 'Update Task' : 'Add Task'),
          onPressed: _addTask,
        ),
        ElevatedButton(
          child: Text('Get Current Location'),
          onPressed: _getCurrentLocation,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              Task task = _tasks[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date and Time: ${task.dateTime}'),
                    Text('Location: ${task.location}'),
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
    );
  }
}
