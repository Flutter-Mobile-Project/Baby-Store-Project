import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'features/home/home_screen.dart';

class BabyStoreApp extends StatelessWidget {
  const BabyStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Store',
      debugShowCheckedModeBanner: false, 
      theme: AppTheme.lightTheme,       
      home: const HomeScreen(),         
    );
  }
}