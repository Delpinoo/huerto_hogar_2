import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/app/router/app_router.dart';
import 'package:huerto_hogar_2/app/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Huerto Hogar',
      routerConfig:  AppRouter.router,
      theme: AppTheme.lightTheme,
    );
  }
}

