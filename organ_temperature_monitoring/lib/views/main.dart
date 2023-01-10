import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:organ_temperature_monitoring/services/plot.dart';
import 'package:organ_temperature_monitoring/views/dashboardMain.dart';
import 'package:organ_temperature_monitoring/views/dashdash.dart';
import 'splash.dart';
// import 'login.dart';

// void main() {
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashPage(),
      home: LinePlot(),
    );
  }
}
