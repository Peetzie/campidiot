import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '__sidebar_menu.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Camp Idiot';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: SideBarMenu(title: appTitle),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
    );
  }
}
