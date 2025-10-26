import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/app/app_theme.dart'; // Para el color verde

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Usamos ListView para que el contenido sea desplazable
      // si en el futuro añades más opciones.
      child: ListView(
        // padding: EdgeInsets.zero es importante para que el header
        // toque la parte superior de la pantalla.
        padding: EdgeInsets.zero,
        children: [
          // --- 1. El Header Verde ---
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.colorVerdePrincipal,
            ),
            child: const Text(
              'Menú HuertoHogar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // --- 2. Las Opciones del Menú ---
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Blog'),
            onTap: () {
              // Cierra el drawer
              context.push('/blog');
              // TODO: Navegar a la pantalla de Blog (ej. context.go('/blog'))
            },
          ),
          ListTile(
            leading: const Icon(Icons.eco_outlined), // Ícono de impacto
            title: const Text('Impacto Ambiental'),
            onTap: () {
              context.go('/impact');
              // TODO: Navegar a la pantalla de Impacto
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Compartir App'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Lógica para compartir
            },
          ),
        ],
      ),
    );
  }
}