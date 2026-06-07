import 'package:baby_store_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.loadFromStorage(); // ✅ restore login state
  runApp(const ProviderScope(child: BabyStoreApp()));
}
