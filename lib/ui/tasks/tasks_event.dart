import 'package:equatable/equatable.dart';
import 'package:todo/data/local/model/task.dart';

abstract class TasksEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TasksEvent {}

class MarkDoneTasksEvent extends TasksEvent {
  final Task task;

  MarkDoneTasksEvent(this.task);

  @override
  List<Object> get props => [task];
}

class MarkNotDoneTasksEvent extends TasksEvent {
  final Task task;

  MarkNotDoneTasksEvent(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTasksEvent extends TasksEvent {
  final Task task;

  DeleteTasksEvent(this.task);

  @override
  List<Object> get props => [task];
}

class SaveTasksEvent extends TasksEvent {
  final String title;

  SaveTasksEvent(this.title);

  @override
  List<Object> get props => [title];
}