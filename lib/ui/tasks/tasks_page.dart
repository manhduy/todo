import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/local/model/task.dart';
import 'package:todo/ui/tasks/tasks_bloc.dart';
import 'package:todo/ui/tasks/tasks_event.dart';
import 'package:todo/ui/tasks/tasks_state.dart';
import 'package:todo/extension/state_extensions.dart';

import 'tasks_event.dart';

class TasksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksBloc>(context).listen((state) {
      if (state is TasksErrorState) {
        final msg = tr(state.msg);
        showMessage(msg);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('tasks.title')),
      ),
      body: _tasksWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTap,
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _tasksWidget() {
    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is EmptyTaskState) {
          return _emptyWidget();
        } else {
          final tasks = (state is TasksLoadedState) ? state.tasks : [];
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index].title),
                leading: _statusWidget(tasks[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _onDeleteTap(tasks[index]),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _emptyWidget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/ic_empty.png', width: 120, height: 120,
            fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(tr('tasks.empty_task_list'), textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }

  Widget _statusWidget(Task task) {
    if (task.done) {
      return IconButton(
        icon: Icon(Icons.check, color: Colors.green,),
        onPressed: () => _onDoneTasksItemCheck(task),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.radio_button_unchecked),
        onPressed: () => _onNotDoneTasksItemCheck(task),
      );
    }
  }

  void _onAddTap() {
    final taskEdtCtrl = TextEditingController();
    var btnSaveEnable = false;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return Container(
                    margin: EdgeInsets.all(16),
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          minLines: 1,
                          maxLines: 1,
                          controller: taskEdtCtrl,
                          onChanged: (value) {
                            setState(() {
                              btnSaveEnable = value.trim().isNotEmpty;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: tr('tasks.new_task'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: btnSaveEnable ? () {
                                Navigator.pop(context);
                                _onSaveTaskTap(taskEdtCtrl.text.trim());
                              }
                              : null,
                              child: Text(tr('tasks.save'),
                                style: TextStyle(
                                    color: btnSaveEnable ? Colors.blue : Colors.grey,
                                    fontSize: 16),)
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),
            )
          ],
        );
      },
    );
  }

  void _onDoneTasksItemCheck(Task task) {
    BlocProvider.of<TasksBloc>(context).add(MarkNotDoneTasksEvent(task));
  }

  void _onNotDoneTasksItemCheck(Task task) {
    BlocProvider.of<TasksBloc>(context).add(MarkDoneTasksEvent(task));
  }

  void _onSaveTaskTap(String title) {
    if (title.isNotEmpty)
      BlocProvider.of<TasksBloc>(context).add(SaveTasksEvent(title));
  }

  void _onDeleteTap(task) {
    BlocProvider.of<TasksBloc>(context).add(DeleteTasksEvent(task));
  }
}