// article.dart

class Article {
  final String title;
  final String imageUrl;
  final String date;
  final String href;

  Article({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.href,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      date: json['date'] as String,
      href: json['href'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'date': date,
      'href': href,
    };
  }
}
