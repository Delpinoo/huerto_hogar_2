import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/features/profile/domain/profile_model.dart';
// Importación del Repositorio de Perfiles
import 'package:huerto_hogar_2/features/profile/data/profile_repository.dart';
import 'package:huerto_hogar_2/features/profile/presentation/widgets/loyalty_card.dart';
import 'package:huerto_hogar_2/features/profile/presentation/widgets/recommendation_card.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
// Importación del Repositorio de Productos con un alias para evitar la ambigüedad
import 'package:huerto_hogar_2/features/products/data/product_repository.dart' as product_repo;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:huerto_hogar_2/features/auth/data/auth_repository.dart'; 


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Stream<ProfileModel> _profileStream;
  late final Future<List<Product>> _recommendationsFuture;

  // Inicialización de los repositorios
  final ProfileRepository _profileRepository = ProfileRepository();
  // Usamos el alias para ProductRepository para resolver la ambigüedad
  final product_repo.ProductRepository _productRepository = product_repo.ProductRepository();
  final AuthRepository _authRepository = AuthRepository(); 

  final String? _userEmail = Supabase.instance.client.auth.currentUser?.email;

  @override
  void initState() {
    super.initState();
    _profileStream = _profileRepository.getProfileStream();
    _recommendationsFuture = _productRepository.getProductsList().then((products) => products.take(2).toList());
  }

  // Función para Cerrar Sesión
  Future<void> _signOut() async {
    try {
      await _authRepository.signOut();
      if (mounted) {
        context.go('/welcome'); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          title: 'Perfil',
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
            if (context.canPop()) {
              context.pop();            // ✅ si venías de /admin/profile, vuelve a /admin
            } else {
              context.go('/home');       // fallback cuando no hay stack
            }
          },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.black),
              onPressed: () {
                context.push('/edit-profile');
              },
            ),
          ],
        ),

        Expanded(
          child: StreamBuilder<ProfileModel>( // Usa StreamBuilder y ProfileModel
            stream: _profileStream, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                 // Manejo de error o perfil no encontrado (muestra email como fallback)
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      LoyaltyCard(
                        loyaltyPoints: 0,
                      ),
                      const SizedBox(height: 20),
                      Text('Error al cargar perfil o datos no encontrados.', style: TextStyle(color: Colors.red)),
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: _userEmail ?? 'No disponible', 
                      ),
                      // ... (Continuar con la UI si es necesario)
                    ],
                  ),
                );
              }

              final profile = snapshot.data!; 

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    const CircleAvatar(
                      radius: 50,
                      // Asumiendo que 'assets/images/mujer_icon.png' existe
                      backgroundImage: AssetImage('assets/images/mujer_icon.png'),
                      backgroundColor: Colors.grey, 
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      profile.fullName, // <-- Dato real
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Miembro desde 2021', // (Dato fijo, considera usar profile.createdAt)
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    LoyaltyCard(
                      loyaltyPoints: profile.loyaltyPoints, // <-- Dato real
                    ),
                    
                    const SizedBox(height: 32),

                    _buildSectionTitle('Detalles de la Cuenta'),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: _userEmail ?? 'No disponible', // <-- Dato real
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow(
                      icon: Icons.phone_outlined,
                      title: 'Teléfono',
                      subtitle: profile.telefonNumber,
                    ),
                    const SizedBox(height: 24),

                    // 2. REGIÓN
                    _buildInfoRow(
                      icon: Icons.public_outlined,
                      title: 'Región',
                      subtitle: profile.region,
                    ),
                    const SizedBox(height: 24),
                    // 3. COMUNA
                    _buildInfoRow(
                      icon: Icons.location_city_outlined,
                      title: 'Comuna',
                      subtitle: profile.commune,
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow(
                      icon: Icons.location_on_outlined,
                      title: 'Calle',
                      subtitle: '${profile.streetAddress},',
                    ),
                    const SizedBox(height: 40),

                    _buildInfoRow(
                      icon: Icons.tag,
                      title: 'Código Postal',
                      subtitle: profile.postalCode,
                    ),

                    const SizedBox(height: 40),

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

                    _buildSectionTitle('Recomendaciones'),
                    const SizedBox(height: 16),
                    _buildRecommendations(), 

                    // --- Botón de Cerrar Sesión ---
                    const SizedBox(height: 40),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red[700]),
                      title: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      tileColor: Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      onTap: _signOut, // <-- Llama a la función
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- WIDGETS DE AYUDA (Helpers) ---
  
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

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

  Widget _buildRecommendations() {
    return SizedBox(
      height: 180,
      child: FutureBuilder<List<Product>>(
        future: _recommendationsFuture,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay recomendaciones'));
          }

          final recommendations = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final product = recommendations[index];
              final title = product.name;
              final img = product.imageUrl;
              final isNet = product.imageUrl.startsWith('http');

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: RecommendationCard(
                  title: title,           // ← requerido
                  imageAsset: img,        // ← requerido (si es URL, usa isNetworkImage)
                  isNetworkImage: isNet,  // ← importante para que cargue NetworkImage
                ),
              );
            },
          );
        },
      ),
    );
  }
}