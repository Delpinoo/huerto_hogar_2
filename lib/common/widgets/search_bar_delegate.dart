import 'package:flutter/material.dart';

// 1. Renombrado de _SearchBarDelegate a SearchBarDelegate
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  
  // --- 2. ¡ESTO ES LO QUE FALTA! ---
  // La variable que guardará el texto
  final String hintText;
  
  // El constructor que acepta el parámetro
  const SearchBarDelegate({
    this.hintText = 'Buscar productos...', // Valor por defecto
  });
  // --- FIN DE LO QUE FALTA ---

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          // 3. Usamos la variable en lugar de texto fijo
          hintText: hintText, 
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}