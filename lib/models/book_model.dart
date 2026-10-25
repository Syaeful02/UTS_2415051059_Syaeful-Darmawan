class BookModel {
  final String id;
  final String title;
  final String authors;
  final String description;
  final String thumbnail;
  final String publishedDate;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.publishedDate,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    
    String authorList = 'Unknown Author';
    if (volumeInfo['authors'] != null) {
      authorList = (volumeInfo['authors'] as List).join(', ');
    }

    String imageUrl = 'https://via.placeholder.com/150x200?text=No+Image';
    if (volumeInfo['imageLinks'] != null && volumeInfo['imageLinks']['thumbnail'] != null) {
      imageUrl = volumeInfo['imageLinks']['thumbnail'].toString().replaceAll('http://', 'https://');
    }

    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      authors: authorList,
      description: volumeInfo['description'] ?? 'No description available.',
      thumbnail: imageUrl,
      publishedDate: volumeInfo['publishedDate'] ?? '-',
    );
  }
}