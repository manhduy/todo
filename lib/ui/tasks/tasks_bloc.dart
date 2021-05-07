import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/local/model/task.dart';
import 'package:todo/data/repository/tasks_repository.dart';
import 'package:todo/ui/tasks/tasks_event.dart';
import 'package:todo/ui/tasks/tasks_state.dart';

import 'tasks_event.dart';
import 'tasks_event.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {

  final TasksRepository _tasksRepository;

  TasksBloc(this._tasksRepository) : super(InitState());

  @override
  Stream<TasksState> mapEventToState(TasksEvent event) async* {
    if (event is GetTasksEvent) {
      yield* _mapGetTasksEventToState();
    } else if (event is SaveTasksEvent) {
      yield* _mapSaveTaskEventToState(event);
    } else if (event is MarkDoneTasksEvent) {
      yield* _mapDoneTaskEventToState(event);
    } else if (event is MarkNotDoneTasksEvent) {
      yield* _mapNotDoneTaskEventToState(event);
    } else if (event is DeleteTasksEvent) {
      yield* _mapDeleteTaskEventToState(event);
    }
  }

  Stream<TasksState> _mapGetTasksEventToState() async* {
    List<Task> tasks = _tasksRepository.getTasks();
    if (tasks.isEmpty) {
      yield EmptyTaskState();
    } else {
      yield TasksLoadedState(tasks);
    }
  }

  Stream<TasksState> _mapSaveTaskEventToState(SaveTasksEvent event) async* {
    _tasksRepository.createTask(event.title);
    yield* _mapGetTasksEventToState();
  }

  Stream<TasksState> _mapDoneTaskEventToState(MarkDoneTasksEvent event) async* {
    final task = event.task;
    task.done = true;
    _tasksRepository.updateTask(task);
    yield* _mapGetTasksEventToState();
  }

  Stream<TasksState> _mapNotDoneTaskEventToState(MarkNotDoneTasksEvent event) async* {
    final task = event.task;
    task.done = false;
    _tasksRepository.updateTask(task);
    yield* _mapGetTasksEventToState();
  }

  Stream<TasksState> _mapDeleteTaskEventToState(DeleteTasksEvent event) async* {
    _tasksRepository.deleteTask(event.task);
    yield* _mapGetTasksEventToState();
  }
}