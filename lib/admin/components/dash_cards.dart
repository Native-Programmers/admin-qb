import 'package:flutter/material.dart';

class DashCards extends StatelessWidget {
  String name, length;
  DashCards({Key? key, required this.name, required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[100],
      ),
      margin: const EdgeInsets.only(right: 25),
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      width: 200,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(
              length,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          FittedBox(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
