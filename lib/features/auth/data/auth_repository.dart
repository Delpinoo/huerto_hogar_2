import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  // Obtener el usuario actual
  User? get currentUser => _supabase.auth.currentUser;
  
  // Stream para que el router reaccione a cambios (login/logout)
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Iniciar Sesión
Future<void> signIn(String email, String password) async {
  try {
    await _supabase.auth.signInWithPassword(email: email, password: password);
    await _supabase.auth.refreshSession(); // 👈 importante
  } on AuthException catch (e) {
    throw Exception('Error de autenticación: ${e.message}');
  } catch (e) {
    throw Exception('Error desconocido: $e');
  }
}

    // Registrar Usuario
    // ¡Este método también crea el perfil y los puntos!
  Future<void> signUp(
    String email, 
    String password, 
    String fullName,
    // --- AÑADIMOS ESTOS 2 PARÁMETROS ---
    String phone,
    String region,
    String commune,
    String streetAddress,
    String postalCode

    // ----------------------------------
  ) async {
  try {
    final AuthResponse res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'role': 'customer'},
    );
    
    if (res.user == null) {
      throw Exception('No se pudo crear el usuario');
    }

    // --- ¡AQUÍ ESTÁ LA INSERCIÓN DE DATOS COMPLETA! ---
    // Asegúrate de que los nombres de columna coincidan con tu última BBDD:
    await _supabase.from('profiles').insert({
      'user_id': res.user!.id,         
      'full_name': fullName,           
      'loyalty_points': 0,              
      // --- ¡Añadimos los nuevos campos! ---
      'telefon_number': phone,          
      'region': region,         // <-- NUEVO
      'commune': commune,       // <-- NUEVO
      'street_address': streetAddress, // <-- NUEVO
      'postal_code': postalCode,             
    });
    // --- FIN DE LA INSERCIÓN ---

  } on AuthException catch (e) {
    throw Exception('Error de autenticación: ${e.message}');
  } catch (e) {
    throw Exception('Error desconocido: $e');
  }
}

  // Cerrar Sesión
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}


extension AuthX on AuthRepository {
  /// Devuelve el rol actual del usuario (customer/admin)
  String? get currentRole {
    final user = _supabase.auth.currentUser;
    final role = user?.userMetadata?['role'];
    return role is String ? role : null;
  }

  /// Indica si hay sesión activa
  bool get isLoggedIn => _supabase.auth.currentSession != null;

  /// Indica si el usuario es admin
  bool get isAdmin => currentRole == 'admin';
}