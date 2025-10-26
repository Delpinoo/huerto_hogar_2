import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/common/widgets/filter_chips.dart';
import 'package:huerto_hogar_2/common/widgets/search_bar_delegate.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
import 'package:huerto_hogar_2/features/products/presentation/widgets/product_grid_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ¡Sin Scaffold! El MainAppLayout se encarga.
    return CustomScrollView(
      slivers: [
        // --- 1. EL APPBAR ---
        const SliverAppBar(
          title: Text('Búsqueda de Productos'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          pinned: true, // Para que el título se quede fijo
          automaticallyImplyLeading: false, // Sin flecha de 'atrás'
        ),

        // --- 2. LA BARRA DE BÚSQUEDA (REUTILIZADA) ---
        SliverPersistentHeader(
          pinned: true,
          delegate: const SearchBarDelegate(
            hintText: 'Tomates, Lechuga, Zanahorias...',
          ),
        ),

        // --- 3. LOS FILTROS (REUTILIZADOS) ---
        const FilterChips(),

        // --- 4. LA CUADRÍCULA DE PRODUCTOS ---
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,    // 2 columnas
              mainAxisSpacing: 16,  // Espacio vertical
              crossAxisSpacing: 16, // Espacio horizontal
              childAspectRatio: 0.7,  // Ajusta esta proporción a tu gusto
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = dummyProducts[index]; // Usamos los datos falsos
                // ¡Usamos la nueva tarjeta de cuadrícula!
                return ProductGridCard(product: product);
              },
              childCount: dummyProducts.length,
            ),
          ),
        ),
      ],
    );
  }
}