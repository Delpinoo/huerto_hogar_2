// ...existing code...
import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/cart/domain/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement; // Callback para '+'
  final VoidCallback onDecrement; // Callback para '-'

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // --- Imagen ---
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                item.product.imageAsset,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 70, height: 70, color: Colors.grey[200]),
              ),
            ),
            const SizedBox(width: 16),

            // --- Texto ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.product.price}', // Muestra el precio (forzado a String)
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // --- Stepper de Cantidad ---
            Row(
              children: [
                // Botón de Menos (-)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onDecrement,
                  color: Colors.grey[600],
                ),
                // Cantidad
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Botón de Más (+)
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: onIncrement,
                  color: Colors.green, // Color verde para sumar
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
// ...existing code...