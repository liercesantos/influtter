class Task {
  int? id;
   String owner;
   String name;
   String dateTime;
   String location;

  Task({
    this.id,
    required this.owner,
    required this.name,
    required this.dateTime,
    required this.location,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      dateTime: json['dateTime'],
      location: json['location'],
    );
  }

  @override
  String toString(){
    return 'id: $id, name: $name, dateTime: $dateTime, location: $location';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner,
      'name': name,
      'dateTime': dateTime,
      'location': location,
    };
  }

  Task.initial()
      : id = -1,
        owner = '',
        name = '',
        dateTime = '',
        location = '';
}
