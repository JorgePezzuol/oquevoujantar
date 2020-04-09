import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oquevoujantar/view/HomeScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'O que vou comer',
        home: HomeScreen(),
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Oswald',
        )));
  });
}
