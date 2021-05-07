import 'package:get_it/get_it.dart';
import 'package:todo/data/local/db/database.dart';
import 'package:todo/data/repository/tasks_repository.dart';
import 'package:todo/ui/tasks/tasks_bloc.dart';
import '../data/local/db/database.dart';

final getIt = GetIt.instance;

void registerDependencies() {
  getIt.registerSingleton<TaskDatabase>(TaskDatabase());
  
  getIt.registerFactory<TasksRepository>(()  {
    final taskDb = getIt.get<TaskDatabase>();
    return TasksRepository(taskDb);
  });

  getIt.registerFactory<TasksBloc>(() {
    final tasksRepository = getIt.get<TasksRepository>();
    return TasksBloc(tasksRepository);
  });
}