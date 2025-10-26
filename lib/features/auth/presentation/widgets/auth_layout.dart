import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar; // Aceptará nuestro CustomAppBar
  final Widget body;

  const AuthLayout({
    super.key,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    // Usa el color verde claro que definimos en el tema
    final backgroundColor = Theme.of(context).colorScheme.secondaryContainer;

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      // Usamos un SafeArea para que el contenido no se pegue al notch
      body: Stack(
        
        fit: StackFit.expand, // <--- ¡AÑADE ESTA LÍNEA!
        
        children: [
          
          // --- 1. LA CURVA DECORATIVA VERDE ---
          Positioned(
            bottom: -80, // La "escondemos" parcialmente abajo
            left: 0,
            right: 0,
            child: Container(
              height: 150, // Altura de la curva
              decoration: BoxDecoration(
                // Un verde un poco más oscuro que el fondo
                color: const Color(0xFFD6EAD6), 
                borderRadius: const BorderRadius.vertical(
                  // Una curva muy amplia
                  top: Radius.circular(500), 
                ),
              ),
            ),
          ),

          // --- 2. EL CONTENIDO DE TU PÁGINA ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              // ...
              child: body,
            ),
          ),
          
        ],
      ),
    );
  }
}