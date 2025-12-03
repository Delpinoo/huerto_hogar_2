import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String imageAsset; // Ahora será una URL
  final bool hasError;
  final bool isNetworkImage; // 1. AÑADE ESTA BANDERA

  const RecommendationCard({
    super.key,
    required this.title,
    required this.imageAsset,
    this.hasError = false,
    this.isNetworkImage = false, // 2. Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... (sin cambios)
      child: Column(
        children: [
          Card(
            // ... (sin cambios)
            child: Container(
              height: 130,
              width: 130,
              color: Colors.grey[200],
              
              // --- 3. AÑADE LÓGICA AQUÍ ---
              child: hasError
                  ? Center(child: Icon(Icons.error_outline, color: Colors.red[700], size: 40))
                  : isNetworkImage // Si es una imagen de red...
                      ? Image.network( // Usa Image.network
                          imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                        )
                      : Image.asset( // Si no, usa Image.asset
                          imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                        ),
            ),
          ),
          // ... (el Título 'Text' se queda igual)
        ],
      ),
    );
  }
}