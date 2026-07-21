import 'package:dalilek_fi_alshamal/screens/profile_screen1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: AppColors.lightColorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.lightColorScheme.primaryContainer,
      ),
      home:ProfileScreen1() ,
    );
  }
}


