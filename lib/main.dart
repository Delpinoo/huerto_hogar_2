import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/app/router/app_router.dart';
import 'package:huerto_hogar_2/app/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:screen_protector/screen_protector.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ScreenProtector.preventScreenshotOn();
  await Supabase.initialize(
    url: 'https://oshmxdanmjawudtuzfsl.supabase.co',   
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9zaG14ZGFubWphd3VkdHV6ZnNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0MTcwNjYsImV4cCI6MjA3Njk5MzA2Nn0.W2pKIXjuRUf9Plm1K-_JcKxD43NpYZaaxkzPVkh4OVY', // <-- Pega tu anon key aquí
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Huerto Hogar',
      routerConfig:  router,
      theme: AppTheme.lightTheme,
    );
  }
}

