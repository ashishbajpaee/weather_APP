import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget{
  const  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      appBarTheme: AppBarTheme()
     ),
      home: const WeatherScreen(),
   );
  }
}