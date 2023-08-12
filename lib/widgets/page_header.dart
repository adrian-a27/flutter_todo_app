import "package:flutter/material.dart";

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(text, style: Theme.of(context).textTheme.displaySmall)),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              print('button pressed');
            },
          ),
        ],
      ),
    );
  }
}
