import 'package:dealhunter/Homepage.dart';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
           home: const HomePage(),
         );
    }
}