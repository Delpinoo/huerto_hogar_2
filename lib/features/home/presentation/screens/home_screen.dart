import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
import 'package:huerto_hogar_2/features/products/presentation/widgets/product_card.dart';
import 'package:huerto_hogar_2/common/widgets/search_bar_delegate.dart';
import 'package:huerto_hogar_2/common/widgets/filter_chips.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fíjate: ¡No hay Scaffold! 
    // Usamos un CustomScrollView para tener más control sobre el scroll
    // y el AppBar.
    return CustomScrollView(
      slivers: [
        
        // --- 1. EL APPBAR ---
        SliverAppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Color de íconos y texto
          elevation: 0,
          
          // --- Icono de la izquierda (menú) ---
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
             },
          ),
          
          // --- Título ---
          title: const Text('HuertoHogar', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          
          // --- Iconos de la derecha (carrito, más) ---
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () { context.go('/cart'); /* Ir al carrito */ },
            ),
          ],
        ),

        // --- 2. LA BARRA DE BÚSQUEDA ---
        // Usamos un 'SliverPersistentHeader' para que se quede "pegada"
        SliverPersistentHeader(
          pinned: true, // ¡La clave para que se quede fija!
          delegate: SearchBarDelegate(),
        ),


        const FilterChips(),
        // --- 4. LA LISTA DE PRODUCTOS (¡AQUÍ ESTÁ EL CAMBIO!) ---
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // Obtenemos el producto de nuestra lista dummy
              final product = dummyProducts[index];
              // Devolvemos la tarjeta
              return ProductCard(product: product);
            },
            childCount: dummyProducts.length, // El número de productos
          ),
        ),
      ],
    );
  }
}
