import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screen_protector/screen_protector.dart';

import 'package:huerto_hogar_2/features/denuncias/data/denuncias_service.dart';

class DenunciasPage extends StatefulWidget {
  const DenunciasPage({super.key});

  @override
  State<DenunciasPage> createState() => _DenunciasPageState();
}

class _DenunciasPageState extends State<DenunciasPage> {
  final _denunciasService = DenunciasService();
  final _descCtrl = TextEditingController();

  bool _loading = false;
  String? _fotoBase64;

  @override
  void initState() {
    super.initState();
    _initSecurity();
  }

  Future<void> _initSecurity() async {
    await ScreenProtector.preventScreenshotOn();
  }

  @override
  void dispose() {
    ScreenProtector.preventScreenshotOff();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 60,
    );

    if (img == null) return;

    final bytes = await img.readAsBytes();
    setState(() {
      _fotoBase64 = base64Encode(bytes);
    });
  }

  Future<void> _enviarDenuncia() async {
    if (_fotoBase64 == null || _descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta descripción o foto')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _denunciasService.crearDenuncia(
        descripcion: _descCtrl.text,
        fotoBase64: _fotoBase64!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Denuncia enviada con éxito')),
        );
        _descCtrl.clear();
        _fotoBase64 = null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Denuncias')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Tomar foto'),
            ),
            const SizedBox(height: 8),
            Text(_fotoBase64 == null ? 'Sin foto' : 'Foto lista ✔'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _enviarDenuncia,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Enviar denuncia'),
            ),
          ],
        ),
      ),
    );
  }
}
