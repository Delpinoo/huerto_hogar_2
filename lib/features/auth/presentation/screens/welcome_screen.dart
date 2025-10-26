import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/auth/presentation/widgets/auth_layout.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/common/widgets/secondary_button.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Reutilizamos el AuthLayout
    return AuthLayout(
      // 2. ¡NO le pasamos AppBar! (Como en tu imagen)
      
      // 3. Aquí pegas el body de tu pantalla de bienvenida
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Image.asset(
            'assets/images/Logo_Huerto_Hogar.png',
            height: 100,
          ),
          const SizedBox(height: 40),
          const Text(
            'Bienvenido a\nHuerto Hogar',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 60),

          // --- ¡AQUÍ ESTÁ EL CAMBIO! ---
          PrimaryButton(
            text: 'Ver productos',
            onPressed: () {
              context.go('/home');
            },
          ),
          const SizedBox(height: 16),
          SecondaryButton( // <-- Cambiado
            text: 'Iniciar Sesión',
            onPressed: () {
              context.go('/login');
            },
          ),
          // --- FIN DEL CAMBIO ---
        ],
      ),
    );
  }
}