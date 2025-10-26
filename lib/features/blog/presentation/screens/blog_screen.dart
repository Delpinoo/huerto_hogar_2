import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/features/blog/domain/blog_post_model.dart';
import 'package:huerto_hogar_2/features/blog/presentation/widgets/blog_post_card.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ¡Sin Scaffold! El MainAppLayout se encarga.
    return Column(
      children: [
        // --- 1. EL APPBAR REUTILIZABLE ---
        CustomAppBar(
          title: 'Huerto Hogar Blog',
          backgroundColor: Colors.white,
          // Flecha de 'atrás' que funciona con 'push'
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
        ),
        
        // --- 2. LA LISTA DE POSTS ---
        Expanded(
          child: ListView.builder(
            itemCount: dummyBlogPosts.length, // Usa nuestra lista falsa
            itemBuilder: (context, index) {
              final post = dummyBlogPosts[index];
              return BlogPostCard(post: post);
            },
          ),
        ),
      ],
    );
  }
}