// lib/features/admin/presentation/admin_profile_wrapper.dart
import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/profile_screen.dart';

class AdminProfileWrapper extends StatelessWidget {
  const AdminProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // ProfileScreen ya dibuja su propio CustomAppBar dentro del body
      body: SafeArea(child: ProfileScreen()),
    );
  }
}
