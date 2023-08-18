import "package:flutter/material.dart";
import 'task.dart';

class TaskGroup extends StatelessWidget {
  final String heading;
  final List<Task> tasks;

  const TaskGroup({
    super.key,
    required this.heading,
    required this.tasks,
  });

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
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Text(tasks.length.toString(),
                  style: Theme.of(context).textTheme.headlineSmall)
            ],
          ),
          for (Task task in tasks) task
        ],
      ),
    );
  }
}
