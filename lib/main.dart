import 'package:flutter/material.dart';
import 'package:my_flutter_demo/my_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
//        platform: TargetPlatform.iOS,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
