import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
// Importamos la nueva tarjeta y los productos dummy
import 'package:huerto_hogar_2/features/profile/presentation/widgets/recommendation_card.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ¡Sin Scaffold! El MainAppLayout se encarga.
    return Column(
      children: [
        // --- 1. EL APPBAR REUTILIZABLE ---
        CustomAppBar(
          title: 'Perfil',
          backgroundColor: Colors.white,
          // Flecha de 'atrás' que vuelve a Home
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go('/home'),
          ),
          // Botón de 'editar'
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.black),
              onPressed: () {
                context.push('/edit-profile');
              },
            ),
          ],
        ),

        // --- 2. EL CONTENIDO DEL PERFIL ---
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
// --- ¡CAMBIO 2! AÑADIMOS ESTA SECCIÓN ---
                const CircleAvatar(
                  radius: 50, // Tamaño del círculo
                  // Asegúrate de que el nombre del asset sea correcto
                  backgroundImage: AssetImage('assets/images/mujer_icon.png'),
                  // Fondo por si la imagen no carga
                  backgroundColor: Colors.grey, 
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sofia Ramirez',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Miembro desde 2021',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40), // Espacio antes de los detalles
                // --- FIN DE LA SECCIÓN AÑADIDA ---

                // --- Sección de Detalles ---
                // (La foto de perfil de tu otra imagen iría aquí)
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'sofia.ramirezh@email.com',
                ),
                const SizedBox(height: 24),
                _buildInfoRow(
                  icon: Icons.phone_outlined,
                  title: 'Teléfono',
                  subtitle: '+56 9 1234 5678',
                ),
                const SizedBox(height: 24),
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  title: 'Dirección',
                  subtitle: '123 Main Street, Santiago',
                ),
                const SizedBox(height: 40),

                // --- Sección de Pedidos ---
                _buildSectionTitle('Pedidos'),
                const SizedBox(height: 16),
                _buildNavigationRow(
                  icon: Icons.history,
                  title: 'Historial de Pedidos',
                  onTap: () { 
                    context.push('/order-history');
                   },
                ),
                const SizedBox(height: 40),

                // --- Sección de Recomendaciones ---
                _buildSectionTitle('Recomendaciones'),
                const SizedBox(height: 16),
                _buildRecommendations(), // Fila horizontal
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGETS DE AYUDA (Helpers) ---
  
  // Título de sección (ej. "Pedidos")
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  // Fila de información (Email, Teléfono)
  Widget _buildInfoRow({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[700], size: 24),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  // Fila de navegación (Historial de Pedidos)
  Widget _buildNavigationRow({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Fila horizontal de recomendaciones
  Widget _buildRecommendations() {
    // Usamos los 2 productos dummy que ya tenemos
    final recommendations = dummyProducts.take(2).toList();
    
    return SizedBox(
      height: 180, // Altura fija para la lista
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length + 1, // +1 para simular la de "Kale"
        itemBuilder: (context, index) {
          if (index == 0) {
            // Simula "Kale" con error
            return RecommendationCard(
              title: 'Kale',
              imageAsset: 'assets/images/placeholder.png', // Imagen falsa
              hasError: true,
            );
          }
          if (index == 1) {
             // Simula "Salad Mix"
            return RecommendationCard(
              title: 'Salad Mix',
              imageAsset: 'assets/images/tomatoes.png', // Usamos una imagen real
            );
          }
          // Simula "Carrot" con error
          return RecommendationCard(
            title: 'Carrot',
            imageAsset: 'assets/images/placeholder.png', // Imagen falsa
            hasError: true,
          );
        },
      ),
    );
  }
}