import 'dart:convert';

class Task {
  String title;
  String description;
  bool isDone;

  Task({required this.title, required this.description, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'isDone': isDone};
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(jsonDecode(source));
}
