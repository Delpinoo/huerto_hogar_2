import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final bool hasError; // Para simular el ícono '!' de tu foto

  const RecommendationCard({
    super.key,
    required this.title,
    required this.imageAsset,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // Ancho fijo para la lista horizontal
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Tarjeta de Imagen ---
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias, // Para que la imagen respete los bordes
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 130,
              width: 130,
              color: Colors.grey[200], // Fondo gris
              child: hasError
                  ? Center(child: Icon(Icons.error_outline, color: Colors.red[700], size: 40))
                  : Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      // Placeholder por si la imagen falla
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                    ),
            ),
          ),
          const SizedBox(height: 8),

          // --- Título ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}