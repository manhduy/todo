import 'package:todo/data/local/model/task.dart';

import '../local/db/database.dart';

class TasksRepository {

  final TaskDatabase _taskDb;

  TasksRepository(this._taskDb);

  List<Task> getTasks() {
    return _taskDb.getTasks();
  }

  Future<void> createTask(String title) async {
    final task = Task(title: title, done: false);
    _taskDb.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    _taskDb.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    _taskDb.deleteTask(task);
  }
}