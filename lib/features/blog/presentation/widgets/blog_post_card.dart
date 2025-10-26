import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/blog/domain/blog_post_model.dart';

class BlogPostCard extends StatelessWidget {
  final BlogPost post;

  const BlogPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: InkWell(
        onTap: () {
          // TODO: Navegar al detalle del artículo
          // context.push('/blog/${post.id}');
        },
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias, // Para que la imagen respete los bordes
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.grey[100], // Fondo gris claro
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Imagen ---
              Image.asset(
                post.imageAsset,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 200, color: Colors.grey[200]),
              ),
              
              // --- Contenido de Texto ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      post.readTime,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}