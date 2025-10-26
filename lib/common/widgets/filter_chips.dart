import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({super.key});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  // Estado para guardar el índice del chip seleccionado
  int _selectedIndex = 0;
  final List<String> _options = ['Todo', 'Frutas', 'Verduras', 'Orgánico'];

  @override
  Widget build(BuildContext context) {
    // Ponemos los chips en un Sliver para que se integren
    // directamente en nuestras pantallas (HomeScreen y SearchScreen)
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: _options.length,
          itemBuilder: (context, index) {
            final bool isSelected = _selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(_options[index]),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedIndex = index; // Actualiza el chip seleccionado
                  });
                },
                selectedColor: Colors.green,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
                backgroundColor: Colors.grey[200],
                shape: const StadiumBorder(),
              ),
            );
          },
        ),
      ),
    );
  }
}