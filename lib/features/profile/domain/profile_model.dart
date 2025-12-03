class ProfileModel {
  final String id; // user_id (UUID)
  final String fullName; // full_name
  final String telefonNumber; // telefon_number
  final int loyaltyPoints; // loyalty_points
  
  // Nuevos campos de ubicación
  final String region;
  final String commune;
  final String streetAddress;
  final String postalCode;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.telefonNumber,
    required this.loyaltyPoints,
    required this.region,
    required this.commune,
    required this.streetAddress,
    required this.postalCode,
  });

  // Constructor factory para construir el modelo desde la respuesta de Supabase
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['user_id'] as String,
      fullName: json['full_name'] as String,
      // Asegúrate de usar el nombre correcto de la columna del teléfono
      telefonNumber: json['telefon_number'] as String, 
      loyaltyPoints: json['loyalty_points'] as int,
      
      // Mapeo de campos de ubicación
      region: json['region'] as String,
      commune: json['commune'] as String,
      streetAddress: json['street_address'] as String,
      postalCode: json['postal_code'] as String,
    );
  }
}