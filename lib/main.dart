import 'package:flutter/material.dart';
import 'package:flutter_weather_app/weather_app_modal.dart';
import 'package:flutter_weather_app/weather_app_services.dart';
import 'package:flutter_weather_app/weather_app_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const WeatherHomePage(),
    );
  }
}
