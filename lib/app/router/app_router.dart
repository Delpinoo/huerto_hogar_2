import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:huerto_hogar_2/features/admin/presentation/admin_products_screen.dart';
import 'package:huerto_hogar_2/features/auth/presentation/screens/login_screen.dart';
import 'package:huerto_hogar_2/features/auth/presentation/screens/register_screen.dart';
import 'package:huerto_hogar_2/features/auth/presentation/screens/welcome_screen.dart';
import 'package:huerto_hogar_2/features/home/presentation/screens/home_screen.dart';
import 'package:huerto_hogar_2/features/search/presentation/screens/search_screen.dart';
import 'package:huerto_hogar_2/features/cart/presentation/screens/cart_screen.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/profile_screen.dart';
import 'package:huerto_hogar_2/features/products/presentation/screens/product_details_screen.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/order_history_screen.dart';
import 'package:huerto_hogar_2/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:huerto_hogar_2/common/widgets/main_app_layout.dart';
import 'package:huerto_hogar_2/features/admin/presentation/admin_home_screen.dart';
import 'package:huerto_hogar_2/features/products/presentation/screens/add_product_screen.dart';
import 'package:huerto_hogar_2/features/admin/presentation/admin_profile_wrapper.dart';
import 'package:huerto_hogar_2/features/denuncias/presentation/denuncias_page.dart';
import 'package:huerto_hogar_2/features/admin/presentation/admin_denuncias_screen.dart';


// ------------ helper para refrescar GoRouter con un Stream ------------
import 'dart:async';
import 'package:flutter/foundation.dart';
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}
// ----------------------------------------------------------------------

final _sp = Supabase.instance.client;

final GoRouter router = GoRouter(
  initialLocation: '/welcome',
  refreshListenable: GoRouterRefreshStream(_sp.auth.onAuthStateChange),

  redirect: (context, state) {
    final loggedIn = _sp.auth.currentSession != null;
    final role = _sp.auth.currentUser?.userMetadata?['role'];
    final isAdmin = role == 'admin';
    final onAuth = ['/welcome', '/login', '/register'].contains(state.matchedLocation);

    // DEBUG opcional:
    // print('redirect -> loggedIn=$loggedIn role=$role path=${state.matchedLocation}');

    if (!loggedIn && !onAuth) return '/welcome';

    // 👇 AQUI está el cambio clave
    if (loggedIn && onAuth) return isAdmin ? '/admin' : '/home';

    final needsAdmin = state.matchedLocation.startsWith('/admin') ||
                       state.matchedLocation.startsWith('/products/new');
    if (needsAdmin && !isAdmin) return '/home';

    return null;
  },

  routes: [
    // Auth
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

    // Shell principal
    ShellRoute(
      builder: (context, state, child) => MainAppLayout(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        GoRoute(
          path: '/product/:id',
          builder: (_, state) => ProductDetailsScreen(productId: state.pathParameters['id']!),
        ),
        GoRoute(path: '/order-history', builder: (_, __) => const OrderHistoryScreen()),
        GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfileScreen()),
        GoRoute(path: '/denuncias', builder: (_, __) => const DenunciasPage()),
        
      ],
    ),

    // Admin (fuera del Shell)
    GoRoute(path: '/admin', builder: (_, __) => const AdminHomeScreen()),
    GoRoute(path: '/products/new', builder: (_, __) => const AddProductScreen()),
    GoRoute(path: '/admin/products', builder: (_, __) => const AdminProductsScreen()),
    GoRoute(path: '/admin/profile', builder: (_, __) => const AdminProfileWrapper()),
    GoRoute(path: '/admin/denuncias', builder: (_, __) => const AdminDenunciasScreen()),

  ],
);
