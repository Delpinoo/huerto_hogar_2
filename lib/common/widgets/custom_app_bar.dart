import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading; // Botón izquierdo (flecha, menú, etc.)
  final String? title; // Título (opcional)
  final List<Widget>? actions; // Botones derechos (carrito, editar, etc.)
  final Color? backgroundColor; // Color de fondo (opcional)

  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      // Si no nos pasan un 'leading', no muestra nada
      leading: leading,
      // Si nos pasan un título, lo muestra
      title: title != null ? Text(title!, style: theme.textTheme.titleLarge) : null,
      // Si nos pasan acciones, las muestra
      actions: actions,
      // Usa el color pasado, o el color por defecto del tema
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
    );
  }

  // Esto es necesario para que Flutter lo acepte como un AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}