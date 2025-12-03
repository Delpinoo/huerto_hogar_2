import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart'; // Asegúrate de que este es tu modelo
import 'dart:io';
import 'package:path/path.dart' as p;


class ProductRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucket = 'product-images';
  // Obtener todos los productos en tiempo real (Stream)
  Stream<List<Product>> getProductsStream() {
    // CORRECCIÓN: Usamos .from().stream() para establecer el listener de Realtime
    // y luego encadenamos el .select() para definir qué campos queremos.
    return _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true)
        // La consulta debe seleccionar solo los campos que existen en tu tabla
        .map((dataList) => dataList.map((map) => Product.fromMap(map)).toList());
  }

   // 🔹 Subir imagen a Supabase Storage
  Future<String> uploadProductImage(File file) async {
    try {
      final userId = _supabase.auth.currentUser?.id ?? 'anon';
      final ext = p.extension(file.path); 
      final fileName = 'prod_${DateTime.now().millisecondsSinceEpoch}_$userId$ext';

      await _supabase.storage.from(_bucket).upload(fileName, file); // Usa la constante
      final publicUrl = _supabase.storage.from(_bucket).getPublicUrl(fileName);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception(
        'No se pudo subir la imagen: ${e.message}. '
        'Verifica que el bucket "$_bucket" exista en Supabase Storage.',
      );
    } catch (e) {
      throw Exception('Error subiendo imagen: $e');
    }
  }


  Future<List<Product>> getProductsList({int limit = 100}) async {
    final res = await _supabase
        .from('products')
        .select('id, name, supplier, price, imagen_url, description, origin')
        .limit(limit);

    return (res as List).map((m) => Product.fromMap(m)).toList();
  }


  // Obtener un solo producto por ID (Future)
  Future<Product?> getProductById(String id) async {
    final response = await _supabase
        .from('products')
        .select('id, name, supplier, price, imagen_url, description, origin')
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      return null;
    }
    // El método fromMap de tu modelo se encargará de mapear los datos
    return Product.fromMap(response);
  }

  // AGREGAR un nuevo producto
  Future<void> addProduct(Product product) async {
    // Convertimos el modelo a un mapa usando SOLO los campos de tu modelo
    final productData = {
      // El ID no se incluye ya que Supabase lo genera
      'name': product.name,
      'description': product.description,
      'price': product.price, // Tipo String
      'imagen_url': product.imageUrl,
      'supplier': product.supplier,
      'origin': product.origin,
      // Los campos 'is_in_stock', 'average_rating' etc. han sido eliminados de aquí.
    };

    // Insertamos el nuevo producto.
    await _supabase.from('products').insert(productData);
  }

  // ACTUALIZAR un producto existente
  Future<void> updateProduct(Product product) async {
    final productData = {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imagen_url': product.imageUrl,
      'supplier': product.supplier,
      'origin': product.origin,
    };

    // Actualizamos el producto basándonos en el ID
    await _supabase.from('products').update(productData).eq('id', product.id);
  }

  // ELIMINAR un producto
  Future<void> deleteProduct(String id) async {
    await _supabase.from('products').delete().eq('id', id);
  }
}
