import 'dart:convert';
import 'package:huerto_hogar_2/common/api_client.dart';


class Denuncia {
  final int id;
  final String correo;
  final String descripcion;
  final String imageUrl;
  final DateTime fecha;

  Denuncia({
    required this.id,
    required this.correo,
    required this.descripcion,
    required this.imageUrl,
    required this.fecha,
  });

  factory Denuncia.fromJson(Map<String, dynamic> json) {
    return Denuncia(
      id: json['id'],
      correo: json['correo'],
      descripcion: json['descripcion'],
      imageUrl: json['image_url'],
      fecha: DateTime.parse(json['fecha'].replaceFirst(' ', 'T')),
    );
  }
}

class DenunciasService {
  final _api = ApiClient();

  Future<List<Denuncia>> getDenuncias() async {
    final resp = await _api.get(
      '/api/denuncias',
      auth: true, // 👈 IMPORTANTE
    );

    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      return list.map((e) => Denuncia.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener denuncias: ${resp.body}');
    }
  }

  Future<void> crearDenuncia({
    required String descripcion,
    required String fotoBase64,
    double? lat,
    double? lng,
  }) async {
    final body = {
      'descripcion': descripcion,
      'foto': fotoBase64,
      'ubicacion': {
        'lat': lat,
        'lng': lng,
      },
    };

    final resp = await _api.post('/api/denuncias', body);

    if (resp.statusCode != 201) {
      throw Exception('Error al crear denuncia: ${resp.body}');
    }
  }
}
