import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:influtter/models/task.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskForm createState() => _TaskForm();
}

class _TaskForm extends State<TaskForm> {
  late TextEditingController _nameController;
  late TextEditingController _dateTimeController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateTimeController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

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
    String location = 'N/E';

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
        location =
            '${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}';
      }
    } catch (e) {
      print('Erro ao obter a localização: $e');
      return null;
    }

    _locationController.text = location;

    return position;
  }

  bool isValid() {
    bool criteria = (_nameController.text.isEmpty ||
        _dateTimeController.text.isEmpty ||
        _locationController.text.isEmpty);

    if (criteria) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content:
                const Text('Por favor, preencha todos os campos obrigatórios.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }

    return true;
  }

  void clear() {
    _nameController.clear();
    _dateTimeController.clear();
    _locationController.clear();
  }

  void confirmAction(TasksProvider provider) {
    if (!isValid()) {
      return;
    }

    String name = _nameController.text;
    String datetime = _dateTimeController.text;
    String location = _locationController.text;

    if (provider.isEditing) {
      provider
          .editTask(Task(name: name, dateTime: datetime, location: location));
      clear();
      return;
    }

    provider.createTask(name, datetime, location);
    clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasksProvider>(context);

    if (provider.isEditing) {
      Task task = provider.task;
      _nameController.text = task.name;
      _dateTimeController.text = task.dateTime;
      _locationController.text = task.location;
    }

    return Column(
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Tarefa',
          ),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _dateTimeController,
          onTap: () {
            _selectDateTime(context);
          },
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Data e Hora',
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Local',
              ),
            )),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Local Atual'),
            )
          ],
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => {confirmAction(provider)},
          child: Text(
              provider.isEditing ? 'Atualizar Tarefa' : 'Adicionar Tarefa'),
        ),
      ],
    );
  }
}
