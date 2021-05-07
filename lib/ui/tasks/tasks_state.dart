import 'package:equatable/equatable.dart';
import 'package:todo/data/local/model/task.dart';

abstract class TasksState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitState extends TasksState {}

class EmptyTaskState extends TasksState {}

class TasksLoadedState extends TasksState {
  final List<Task> tasks;

  TasksLoadedState(this.tasks);

  @override
  List<Object> get props => [DateTime.now()];
}

class TasksErrorState extends TasksState {
  final String msg;

  TasksErrorState(this.msg);

  @override
  List<Object> get props => [msg];

  @override
  String toString() {
    return "TasksErrorState: msg = $msg";
  }
}
