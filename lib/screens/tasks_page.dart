import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/task_group.dart';
import '../widgets/task.dart';

class TasksPage extends StatelessWidget {
  final taskGroups = [
    TaskGroup(heading: "Today", tasks: [
      Task(name: "This is a task"),
      Task(name: "This is another task"),
      Task(name: "Finish the other tasks")
    ]),
    TaskGroup(heading: "Tomorrow", tasks: [
      Task(name: "Just do the other stuff first"),
      Task(name: "Don't worry about this")
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: "Tasks",
        ),
        Expanded(
          child: ListView.builder(
            itemCount: taskGroups.length,
            itemBuilder: (BuildContext context, int index) {
              return taskGroups[index];
            },
          ),
        )
      ],
    );
  }
}
