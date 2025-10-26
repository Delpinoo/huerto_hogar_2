import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/main_drawer.dart';
class MainAppLayout extends StatelessWidget {
  // 'child' será la pantalla que GoRouter decida mostrar
  // (ej. HomeScreen, ProfileScreen, etc.)
  final Widget child;

  const MainAppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El body es la pantalla que nos pasa el router
      body: child,
      
      // Aquí definimos la barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calcularIndice(context), // Función para saber qué ícono resaltar
        onTap: (index) => _onTapItem(index, context), // Función para navegar
        
        // --- Estilos para que se vea como tu diseño ---
        type: BottomNavigationBarType.fixed, // Para que todos los ítems se vean
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,     // Color del ícono activo
        unselectedItemColor: Colors.grey,  // Color de los inactivos
        showSelectedLabels: true,          // Muestra el texto del activo
        showUnselectedLabels: false,       // Oculta el texto de los inactivos
        elevation: 1.0,                    // Una leve sombra
        // ----------------------------------------------
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ícono cuando está activo
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      drawer: const MainDrawer(),
    );
  }

  // --- Lógica para que la barra de navegación funcione con GoRouter ---

  // Esta función decide a qué ruta navegar según el ícono presionado
  void _onTapItem(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  // Esta función revisa la ruta actual y devuelve el índice
  // del ícono que debe estar resaltado.
  int _calcularIndice(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/search')) {
      return 1;
    }
    if (location.startsWith('/cart')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0; // Por defecto, Home
  }
}