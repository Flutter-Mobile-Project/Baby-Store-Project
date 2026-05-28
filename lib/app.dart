import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

class BabyStoreApp extends StatelessWidget {
  const BabyStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // ✅ USE ROUTER, NOT home:
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
