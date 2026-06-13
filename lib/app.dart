import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';
import 'services/auth_service.dart';

class BabyStoreApp extends StatelessWidget {
  const BabyStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // ✅ If already logged in, go to Home. Otherwise, go to Login.
      initialRoute: AuthService.isRegistered ? '/' : '/login',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
