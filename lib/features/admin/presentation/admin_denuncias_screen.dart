import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:huerto_hogar_2/features/denuncias/data/denuncias_service.dart';

class AdminDenunciasScreen extends StatefulWidget {
  const AdminDenunciasScreen({super.key});

  @override
  State<AdminDenunciasScreen> createState() => _AdminDenunciasScreenState();
}

class _AdminDenunciasScreenState extends State<AdminDenunciasScreen> {
  final _service = DenunciasService();
  late Future<List<Denuncia>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getDenuncias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denuncias'),
      ),
      body: FutureBuilder<List<Denuncia>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar denuncias:\n${snapshot.error}'),
            );
          }

          final denuncias = snapshot.data ?? [];

          if (denuncias.isEmpty) {
            return const Center(child: Text('No hay denuncias registradas.'));
          }

          final dateFmt = DateFormat('dd-MM-yyyy HH:mm');

          return ListView.builder(
            itemCount: denuncias.length,
            itemBuilder: (context, index) {
              final d = denuncias[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        d.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  title: Text(d.descripcion),
                  subtitle: Text(
                    '${d.correo}\n${dateFmt.format(d.fecha)}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
