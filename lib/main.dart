import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/di/di.dart';
import 'package:todo/ui/tasks/tasks_bloc.dart';
import 'package:todo/ui/tasks/tasks_event.dart';
import 'package:todo/ui/tasks/tasks_page.dart';

void main() async {
  registerDependencies();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('vi', 'VN')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: App()
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr('app.title'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<TasksBloc>(
        create: (_) => getIt.get<TasksBloc>()..add(GetTasksEvent()),
        child: TasksPage(),
      ),
    );
  }
}
