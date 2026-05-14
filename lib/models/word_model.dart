/// Modèle représentant un mot du dictionnaire bilingue.
class WordModel {
  final String francais;
  final String lingala;

  WordModel({required this.francais, required this.lingala});

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      francais: (json['francais'] ?? '').toString(),
      lingala: (json['lingala'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'francais': francais,
        'lingala': lingala,
      };

  /// Identifiant unique (utilisé pour favoris/historique).
  String get id => '$francais|$lingala';

  @override
  bool operator ==(Object other) => other is WordModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
