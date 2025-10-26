class Product {
  final String id;
  final String name;
  final String supplier; // ej. "Del Campo"
  final String price;
  final String imageAsset; // Ruta a la imagen
  final String description;
  final String origin;

  Product({
    required this.id,
    required this.name,
    required this.supplier,
    required this.price,
    required this.imageAsset,
    required this.description,
    required this.origin,
  });
}

// --- NUESTRA BASE DE DATOS FALSA ---
// Más adelante, tendrás que agregar tus propias imágenes a 'assets/images/'
final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Tomates Orgánicos',
    supplier: 'Del Campo',
    price: r'$2.990/kg',
    imageAsset: 'assets/images/tomatoes.png', // ¡Asegúrate de tener esta imagen!
    description: 'Tomates orgánicos recién cosechados de los campos de los Andes. Cultivados con prácticas sostenibles, garantizando la más alta calidad y sabor.',
    origin: 'Andes Farms',
  ),
  Product(
    id: '2',
    name: 'Fresas Orgánicas',
    supplier: 'Cosecha Local',
    price: r'$4.990',
    imageAsset: 'assets/images/strawberries.png', // ¡Asegúrate de tener esta imagen!
    description: 'Fresas dulces y jugosas, cultivadas localmente sin pesticidas. Perfectas para postres o para comer solas.',
    origin: 'Valle Central',
  ),
  // ... agrega más productos aquí
];