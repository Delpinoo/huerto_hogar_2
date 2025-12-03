import 'package:intl/intl.dart';

class Review {
  final String id;// Añadido para permisos de borrado
  final String userName;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  // Constructor de mapeo para leer desde Supabase
  factory Review.fromMap(Map<String, dynamic> map) {
    // Aseguramos que el mapeo de la relación 'user_profiles' funcione
    final userProfile = map['user_profiles'] as Map<String, dynamic>?;
    final userName = userProfile?['email']?.toString().split('@').first ?? 'Usuario Desconocido';
    
    // Formateo de fecha
    final createdAt = map['created_at'] != null 
        ? DateTime.parse(map['created_at']) 
        : DateTime.now();
    final formattedDate = DateFormat('dd MMM, yyyy').format(createdAt);

    return Review(
      id: map['id']?.toString() ?? '',
      userName: userName,
      rating: (map['rating'] as int?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      date: formattedDate,
    );
  }
}

// --- NUESTRA BASE DE DATOS FALSA (Mantenida para compatibilidad de prueba) ---
final List<Review> dummyReviews = [
  Review(
    id: '1',
    userName: 'Ana González',
    rating: 5,
    comment: '¡Los mejores tomates que he probado! Muy frescos y llegaron rápido.',
    date: '20 Oct, 2025',
  ),
  Review(
    id: '2',
    userName: 'Carlos Tapia',
    rating: 4,
    comment: 'Buen producto, aunque un poco más pequeños de lo que esperaba.',
    date: '18 Oct, 2025',
  ),
];
