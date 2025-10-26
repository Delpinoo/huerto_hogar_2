import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/features/auth/presentation/widgets/auth_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Usamos nuestra plantilla 'AuthLayout'
    return AuthLayout(
      // 2. Le pasamos un CustomAppBar configurado como en tu imagen
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aquí irá la lógica para volver (GoRouter lo hará fácil)
          },
        ),
        // Le pasamos el color de fondo VERDE para que sea igual al body
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),

      // 3. Aquí pegas TODO el contenido (body) de tu pantalla de Login
      body: Column(
        children: [
          // Pega tu logo aquí
          // Image.asset('assets/logo.png'), 
          Image.asset(
            'assets/images/Logo_Huerto_Hogar.png',
            height: 100,
          ),
          const SizedBox(height: 30),
          const Text(
            'Iniciar Sesion',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Inicia sesion para poder comprar productos...'),
          const SizedBox(height: 30),
          
          // Pega tus TextFields aquí
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              hintText: 'Ingrese su email',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              )
            ),
          ),
          const SizedBox(height: 16),
          // ... el otro textfield para contraseña ...
          
const SizedBox(height: 16),
          
          // --- 2. CAMPO DE CONTRASEÑA (¡AQUÍ ESTÁ!) ---
          TextFormField(
            obscureText: true, // Para que oculte la contraseña
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: Icon(Icons.visibility_off_outlined), // Ícono de "ver"
              hintText: 'Contraseña',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          // --- FIN DEL CAMPO DE CONTRASEÑA ---

          const SizedBox(height: 16),
          
          // Link de "Olvidé contraseña"
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () { /* Lógica para ir a olvidar contraseña */ },
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),

          const SizedBox(height: 30),
          // Pega tu botón aquí
          ElevatedButton(
            onPressed: () {
              context.go('/home');
            },
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }
}