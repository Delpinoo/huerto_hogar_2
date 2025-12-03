import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/features/cart/domain/cart_item_model.dart';
import 'package:huerto_hogar_2/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:huerto_hogar_2/features/cart/presentation/widgets/order_summary.dart';
// 🔄 CAMBIO: repo del carrito
import 'package:huerto_hogar_2/features/cart/data/cart_repository.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';



class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // 🔄 CAMBIO: ya NO usamos dummy local, sino stream del repo
  final _repo = CartRepository();

  // Mantén tus costos como estaban (mismo color/estructura)
  final double _envio = 3500;
  final double _promocion = -1800;

  // 🔄 CAMBIO: convierte row del stream → CartItem (para reusar tu CartItemCard)
  CartItem _rowToCartItem(Map<String, dynamic> row) {
  final q = (row['quantity'] as num?)?.toInt() ?? 1;
  final p = Map<String, dynamic>.from(row['product'] ?? {});
  final price = (p['price'] is num)
      ? (p['price'] as num).toDouble()
      : double.tryParse(p['price']?.toString() ?? '0') ?? 0.0;

  return CartItem(
    product: Product(
      id: p['id'].toString(),
      name: p['name']?.toString() ?? 'Producto',
      price: price,                              // 👈 double
      imageUrl: p['image_url']?.toString() ?? '',
      description: p['description']?.toString() ?? '',
      supplier: p['supplier']?.toString() ?? '',
      origin: p['origin']?.toString() ?? '',
    ),
    quantity: q,
  );
}

  
  // ✅ Subtotal con double
  double _calculateSubtotal(List<CartItem> items) {
    double sub = 0;
    for (final it in items) {
      sub += it.product.price * it.quantity;       // 👈 sin parseos
    }
    return sub;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1) APPBAR (igual)
        CustomAppBar(
          title: 'Tu Carrito',
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),

        // 2) LISTA (igual estructura, pero con StreamBuilder)
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _repo.getCartStream(), // 🔄 CAMBIO: datos reales
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final rows = snapshot.data!;
              final items = rows.map(_rowToCartItem).toList();

              if (items.isEmpty) {
                return const Center(child: Text('Tu carrito está vacío'));
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return CartItemCard(
                    item: item,
                    // 🔄 CAMBIO: actualiza en Supabase (mantenemos tus botones)
                    onIncrement: () async {
                      final cartId = rows[index]['id'] as String;
                      final newQty = item.quantity + 1;
                      await _repo.setQuantity(cartId, newQty);
                    },
                    onDecrement: () async {
                      final cartId = rows[index]['id'] as String;
                      final newQty = item.quantity - 1;
                      await _repo.setQuantity(cartId, newQty);
                    },
                  );
                },
              );
            },
          ),
        ),

        // 3) RESUMEN (mismo widget y estilo)
        Builder(
          builder: (context) {
            // Volvemos a leer el stream una vez para calcular totales y no romper la estructura:
            // (si prefieres, mueve este cálculo dentro del StreamBuilder de arriba y pasa los valores)
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _repo.getCartStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final rows = snapshot.data!;
                // si quieres, filtra filas sin product (datos viejos inválidos)
                final rowsOk = rows.where((r) => r['product'] != null).toList();

                if (rowsOk.isEmpty) {
                  return const Center(child: Text('Tu carrito está vacío'));
                }
                
                final items = rows.map(_rowToCartItem).toList();
                final subtotal = _calculateSubtotal(items);
                final total = subtotal + _envio + _promocion;

                return OrderSummary(
                  subtotal: subtotal,
                  envio: _envio,
                  promocion: _promocion,
                  total: total,
                );
              },
            );
          },
        ),

        // 4) BOTÓN (igual)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: 'Proceder al Pago',
            onPressed: () {
              // TODO: pasarela de pago
            },
          ),
        ),
      ],
    );
  }
}
