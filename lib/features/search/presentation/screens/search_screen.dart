import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/common/widgets/filter_chips.dart';
import 'package:huerto_hogar_2/common/widgets/search_bar_delegate.dart';
// 1. Importa el Repositorio y el Modelo
import 'package:huerto_hogar_2/features/products/data/product_repository.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
import 'package:huerto_hogar_2/features/products/presentation/widgets/product_grid_card.dart';

// 2. Convierte a StatefulWidget
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 3. Define el Future y el Repositorio
  late final Future<List<Product>> _productsFuture;
  final ProductRepository _productRepository = ProductRepository();

  @override
  void initState() {
    super.initState();
    // 4. Inicia la carga de datos
    _productsFuture = _productRepository.getProductsList();
  }

  @override
  Widget build(BuildContext context) {
    // ¡Sin Scaffold! El MainAppLayout se encarga.
    return CustomScrollView(
      slivers: [
        // --- 1. EL APPBAR (Sin cambios) ---
        const SliverAppBar(
          title: Text('Búsqueda de Productos'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          pinned: true,
          automaticallyImplyLeading: false,
        ),

        // --- 2. LA BARRA DE BÚSQUEDA (Sin cambios) ---
        SliverPersistentHeader(
          pinned: true,
          delegate: const SearchBarDelegate(
            hintText: 'Tomates, Lechuga, Zanahorias...',
          ),
        ),

        // --- 3. LOS FILTROS (Sin cambios) ---
        const FilterChips(),

        // --- 4. LA CUADRÍCULA (AHORA CON FUTUREBUILDER) ---
        FutureBuilder<List<Product>>(
          future: _productsFuture, // Escucha el Future
          builder: (context, snapshot) {
            
            // --- Estado de Carga ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Devuelve un Sliver, no un widget normal
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // --- Estado de Error ---
            if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            // --- Estado de Éxito ---
            final products = snapshot.data ?? []; // Obtiene la lista real

            // Devuelve la cuadrícula que ya tenías
            return SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index]; // <- Usa la lista real
                    return ProductGridCard(product: product);
                  },
                  childCount: products.length, // <- Usa el largo real
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}