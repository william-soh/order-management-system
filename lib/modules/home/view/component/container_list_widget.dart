import 'package:flutter/material.dart';

class ContainerListWidget extends StatelessWidget {
  final String title;
  final Widget widget;

  const ContainerListWidget({
    super.key,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.deepPurple),
          ),
          SizedBox(
            height: 150.0,
            child: widget,
          )
        ],
      ),
    );
  }
}
