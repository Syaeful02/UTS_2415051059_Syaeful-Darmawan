class DraftModel {
  final int? id;
  final String title;
  final String genre;
  final String synopsis;
  final String status;
  final DateTime? createdAt;

  DraftModel({
    this.id,
    required this.title,
    required this.genre,
    required this.synopsis,
    required this.status,
    this.createdAt,
  });

  factory DraftModel.fromMap(Map<String, dynamic> map) {
    return DraftModel(
      id: map['id'],
      title: map['title'] ?? '',
      genre: map['genre'] ?? '',
      synopsis: map['synopsis'] ?? '',
      status: map['status'] ?? 'Draft',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'genre': genre,
      'synopsis': synopsis,
      'status': status,
    };
  }
}