import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // InkWell hace que la tarjeta sea "tocable" (clickable)
    return InkWell(
      onTap: () {
        // ¡Navegación al detalle!
        context.go('/product/${product.id}');
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // --- Imagen ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  // TODO: Agregar un placeholder si la imagen no carga
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),

              // --- Texto ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.supplier.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Botón de Carrito ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50), // Círculo
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  onPressed: () {
                    // TODO: Lógica para agregar al carrito
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}