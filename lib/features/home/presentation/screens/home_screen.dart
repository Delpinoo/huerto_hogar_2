import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/products/data/product_repository.dart'; // 1. Importa Repo
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';
import 'package:huerto_hogar_2/features/products/presentation/widgets/product_card.dart';
import 'package:huerto_hogar_2/common/widgets/search_bar_delegate.dart';
import 'package:huerto_hogar_2/common/widgets/filter_chips.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';


// 2. Convierte a StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 3. Define el Future y el Repo
  late final Future<List<Product>> _productsFuture;
  final ProductRepository _productRepository = ProductRepository();

    bool get _isAdmin =>
      Supabase.instance.client.auth.currentUser?.userMetadata?['role'] == 'admin';

  @override
  void initState() {
    super.initState();
    // 4. Inicia la carga de datos
    _productsFuture = _productRepository.getProductsList();
  }

  @override
Widget build(BuildContext context) {
  final canBackToAdmin = _isAdmin && context.canPop();

  return Scaffold(
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Menú Huerto Hogar',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // ⭐ BOTÓN DENUNCIAS AQUÍ ⭐
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: const Text('Denuncias'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              context.go('/denuncias');
            },
          ),
        ],
      ),
    ),

    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Huerto Hogar'),
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          actions: [
            if (canBackToAdmin)
              IconButton(
                tooltip: 'Volver al panel',
                icon: const Icon(Icons.dashboard_customize_outlined),
                onPressed: () => context.pop(),
              ),
          ],
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: const SearchBarDelegate(),
        ),
        const FilterChips(),

        FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            final products = snapshot.data ?? [];

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
                childCount: products.length,
              ),
            );
          },
        ),
      ],
    ),
  );
}
}
// ¡Recuerda borrar _SearchBarDelegate si aún estaba pegada aquí!