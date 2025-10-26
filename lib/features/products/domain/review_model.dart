class Review {
  final String id;
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
}

// --- NUESTRA BASE DE DATOS FALSA ---
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