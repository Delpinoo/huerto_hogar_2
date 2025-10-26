class Order {
  final String id;
  final String date;
  final double total;
  final String status; // 'Entregado', 'En Camino', 'Cancelado'
  final int itemCount;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.itemCount,
  });
}

// --- NUESTRA BASE DE DATOS FALSA ---
final List<Order> dummyOrders = [
  Order(
    id: '#HU-12345',
    date: '22 Oct, 2025',
    total: 12990,
    status: 'Entregado',
    itemCount: 3,
  ),
  Order(
    id: '#HU-12333',
    date: '15 Oct, 2025',
    total: 8500,
    status: 'Entregado',
    itemCount: 2,
  ),
  Order(
    id: '#HU-12301',
    date: '01 Oct, 2025',
    total: 4990,
    status: 'Cancelado',
    itemCount: 1,
  ),
];