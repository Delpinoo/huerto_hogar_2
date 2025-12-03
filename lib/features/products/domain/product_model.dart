class Product {
  final String id;
  final String name;
  final String supplier; // ej. "Del Campo"
  final double price;
  final String imageUrl; // Ruta a la imagen
  final String description;
  final String origin;

Product({
    required this.id,
    required this.name,
    required this.supplier,
    required this.price,
    required this.imageUrl, // 2. Cambiado
    required this.description,
    required this.origin,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'].toString(), // Asegúrate de que coincida con tu tipo de ID
      name: map['name'] ?? '',
      supplier: map['supplier'] ?? '',
      price: (map['price'] is num)
        ? (map['price'] as num).toDouble()
        : double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: map['imagen_url'] ?? '', // 4. Mapea la columna correcta
      description: map['description'] ?? '',
      origin: map['origin'] ?? '',
    );
  }
}
