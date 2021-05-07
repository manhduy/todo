import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/data/local/model/task.dart';
import 'package:todo/data/repository/tasks_repository.dart';
import 'package:todo/ui/tasks/tasks_bloc.dart';
import 'package:todo/ui/tasks/tasks_event.dart';
import 'package:todo/ui/tasks/tasks_state.dart';

class MockTasksRepository extends Mock implements TasksRepository {}

void main() {

  final task = Task(id: 1, title: 'Test task', done: false);
  final tasks = [task];
  final title = 'New task title';

  group('TaskBloc', () {
    MockTasksRepository tasksRepository;
    TasksBloc tasksBloc;

    setUp(() {
      tasksRepository = MockTasksRepository();
      tasksBloc = TasksBloc(tasksRepository);
    });

    tearDown(() {
      tasksBloc.close();
    });

    test('TaskBloc has correct initialState', () {
      expect(tasksBloc.state, InitState());
    });

    group('GetTasksEvent', () {
      blocTest('Emit TasksLoadedState when repository return tasks',
          build: () {
            when(tasksRepository.getTasks()).thenAnswer((_) => tasks);
            return tasksBloc;
          },
          act: (bloc) => bloc.add(GetTasksEvent()),
          expect: [TasksLoadedState(tasks)]
      );

      blocTest('Emit EmptyTaskState when repository return empty',
          build: () {
            when(tasksRepository.getTasks()).thenAnswer((_) => []);
            return tasksBloc;
          },
          act: (bloc) => bloc.add(GetTasksEvent()),
          expect: [EmptyTaskState()]
      );
    });

    group('SaveTasksEvent', () {

      blocTest('Call create task in repository',
          build: () {
            when(tasksRepository.getTasks()).thenAnswer((_) => []);
            return tasksBloc;
          },
          act: (bloc) => bloc.add(SaveTasksEvent(title)),
          verify: (_) {
            verify(tasksRepository.createTask(title)).called(1);
          }
      );
    });

    group('CompleteTasksEvent', () {

      blocTest('Call update task in repository',
          build: () {
            when(tasksRepository.getTasks()).thenAnswer((_) => []);
            return tasksBloc;
          },
          act: (bloc) => bloc.add(MarkDoneTasksEvent(task)),
          verify: (_) {
            verify(tasksRepository.updateTask(task)).called(1);
            expect(task.done, true);
          }
      );
    });

    group('IncompleteTasksEvent', () {

      blocTest('Call update task in repository',
          build: () {
            when(tasksRepository.getTasks()).thenAnswer((_) => []);
            return tasksBloc;
          },
          act: (bloc) => bloc.add(MarkNotDoneTasksEvent(task)),
          verify: (_) {
            verify(tasksRepository.updateTask(task)).called(1);
            expect(task.done, false);
          }
      );
    });

  });
}