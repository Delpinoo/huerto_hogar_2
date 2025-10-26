class BlogPost {
  final String id;
  final String title;
  final String description;
  final String imageAsset;
  final String readTime;

  BlogPost({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.readTime,
  });
}

// --- NUESTRA BASE DE DATOS FALSA ---
// ¡Recuerda añadir estas imágenes a 'assets/images/'!
final List<BlogPost> dummyBlogPosts = [
  BlogPost(
    id: '1',
    title: 'Los Beneficios de Comer Productos Locales',
    description: 'Descubre por qué elegir frutas y verduras de origen local no solo es bueno para tu salud, sino que también apoya a tu comunidad y al medio ambiente.',
    imageAsset: 'assets/images/blog1.png', // <-- Nueva imagen
    readTime: '3 min de lectura',
  ),
  BlogPost(
    id: '2',
    title: 'Prácticas de Cultivo Sostenible',
    description: 'Aprende sobre los métodos que los agricultores están utilizando para proteger el medio ambiente y producir alimentos saludables para las generaciones venideras.',
    imageAsset: 'assets/images/blog2.jpg', // <-- Nueva imagen
    readTime: '5 min de lectura',
  ),
  BlogPost(
    id: '3',
    title: 'Las 5 Frutas Más Saludables que Debes Incluir en Tu Dieta',
    description: 'Desde las poderosas bayas hasta los cítricos llenos de vitamina C, te potenciarán las frutas que...',
    imageAsset: 'assets/images/blog3.jpg', // <-- Nueva imagen
    readTime: '4 min de lectura',
  ),
];