import 'package:supabase_flutter/supabase_flutter.dart';

String? currentRole() {
  final user = Supabase.instance.client.auth.currentUser;
  final role = user?.userMetadata?['role'];
  return (role is String) ? role : null;
}

bool get isLoggedIn => Supabase.instance.client.auth.currentSession != null;
bool get isAdmin => currentRole() == 'admin';
