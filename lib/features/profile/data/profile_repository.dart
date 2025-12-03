// lib/features/profile/data/profile_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:huerto_hogar_2/features/profile/domain/profile_model.dart';

class ProfileRepository {
  final _supabase = Supabase.instance.client;

  // 1. Obtener el Perfil del Usuario Actual
  // Usamos Stream para obtener actualizaciones en tiempo real si el perfil cambia.
  Stream<ProfileModel> getProfileStream() {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      // Devolver un Stream que emite un error si no hay usuario logeado
      return Stream.error('Usuario no autenticado.');
    }

    // Usamos .stream() para escuchar cambios en tiempo real
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['user_id'])
        .eq('user_id', userId)
        .limit(1)
        .map((data) {
          if (data.isEmpty) {
            throw Exception('Perfil no encontrado.');
          }
          return ProfileModel.fromJson(data.first);
        });
  }

  // 2. Actualizar el Perfil del Usuario
  Future<void> updateProfile({
    required String fullName,
    required String telefon_number,
    required String region, // <--- PARAMETRO AÑADIDO
    required String commune, // <--- PARAMETRO AÑADIDO
    required String streetAddress, // <--- PARAMETRO AÑADIDO
    required String postalCode, // <--- PARAMETRO AÑADIDO
  }) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('Usuario no autenticado.');
    }

    final updates = {
      'full_name': fullName,
      'telefon_number': telefon_number, // Asegúrate que el nombre de la columna es correcto
      'region': region,
      'commune': commune,
      'street_address': streetAddress,
      'postal_code': postalCode,
    };

    await _supabase
        .from('profiles')
        .update(updates)
        .eq('user_id', userId);
  }
}