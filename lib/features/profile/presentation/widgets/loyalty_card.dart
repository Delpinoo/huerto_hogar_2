import 'package:flutter/material.dart';

class LoyaltyCard extends StatelessWidget {
  // 1. AÑADE ESTE PARÁMETRO
  final int loyaltyPoints;

  const LoyaltyCard({
    super.key,
    required this.loyaltyPoints, // Hazlo requerido
  });

  @override
  Widget build(BuildContext context) {
    // --- 2. USA LOS PUNTOS REALES ---
    final int userPoints = loyaltyPoints; 
    const int pointsForReward = 2000;
    final double progress = (userPoints / pointsForReward).clamp(0.0, 1.0); // .clamp evita errores
    // ---------------------------------

    return Card(
      // ... (el resto del build se queda igual)
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Puntos HuertoHogar', /*...*/),
                Text('$userPoints Puntos', /*...*/), // <-- Muestra puntos reales
              ],
            ),
            // ... (LinearProgressIndicator)
            Text(
              // Lógica para mostrar el mensaje correcto
              progress >= 1.0
                  ? '¡Felicidades! Tienes un 10% dcto.'
                  : '¡Te faltan ${pointsForReward - userPoints} puntos para tu 10% dcto!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}