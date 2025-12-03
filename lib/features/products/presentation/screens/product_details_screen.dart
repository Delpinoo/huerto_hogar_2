// ...existing code...
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/common/widgets/star_rating_input.dart';
// Importa el REPOSITORIO
import 'package:huerto_hogar_2/features/products/data/product_repository.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
import 'package:huerto_hogar_2/features/products/domain/review_model.dart';
import 'package:huerto_hogar_2/features/products/presentation/widgets/review_card.dart';
import 'package:huerto_hogar_2/features/cart/data/cart_repository.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Estado
  late final Future<Product?> _productFuture;
  final ProductRepository _productRepository = ProductRepository();
  final CartRepository _cartRepo = CartRepository();

  // Estado para las reseñas
  List<Review> _reviews = [];

  final _commentController = TextEditingController();
  int _newRating = 0;

  @override
  void initState() {
    super.initState();
    // Carga el producto desde el repositorio
    _productFuture = _productRepository.getProductById(widget.productId);

    // Si usas dummyReviews en review_model.dart, mantenlo; si no, inicializa vacío
    try {
      _reviews = List.from(dummyReviews);
    } catch (_) {
      _reviews = [];
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showAddReviewModal() {
    _commentController.clear();
    _newRating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              StarRatingInput(
                onRatingChanged: (rating) {
                  _newRating = rating;
                },
              ),
              const SizedBox(height: 16),
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

  void _submitReview() {
    if (_newRating == 0 || _commentController.text.isEmpty) {
      return;
    }

    final newReview = Review(
      id: 'sim-${DateTime.now().millisecondsSinceEpoch}',
      userName: 'Sofía Ramírez',
      rating: _newRating.toDouble(),
      comment: _commentController.text.trim(),
      date: 'Justo ahora',
    );

    setState(() {
      _reviews.insert(0, newReview);
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: CustomAppBar(backgroundColor: Colors.white),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: CustomAppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
              ),
            ),
            body: Center(
              child: Text('Error al cargar el producto: ${snapshot.error}'),
            ),
          );
        }

        final product = snapshot.data!;

        return Column(
          children: [
            CustomAppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                  onPressed: () => context.push('/cart'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      product.imageUrl,
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
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            product.description,
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Product Details',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Price', product.price),
                          const Divider(height: 24),
                          _buildDetailRow('Origin', product.origin),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Valoraciones',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: _showAddReviewModal,
                                child: const Text('Escribir reseña'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            itemCount: _reviews.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ReviewCard(review: _reviews[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: 'Añadir al carrito',
                onPressed: () async {
                  try {
                    await _cartRepo.addToCart(product.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producto añadido al carrito')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, Object value) {
    final display = value is double ? '\$${value.toStringAsFixed(2)}' : value.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        Text(display, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
// ...existing code...