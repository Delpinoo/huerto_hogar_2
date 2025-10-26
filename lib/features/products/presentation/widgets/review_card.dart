import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/products/domain/review_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Fila de Estrellas
                Row(children: _buildReadOnlyStars(review.rating)),
                Text(review.date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para construir las estrellas (solo visualización)
  List<Widget> _buildReadOnlyStars(double rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(Icon(
        i < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 18,
      ));
    }
    return stars;
  }
}