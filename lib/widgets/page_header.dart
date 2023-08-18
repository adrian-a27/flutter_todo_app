import "package:flutter/material.dart";

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitile;

  const PageHeader({super.key, required this.title, this.subtitile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.headlineLarge)),
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                print('button pressed');
              },
            )
          ],
        ),
        if (subtitile != null)
          Row(children: [
            Text(
              subtitile!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ])
      ]),
    );
  }
}
