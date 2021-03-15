import 'package:flutter/material.dart';
import 'package:simplenoteapp/home_page.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note app",
      home: HomePage(),
    );
  }
}
