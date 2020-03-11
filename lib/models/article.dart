class Article {
  static String table = 'article';

  final String title;
  final String description;
  final String image;
  final String author;
  final String content;

  Article(
      {this.title, this.description, this.image, this.author, this.content});

  factory Article.fromJson(Map json) {
    return new Article(
      title: json['title'],
      description: json['description'],
      image: json['urlToImage'],
      author: json['author'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'image': image,
      'author': author,
      'content': content,
    };
    return map;
  }

  static Article fromMap(Map<String, dynamic> map) {
    return Article(
        title: map['title'],
        description: map['description'],
        image: map['image'],
        author: map['author'],
        content: map['content']);
  }
}
