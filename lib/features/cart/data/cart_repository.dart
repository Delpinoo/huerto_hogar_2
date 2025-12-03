import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepository {
  final _db = Supabase.instance.client;

  String get _uid {
    final u = _db.auth.currentUser;
    if (u == null) throw Exception('Usuario no autenticado');
    return u.id;
  }

  /// Agrega (si existe, incrementa)
  Future<void> addToCart(String productId, {int qty = 1}) async {
    // Busca si ya existe
    final exist = await _db
        .from('cart_items')
        .select('id, quantity')
        .eq('user_id', _uid)
        .eq('product_id', productId)
        .maybeSingle();

    if (exist != null) {
      final newQty = ((exist['quantity'] as num?)?.toInt() ?? 1) + qty;
      await _db.from('cart_items')
          .update({'quantity': newQty})
          .eq('id', exist['id']);
    } else {
      await _db.from('cart_items').insert({
        'user_id': _uid,
        'product_id': productId,
        'quantity': qty,
      });
    }
  }

  Future<void> setQuantity(String cartItemId, int qty) async {
    if (qty <= 0) {
      await removeItem(cartItemId);
      return;
    }
    await _db.from('cart_items').update({'quantity': qty}).eq('id', cartItemId);
  }

  Future<void> removeItem(String cartItemId) async {
    await _db.from('cart_items').delete().eq('id', cartItemId);
  }

  Future<void> clear() async {
    await _db.from('cart_items').delete().eq('user_id', _uid);
  }

  /// Lectura one-shot con join
  Future<List<Map<String, dynamic>>> getCart() async {
    final res = await _db
        .from('cart_items')
        .select('id, quantity, product:products(id, name, price, imagen_url, image_url, supplier, origin, description)')
        .eq('user_id', _uid)
        .order('created_at');
    return List<Map<String, dynamic>>.from(res);
  }

  /// 🔥 Stream ENRIQUECIDO: trae filas y les adjunta el product completo.
  /// (Realtime no soporta join directo, así que lo hacemos client-side.)
  Stream<List<Map<String, dynamic>>> getCartStream() {
  return _db
      .from('cart_items')
      .stream(primaryKey: ['id'])
      .eq('user_id', _uid)
      .order('created_at')
      .asyncMap((rows) async {
        try {
          if (rows.isEmpty) return <Map<String, dynamic>>[];

          final productIds = rows
              .map((r) => r['product_id'])
              .where((e) => e != null)
              .map((e) => e.toString())
              .toSet()
              .toList();

          // 🔒 Si por algún motivo hay filas sin product_id válido, evita inFilter([]).
          if (productIds.isEmpty) {
            // Devuelve filas “como están” sin product adjunto
            return rows
                .map((r) => {...Map<String, dynamic>.from(r), 'product': null})
                .toList();
          }

          final products = await _db
              .from('products')
              .select(
                  'id, name, price, imagen_url, image_url, supplier, origin, description')
              .inFilter('id', productIds);

          final byId = <String, Map<String, dynamic>>{
            for (final p in products)
              p['id'].toString(): Map<String, dynamic>.from(p)
          };

          return rows.map((r) {
            final pid = (r['product_id'] ?? '').toString();
            return {
              ...Map<String, dynamic>.from(r),
              'product': byId[pid],
            };
          }).toList();
        } catch (e) {
          // Si algo falla (p.ej. RLS), devuelve lista vacía para no colgar la UI
          return <Map<String, dynamic>>[];
        }
      });
}

  /// Totales usando double
  Map<String, num> computeTotals(List<Map<String, dynamic>> items) {
    double subtotal = 0;
    for (final it in items) {
      final q = (it['quantity'] as num?)?.toDouble() ?? 1.0;
      final prod = it['product'] as Map<String, dynamic>? ?? {};
      final price = (prod['price'] is num)
          ? (prod['price'] as num).toDouble()
          : double.tryParse(prod['price']?.toString() ?? '0') ?? 0.0;
      subtotal += price * q;
    }
    final shipping = 0.0;
    final total = subtotal + shipping;
    return {'subtotal': subtotal, 'shipping': shipping, 'total': total};
  }
}
