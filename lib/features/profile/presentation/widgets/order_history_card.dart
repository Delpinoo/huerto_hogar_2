import 'package:flutter/material.dart';
import 'package:huerto_hogar_2/features/profile/domain/order_model.dart';

class OrderHistoryCard extends StatelessWidget {
  final Order order;

  const OrderHistoryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // Ícono
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.receipt_long_outlined, color: Colors.grey[700]),
        ),
        
        // Título y Subtítulo
        title: Text(
          order.id,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${order.date} · ${order.itemCount} items',
          style: TextStyle(color: Colors.grey[600]),
        ),
        
        // Información de la derecha
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${order.total.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            _buildStatusChip(order.status), // El chip de estado
          ],
        ),
        onTap: () {
          // TODO: Navegar al detalle del pedido (ej. /order-history/HU-12345)
        },
      ),
    );
  }

  // Helper para el chip de estado ("Entregado", "Cancelado")
  Widget _buildStatusChip(String status) {
    Color color;
    Color textColor;

    switch (status) {
      case 'Entregado':
        color = Colors.green.withOpacity(0.1);
        textColor = Colors.green[800]!;
        break;
      case 'Cancelado':
        color = Colors.red.withOpacity(0.1);
        textColor = Colors.red[800]!;
        break;
      default: // 'En Camino'
        color = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}