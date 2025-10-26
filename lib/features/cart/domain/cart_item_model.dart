// Usaremos el modelo de producto que ya tenemos
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}