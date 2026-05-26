import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'theme/app_theme.dart';
import 'features/home/home_screen.dart';

class BabyStoreApp extends StatelessWidget {
  const BabyStoreApp({super.key});
=======
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
>>>>>>> 44690a7 (map)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Store',
<<<<<<< HEAD
      debugShowCheckedModeBanner: false, 
      theme: AppTheme.lightTheme,       
      home: const HomeScreen(),         
=======
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
>>>>>>> 44690a7 (map)
    );
  }
}