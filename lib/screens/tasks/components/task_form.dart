import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mylocation/my.location.dart';
import 'package:oquetemprahoje/models/app_user.dart';
import 'package:oquetemprahoje/models/task.dart';
import 'package:intl/intl.dart';
import 'package:oquetemprahoje/providers/users_provider.dart';
import 'package:oquetemprahoje/utils/app_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:oquetemprahoje/providers/tasks_provider.dart';

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
  bool _loadining = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dateTimeController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _clear();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 1)),
        initialEntryMode: DatePickerEntryMode.calendarOnly);

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

      position = await MyLocation.getCurrentLocation();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        location =
            '${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao pegar o local: $e');
      }
      return null;
    }

    _locationController.text = location;

    return position;
  }

  void _populateToUpdate(TasksProvider provider) {
    if (kDebugMode) {
      print('Continua isEditing em TasksProvider? ${provider.isEditing}');
    }
    if (provider.isEditing) {
      Task task = provider.task;

      _nameController.text = task.name;
      _dateTimeController.text = task.dateTime;
      _locationController.text = task.location;
    }
  }

  bool _isValid() {
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

  void _clear() {
    _nameController.clear();
    _dateTimeController.clear();
    _locationController.clear();
  }

  void _confirmAction(TasksProvider provider, AppUser user) async {
    if (!_isValid()) {
      return;
    }
    setState(() {
      _loadining = true;
    });

    String name = _nameController.text;
    String datetime = _dateTimeController.text;
    String location = _locationController.text;

    if (provider.isEditing) {
      Task editedTask = Task(
          id: provider.task.id,
          owner: user.uid,
          name: name,
          dateTime: datetime,
          location: location);
      await provider.editTask(editedTask);

      _isUpdated(provider);
      return;
    }

    Task newTask = Task(
        owner: user.uid, name: name, dateTime: datetime, location: location);
    await provider.createTask(newTask, context);

    _isCreated(provider);
  }

  void _isCreated(TasksProvider provider) {
    setState(() {
      _loadining = false;
    });

    String title = 'Ops!';
    String message = 'Não foi possível criar a tarefa, tente novamente.';
    bool response = false;
    if (provider.created) {
      title = 'Sucesso!';
      message = 'Sua tarefa está marcada.';
      response = true;
    }

    AppDialog.show(
        context, title, message, 'OK', response ? _onSuccess : _closeDialog);
  }

  void _isUpdated(TasksProvider provider) {
    setState(() {
      _loadining = false;
    });
    String title = 'Ops!';
    String message = 'Não foi possível atualizar a tarefa, tente novamente.';
    bool response = false;

    if (provider.updated) {
      title = 'Maravilha!';
      message = 'Atualizamos a tarefa pra você.';
      response = true;
    }

    AppDialog.show(
        context, title, message, 'OK', response ? _onSuccess : _closeDialog);
  }

  void _onSuccess() {
    _clear();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/taskList',
      ModalRoute.withName('/'),
    );
  }

  void _closeDialog() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final taskProvider = Provider.of<TasksProvider>(context);

    _populateToUpdate(taskProvider);
    return _loadining
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
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
                  Ink(
                    height: 32.0,
                    width: 32.0,
                    decoration: const ShapeDecoration(
                      color: Colors.blue,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.location_on,
                        size: 16.0,
                      ),
                      color: Colors.white,
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () =>
                    {_confirmAction(taskProvider, userProvider.user)},
                child: Text(taskProvider.isEditing
                    ? 'Atualizar Tarefa'
                    : 'Adicionar Tarefa'),
              ),
            ],
          );
  }
}
