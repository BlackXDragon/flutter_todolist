import 'tag.dart';

class Task {
  String title = '';
  String description = '';
  DateTime deadline;
  List tags = [];

  Task(String title, {String description = '', DateTime deadline, tags}) {
    this.title = title;
    this.description = description;
    this.deadline = deadline;
    this.tags = (tags != null) ? tags : [];
  }

  Task.fromJSON(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    deadline =
        (json['deadline'] == 'null') ? null : DateTime.parse(json['deadline']);
    tags = (json['tags'].map((t) => Tag.fromJSON(t)).toList());
  }

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toString(),
      'tags': (tags != [])
          ? tags.map((t) => (t != null) ? t.toJSON() : null).toList()
          : []
    };
  }

  String toString() {
    return '<Task ' + this.title + ',' + this.description + ',' + this.deadline.toString() + ',' + this.tags.toString() + '>';
  }

  static Task fromString(String taskstring) {
    var values = taskstring.split(',');
    return new Task(values[0],
        description: values[1],
        deadline: (values[2] == 'null') ? null : DateTime.parse(values[2]));
  }
}
