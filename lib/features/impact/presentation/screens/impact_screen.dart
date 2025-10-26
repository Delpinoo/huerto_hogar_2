import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart'; // ¡Reutilizamos el AppBar!
import 'package:go_router/go_router.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fíjate: ¡No hay Scaffold! Usa un Column
    return Column(
      children: [
        // --- 1. NUESTRO APPBAR REUTILIZABLE ---
        // Lo configuramos para esta pantalla
        CustomAppBar(
          title: 'Tu impacto',
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Lógica para volver
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home'); // Si no puede volver, va a Home
              }
            },
          ),
        ),

        // --- 2. EL CONTENIDO DE LA PÁGINA ---
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- SECCIÓN 1 ---
                _buildSectionTitle('Reducción de Huella de Carbono'),
                const SizedBox(height: 8),
                _buildImpactCard(
                  subtitle: 'Al elegir local, has ayudado a reducir las emisiones de carbono. Esto es equivalente al carbono absorbido por 10 árboles en un año.'
                ),
                const SizedBox(height: 24),

                // --- SECCIÓN 2 ---
                _buildSectionTitle('Apoyo a la Comunidad'),
                const SizedBox(height: 8),
                _buildCommunityCard(), // Esta tarjeta es un poco diferente
                const SizedBox(height: 24),

                // --- SECCIÓN 3 ---
                _buildSectionTitle('Prácticas Sostenibles'),
                const SizedBox(height: 8),
                _buildImpactCard(
                  icon: const Icon(Icons.recycling, color: Colors.green, size: 30),
                  title: '10% Reducción de Plástico',
                  subtitle: 'Estás ayudando a minimizar los residuos y proteger nuestro medio ambiente con elecciones ecológicas.'
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGETS DE AYUDA (Helpers) ---
  // Para no repetir código dentro del build

  // El título verde (ej. "Apoyo a la Comunidad")
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.bold, 
        color: Colors.green[800], // Un verde oscuro
      ),
    );
  }

  // La tarjeta de "Comunidad" (diseño especial)
  Widget _buildCommunityCard() {
      return Card(
      elevation: 0,
      color: Colors.grey[100], // Fondo gris claro
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.group, color: Colors.green[700], size: 30),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('15', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    Text('Productores Apoyados', style: TextStyle(color: Colors.black54)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Tus compras contribuyen directamente a los medios de vida de los agricultores locales.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Las otras tarjetas (diseño genérico)
  Widget _buildImpactCard({String? title, required String subtitle, Widget? icon}) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[ // Si la tarjeta tiene ícono...
              Row(
                children: [
                  icon,
                  const SizedBox(width: 12),
                  if (title != null) 
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
            ] else if (title != null) ...[ // Si no tiene ícono pero sí título
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
            ],
            // El subtítulo
            Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}