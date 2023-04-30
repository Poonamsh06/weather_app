import 'package:flutter/material.dart';

class Text3 extends StatelessWidget {
  String data;
  Text3({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color.fromARGB(255, 158, 157, 157)),
    );
  }
}
