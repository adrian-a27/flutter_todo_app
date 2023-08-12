import "package:flutter/material.dart";
import 'task.dart';

class TaskGroup extends StatelessWidget {
  const TaskGroup({
    super.key,
    required this.heading,
    required this.tasks,
  });

  final String heading;

  // TODO: Figure out type
  final List<String> tasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(heading,
                      style: Theme.of(context).textTheme.headlineSmall)),
              Text(tasks.length.toString(),
                  style: Theme.of(context).textTheme.headlineSmall)
            ],
          ),
          for (var task in tasks) Task(name: task)
        ],
      ),
    );
  }
}
