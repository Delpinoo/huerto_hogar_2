import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:huerto_hogar_2/common/widgets/primary_button.dart';
import 'package:huerto_hogar_2/features/products/data/product_repository.dart';
import 'package:huerto_hogar_2/features/products/domain/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _supplierCtrl = TextEditingController();
  final _originCtrl = TextEditingController();

  File? _pickedImage;
  bool _saving = false;

  late final ProductRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = ProductRepository();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _supplierCtrl.dispose();
    _originCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x != null) setState(() => _pickedImage = File(x.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      // 1) Subir imagen si existe
      String imageUrl = '';
      if (_pickedImage != null) {
        imageUrl = await _repo.uploadProductImage(_pickedImage!);
      }

      // Limpia símbolos y convierte coma a punto (ej: "$2.990" -> "2990" -> 2990.0)
      final raw = _priceCtrl.text.trim();
      final normalized = raw
          .replaceAll(RegExp(r'[^0-9,.\-]'), '') // deja solo dígitos/coma/punto/signo
          .replaceAll(',', '.');                 // coma -> punto

      final parsedPrice = double.tryParse(normalized);
      if (parsedPrice == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Precio inválido. Usa números, ej: 2990 o 29.90')),
          );
        }
        setState(() => _saving = false);
        return;
      }

      // 2) Crear modelo Product (ajusta tipos a tu Product)
      final product = Product(
        id: '', // Supabase lo genera
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        price: parsedPrice, // en tu modelo es String
        imageUrl: imageUrl,
        supplier: _supplierCtrl.text.trim(),
        origin: _originCtrl.text.trim(),
      );

      // 3) Insertar
      await _repo.addProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado')),
        );
        context.pop(); // volver a admin o a donde vengas
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Imagen
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _pickedImage != null
                        ? DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _pickedImage == null
                      ? const Center(child: Text('Toca para seleccionar imagen'))
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Nombre
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),

              // Descripción
              TextFormField(
                controller: _descCtrl,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // Precio (string)
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Precio (ej: \$2990 o 2990)',
                  filled: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),

              // Proveedor
              TextFormField(
                controller: _supplierCtrl,
                decoration: const InputDecoration(
                  labelText: 'Proveedor',
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),

              // Origen
              TextFormField(
                controller: _originCtrl,
                decoration: const InputDecoration(
                  labelText: 'Origen',
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _saving ? 'Guardando...' : 'Guardar',
                  onPressed: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
