import 'package:flutter/material.dart';

AppBar appBarMyOwn(String title) {
  return AppBar(
    backgroundColor: Colors.blueGrey,
    title: Center(child: Text(title)),
  );
}
