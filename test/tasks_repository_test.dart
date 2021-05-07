import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/data/local/model/task.dart';
import 'package:todo/data/repository/tasks_repository.dart';
import 'package:todo/data/local/db/database.dart';

class MockTasksDatabase extends Mock implements TaskDatabase {}

void main() {

  final task = Task(id: 1, title: 'Test task', done: false);
  final tasks = [task];
  final title = 'New task title';

  group('TasksRepository', () {
    MockTasksDatabase taskDb;
    TasksRepository tasksRepository;

    setUp(() {
      taskDb = MockTasksDatabase();
      tasksRepository = TasksRepository(taskDb);
    });

    tearDown(() {
    });

    test('getTasks return task when db return task', () async {
      when(taskDb.getTasks()).thenAnswer((_) => tasks);
      var result = tasksRepository.getTasks();
      expect(result, tasks);
    });

    test('createTask call insert task in db', () async {
      tasksRepository.createTask(title);
      verify(taskDb.insertTask(any)).called(1);
    });

    test('updateTask call update task in db', () async {
      tasksRepository.updateTask(task);
      verify(taskDb.updateTask(task)).called(1);
    });

  });
}