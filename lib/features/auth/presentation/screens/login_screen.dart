import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/features/auth/presentation/widgets/auth_layout.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/features/auth/data/auth_repository.dart';
import 'package:huerto_hogar_2/common/denuncias_auth_service.dart'; // 👈 NUEVO
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();
  final _denunciasAuthService = DenunciasAuthService(); // 👈 NUEVO
  bool _isLoading = false;

  Future<void> _login() async {
  final email = _emailController.text.trim();
  final pass  = _passwordController.text.trim();

  if (email.isEmpty || pass.isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Por favor, ingresa email y contraseña.'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    // 1) LOGIN EN SUPABASE
    await _authRepository.signIn(email, pass);

    // 2) REFRESCAR USER (ROL)
    await Supabase.instance.client.auth.refreshSession();
    final user = Supabase.instance.client.auth.currentUser;
    final role = user?.userMetadata?['role']?.toString();

    // 3) LOGIN/REGISTRO AUTOMÁTICO EN FLASK
    await _denunciasAuthService.ensureUserAndLogin(email, pass);

    // 4) REDIRECCIONAR
    if (!mounted) return;
    if (role == 'admin') {
      context.go('/admin');
    } else {
      context.go('/home');
    }

  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/welcome');
            }
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo_Huerto_Hogar.png',
              height: 100,
            ),
            const SizedBox(height: 40),
            const SizedBox(height: 30),
            Text(
              'Iniciar Sesión',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Inicia sesión para poder comprar productos...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                hintText: 'Ingrese su email',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(Icons.visibility_off_outlined),
                hintText: 'Contraseña',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Olvidé contraseña
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              onPressed: _isLoading ? null : _login,
              text: 'Iniciar Sesión',
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿No tienes una cuenta?"),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crear una'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
