
class Communa {
  final String name;
  final String postalCode;

  Communa({required this.name, required this.postalCode});

  factory Communa.fromJson(Map<String, dynamic> json) {
    return Communa(
      name: json['name'] as String,
      postalCode: json['postalCode'] as String,
    );
  }
}

class Region {
  final String name;
  final String romanNumber;
  final String number;
  final List<Communa> communes;

  Region({
    required this.name,
    required this.romanNumber,
    required this.number,
    required this.communes,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    // Mapea la lista de comunas
    final List<dynamic> communesList = json['communes'];
    final List<Communa> communes = communesList
        .map((c) => Communa.fromJson(c as Map<String, dynamic>))
        .toList();

    return Region(
      name: json['name'] as String,
      romanNumber: json['romanNumber'] as String,
      number: json['number'] as String,
      communes: communes,
    );
  }
}