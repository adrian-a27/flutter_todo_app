import "package:flutter/material.dart";

class Task extends StatelessWidget {
  const Task({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(children: [
          Checkbox(
              value: false,
              onChanged: (isChecked) => {print('$name checkbox: $isChecked')}),
          Expanded(child: Text(name))
        ]),
      ),
    );
  }
}
