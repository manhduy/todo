import '../model/task.dart';

class TaskDatabase {

  List<Task> tasks = [];

  void insertTask(Task task) {
    task.id = tasks.length;
    tasks.add(task);
  }

  List<Task> getTasks() {
    return tasks;
  }

  void updateTask(Task task) {
    final index = tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    }
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }
}