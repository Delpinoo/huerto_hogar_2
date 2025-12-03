import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:huerto_hogar_2/features/products/domain/review_model.dart';

class ReviewRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Obtener todas las reseñas para un producto (en tiempo real)
  Stream<List<Review>> getReviewsStream(String productId) {
    // Usamos un JOIN para obtener el perfil (o al menos el email) del usuario
    // Asegúrate de que las políticas de RLS permitan leer el email de la tabla user_profiles
    return _supabase
        .from('product_reviews')
        // Seleccionamos los campos de la reseña y Hacemos JOIN con el perfil del usuario (role, email)
        .stream(primaryKey: ['id']) 
        .eq('product_id', productId)
        .order('created_at', ascending: false)
        .map((dataList) => dataList.map((map) => Review.fromMap(map)).toList());
  }

  // 2. Agregar una nueva reseña
  Future<void> addReview({
    required String productId,
    required String userId,
    required int rating,
    required String comment,
  }) async {
    final newReview = {
      'product_id': productId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
    };
    
    // El RLS debe permitir a los usuarios autenticados INSERTAR
    await _supabase.from('product_reviews').insert(newReview);
  }

  // 3. Verificar si el usuario ya ha dejado una reseña (opcional, para evitar múltiples reseñas)
  Future<bool> hasUserReviewed(String productId, String userId) async {
    final response = await _supabase
        .from('product_reviews')
        .select('id')
        .eq('product_id', productId)
        .eq('user_id', userId)
        .limit(1)
        .maybeSingle(); // Usamos maybeSingle para obtener null si no existe

    return response != null;
  }

  // 4. Eliminar una reseña (requiere permisos de Admin o ser el autor)
  Future<void> deleteReview(int reviewId) async {
    // Nota: Es crucial configurar una política de RLS que solo permita
    // a los administradores O al usuario que creó la reseña eliminarla.
    await _supabase
        .from('product_reviews')
        .delete()
        .eq('id', reviewId);
  }
}
