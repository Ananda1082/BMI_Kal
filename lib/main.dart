import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/bmi_page.dart';

void main() async {
  // Pastikan Flutter binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // Batasi orientasi hanya portrait untuk mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cek BMI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BmiPage(),
    );
  }
}
