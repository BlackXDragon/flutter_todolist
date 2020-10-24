class Task {
  String title = '';
  String description = '';
  DateTime deadline;

  Task(String title, {String description = '', DateTime deadline}) {
    this.title = title;
    this.description = description;
    this.deadline = deadline;
  }

  String toString() {
    return this.title + ',' + this.description + ',' + this.deadline.toString();
  }

  
  static Task fromString(String taskstring) {
    var values = taskstring.split(',');
    return new Task(values[0], description: values[1], deadline: (values[2] == 'null')? null : DateTime.parse(values[2]));
  }
}