// lib/features/admin/presentation/admin_home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Ver perfil',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => context.push('/admin/profile'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjetas grandes
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _AdminTile(
                    icon: Icons.add_box_outlined,
                    color: Colors.green.shade100,
                    title: 'Agregar\nproducto',
                    onTap: () => context.push('/products/new'),
                  ),
                  _AdminTile(
                    icon: Icons.inventory_2_outlined,
                    color: Colors.blue.shade100,
                    title: 'Ver productos',
                    onTap: () => context.push('/admin/products'),
                  ),
                  _AdminTile(
                    icon: Icons.report_outlined,
                    color: Colors.red.shade100,
                    title: 'Ver\ndenuncias',
                    onTap: () => context.push('/admin/denuncias'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Botón Ir a la tienda
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.storefront),
                label: const Text(
                  'Ir a la tienda',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                // 👇 push para que el "atrás" te devuelva al panel
                onPressed: () => context.push('/home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _AdminTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
