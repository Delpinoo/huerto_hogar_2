import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/features/products/data/product_repository.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final _repo = ProductRepository();
  late Future<List<Product>> _productsF;

  @override
  void initState() {
    super.initState();
    _productsF = _repo.getProductsList(limit: 200);
  }

  Future<void> _refresh() async {
    setState(() {
      _productsF = _repo.getProductsList(limit: 200);
    });
  }

  Future<void> _delete(String id) async {
    await _repo.deleteProduct(id);
    await _refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/products/new'),
            tooltip: 'Agregar producto',
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsF,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Sin productos'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final p = items[i];
                return ListTile(
                  leading: (p.imageUrl.isNotEmpty)
                      ? Image.network(p.imageUrl, width: 56, height: 56, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(p.name),
                  subtitle: Text('\$${p.price.toStringAsFixed(0)}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'edit') {
                        context.push('/product/${p.id}'); // opcional: reutilizar details para editar
                      } else if (v == 'delete') {
                        _delete(p.id); // tu id es no-nullable
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
