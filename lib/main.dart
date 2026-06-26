import 'package:baby_store_app/firebase_options.dart';
import 'package:baby_store_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthService.loadFromStorage(); // ✅ restore login state
  runApp(const ProviderScope(child: BabyStoreApp()));
}
