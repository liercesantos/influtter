import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

      _locationController.text = address;
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
            child: Text('Add Task'),
            onPressed: _addTask,
          ),
          ElevatedButton(
            child: Text('Get Current Location'),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
    );
  }
}
