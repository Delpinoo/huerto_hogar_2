import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/common/widgets/star_rating_input.dart'; // Importa el widget de estrellas
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
import 'package:huerto_hogar_2/features/products/domain/review_model.dart'; // Importa el modelo de reseña
import 'package:huerto_hogar_2/features/products/presentation/widgets/review_card.dart'; // Importa la tarjeta de reseña

// 1. CONVERTIR A STATEFULWIDGET
class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key, 
    required this.productId
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // 2. DEFINIR EL ESTADO
  late final Product product;
  List<Review> _reviews = []; // Lista de reseñas en el estado
  
  // Controladores para el modal
  final _commentController = TextEditingController();
  int _newRating = 0;

  @override
  void initState() {
    super.initState();
    // 3. CARGAR LOS DATOS FALSOS AL INICIAR
    product = dummyProducts.firstWhere((p) => p.id == widget.productId);
    _reviews = List.from(dummyReviews); // Copia la lista dummy al estado
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  
  // 4. FUNCIÓN PARA MOSTRAR EL MODAL
  void _showAddReviewModal() {
    // Resetea los valores
    _commentController.clear();
    _newRating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el modal sea más alto
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Padding para que el teclado no tape el modal
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escribe tu reseña',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Widget de Estrellas
              StarRatingInput(
                onRatingChanged: (rating) {
                  _newRating = rating; // Guarda la puntuación
                },
              ),
              const SizedBox(height: 16),
              // Campo de Texto
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Tu opinión...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              // Botón de Enviar
              PrimaryButton(
                text: 'Enviar Reseña',
                onPressed: _submitReview,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // 5. FUNCIÓN PARA SIMULAR EL ENVÍO
  void _submitReview() {
    if (_newRating == 0 || _commentController.text.isEmpty) {
      // (Opcional) Mostrar un error
      return; 
    }

    // Crea la nueva reseña (con datos falsos de usuario)
    final newReview = Review(
      id: 'sim-${DateTime.now().millisecondsSinceEpoch}',
      userName: 'Sofía Ramírez', // Simula el usuario logueado
      rating: _newRating.toDouble(),
      comment: _commentController.text.trim(),
      date: 'Justo ahora',
    );

    // Actualiza el estado (Optimistic Update)
    setState(() {
      _reviews.insert(0, newReview); // Añade la nueva reseña al inicio de la lista
    });

    Navigator.pop(context); // Cierra el modal
  }

  // 6. ACTUALIZAR EL BUILD
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ... (Tu CustomAppBar se queda igual)
        CustomAppBar(
          // ...
        ),
        
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... (Tu Image.asset se queda igual)
                Image.asset(
                  product.imageAsset,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                    );
                  },
                ),
                
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... (Textos de nombre, descripción, detalles... se quedan igual)
                      Text(product.name, /* ... */),
                      const SizedBox(height: 16),
                      Text(product.description, /* ... */),
                      const SizedBox(height: 24),
                      const Text('Product Details', /* ... */),
                      const SizedBox(height: 16),
                      _buildDetailRow('Price', product.price),
                      const Divider(height: 24),
                      _buildDetailRow('Origin', product.origin),

                      // --- ¡AÑADIR ESTA SECCIÓN DE RESEÑAS! ---
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Valoraciones',
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          TextButton(
                            onPressed: _showAddReviewModal, // Llama al modal
                            child: const Text('Escribir reseña'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Lista de Reseñas
                      ListView.builder(
                        itemCount: _reviews.length,
                        shrinkWrap: true, // Necesario dentro de un SingleChildScrollView
                        physics: const NeverScrollableScrollPhysics(), // Evita doble scroll
                        itemBuilder: (context, index) {
                          return ReviewCard(review: _reviews[index]);
                        },
                      ),
                      // --- FIN DE LA SECCIÓN DE RESEÑAS ---
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- 3. EL BOTÓN FIJO DE "AÑADIR AL CARRITO" ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: 'Add to Cart',
            onPressed: () {
              // TODO: Lógica para agregar al carrito
            },
          ),
        ),
      ],
    );
  }

  // Widget helper para las filas de "Precio" y "Origen"
  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}