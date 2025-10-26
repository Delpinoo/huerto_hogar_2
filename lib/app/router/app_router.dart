import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart'; // Importante para el GlobalKey
import 'package:huerto_hogar_2/common/widgets/main_app_layout.dart';
import 'package:huerto_hogar_2/features/auth/presentation/screens/login_screen.dart';
import 'package:huerto_hogar_2/features/auth/presentation/screens/welcome_screen.dart';
import 'package:huerto_hogar_2/features/home/presentation/screens/home_screen.dart';
import 'package:huerto_hogar_2/features/impact/presentation/screens/impact_screen.dart';
import 'package:huerto_hogar_2/features/products/presentation/screens/product_details_screen.dart';
import 'package:huerto_hogar_2/features/search/presentation/screens/search_screen.dart';
import 'package:huerto_hogar_2/features/cart/presentation/screens/cart_screen.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/profile_screen.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/order_history_screen.dart';
import 'package:huerto_hogar_2/features/blog/presentation/screens/blog_screen.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/edit_profile_screen.dart';



// Esta clave es necesaria para el ShellRoute
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome', // Empezamos en la bienvenida
    
    routes: [
      // --- Flujo de Autenticación (sin barra de navegación) ---
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // --- Flujo Principal (CON barra de navegación) ---
      // ¡Aquí está la magia!
      ShellRoute(
        // 1. Le decimos que use nuestro MainAppLayout como "cáscara"
        builder: (context, state, child) {
          // Le pasamos la pantalla (child) a nuestra plantilla
          return MainAppLayout(child: child); 
        },
        
        // 2. Definimos todas las rutas que vivirán DENTRO de esa cáscara
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          
          GoRoute(
            path: '/impact',
            builder: (context, state) => const ImpactScreen(),
          ),

          GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(), // ¡Ya no es un placeholder!
          ),

          GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(), // ¡Ya no es un placeholder!
          ),

          GoRoute(
            path: '/order-history',
            builder: (context, state) => const OrderHistoryScreen(),
          ),

          GoRoute(
                path: '/blog',
                builder: (context, state) => const BlogScreen(),
          ),

          GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(), // ¡Ya no es un placeholder!
          ),

          GoRoute(
                path: '/edit-profile',
                builder: (context, state) => const EditProfileScreen(),
          ),
          // --- ¡AÑADE ESTA RUTA! ---
          GoRoute(
            path: '/product/:id', // Ruta dinámica
            builder: (context, state) {
              // 1. Obtenemos el 'id' de la URL
              final String id = state.pathParameters['id']!;
              // 2. Le pasamos el 'id' a la pantalla
              return ProductDetailsScreen(productId: id);
            },
          ),

          
        ],
      ),
    ],
  );
}