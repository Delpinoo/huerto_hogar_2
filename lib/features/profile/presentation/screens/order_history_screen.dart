import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/custom_app_bar.dart';
import 'package:huerto_hogar_2/features/profile/domain/order_model.dart';
import 'package:huerto_hogar_2/features/profile/presentation/widgets/order_history_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ¡Sin Scaffold! El MainAppLayout se encarga.
    return Column(
      children: [
        // --- 1. EL APPBAR REUTILIZABLE ---
        CustomAppBar(
          title: 'Historial de Pedidos',
          backgroundColor: Colors.white,
          // Flecha de 'atrás' que SÍ funciona
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Como llegamos con 'push', podemos usar 'pop'
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
        ),
        
        // --- 2. LA LISTA DE PEDIDOS ---
        Expanded(
          child: ListView.builder(
            itemCount: dummyOrders.length, // Usa nuestra lista falsa
            itemBuilder: (context, index) {
              final order = dummyOrders[index];
              return OrderHistoryCard(order: order);
            },
          ),
        ),
      ],
    );
  }
}