// ...existing code...
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double envio;
  final double promocion;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.envio,
    required this.promocion,
    required this.total,
  });

  // Helper para formatear los precios
  String _formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', _formatPrice(subtotal)),
            const SizedBox(height: 12),
            _buildSummaryRow('Envío', _formatPrice(envio)),
            const SizedBox(height: 12),
            _buildSummaryRow('Promoción', _formatPrice(promocion), isPromotion: true),
            const Divider(height: 24),
            _buildSummaryRow('Total', _formatPrice(total), isTotal: true),
          ],
        ),
      ),
    );
  }

  // Widget helper para cada fila
  Widget _buildSummaryRow(String title, String amount, {bool isPromotion = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isPromotion ? Colors.red : (isTotal ? Colors.green[700] : Colors.black87),
          ),
        ),
      ],
    );
  }
}
// ...existing code...