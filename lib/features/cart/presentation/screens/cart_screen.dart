import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/features/cart/domain/cart_item_model.dart';
import 'package:huerto_hogar_2/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:huerto_hogar_2/features/cart/presentation/widgets/order_summary.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart'; // Importa tus productos dummy

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // --- ESTADO LOCAL (Nuestra base de datos falsa) ---
  List<CartItem> _cartItems = [];
  double _envio = 3500;
  double _promocion = -1800;

  // Precios "falsos" para el cálculo. En una app real, vendrían del producto.
  final Map<String, double> _productPrices = {
    '1': 2990, // Tomates
    '2': 4990, // Fresas
  };

  @override
  void initState() {
    super.initState();
    // Cargamos el carrito con datos falsos
    _loadDummyCart();
  }

  void _loadDummyCart() {
    setState(() {
      _cartItems = [
        // Asegúrate de que los 'id' coincidan con tus 'dummyProducts'
        CartItem(product: dummyProducts.firstWhere((p) => p.id == '2'), quantity: 2), // Fresas
        CartItem(product: dummyProducts.firstWhere((p) => p.id == '1'), quantity: 3), // Tomates
      ];
    });
  }

  // --- Lógica de negocio ---
  void _incrementItem(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void _decrementItem(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        // Si la cantidad es 1, lo removemos de la lista
        _cartItems.remove(item);
      }
    });
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    for (var item in _cartItems) {
      double price = _productPrices[item.product.id] ?? 0;
      subtotal += (price * item.quantity);
    }
    return subtotal;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _envio + _promocion;
  }
  // --- Fin de la Lógica ---

  @override
  Widget build(BuildContext context) {
    // Calculamos los totales cada vez que el build se ejecuta
    final subtotal = _calculateSubtotal();
    final total = _calculateTotal();

    // ¡Sin Scaffold! El MainAppLayout se encarga.
    return Column(
      children: [
        // --- 1. EL APPBAR ---
        CustomAppBar(
          title: 'Tu Carrito',
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Lógica de "atrás" inteligente
              if (context.canPop()) {
                context.pop(); // Si fue 'push' (desde producto), vuelve
              } else {
                context.go('/home'); // Si fue 'go' (desde nav bar), va a home
              }
            },
          ),
        ),

        // --- 2. LA LISTA DE ITEMS ---
        Expanded(
          child: ListView.builder(
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return CartItemCard(
                item: item,
                onIncrement: () => _incrementItem(item),
                onDecrement: () => _decrementItem(item),
              );
            },
          ),
        ),

        // --- 3. EL RESUMEN ---
        OrderSummary(
          subtotal: subtotal,
          envio: _envio,
          promocion: _promocion,
          total: total,
        ),

        // --- 4. EL BOTÓN DE PAGO ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: 'Proceder al Pago',
            onPressed: () {
              // TODO: Lógica para ir a la pasarela de pago
            },
          ),
        ),
      ],
    );
  }
}