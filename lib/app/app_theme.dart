import 'package:flutter/material.dart';

class AppTheme {
  // Define tus colores
  static const Color colorVerdeClaro = Color(0xFFE6F5E6); // Hice una suposición del color, ajústalo
  static const Color colorVerdePrincipal = Color(0xFF4CAF50); // El verde de los botones
  static const Color colorBlanco = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorVerdePrincipal,
      brightness: Brightness.light,
      // Color de fondo por defecto para la app principal
      background: colorBlanco, 
      // Color de fondo para pantallas de autenticación
      secondaryContainer: colorVerdeClaro,
    ),
    
    scaffoldBackgroundColor: colorBlanco, // Fondo por defecto
    
    // Define el estilo por defecto de los AppBars
    appBarTheme: const AppBarTheme(
      backgroundColor: colorBlanco, // AppBar blanco por defecto
      foregroundColor: Colors.black, // Íconos y texto negros por defecto
      elevation: 0,
      centerTitle: true,
    ),
  );
}