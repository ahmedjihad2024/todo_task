

class Source {
  String id;
  String name;
  Source(this.id, this.name);
}

class Article {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;
  Source? source;

  Article(this.author, this.source, this.content, this.title, this.description,
      this.publishedAt, this.url, this.urlToImage);


}

class Articles {
  List<Article> articles;
  Articles(this.articles);
}

class RegisterDetails {
  final String id;
  final String userName;
  final String accessToken;
  final String refreshToken;

  const RegisterDetails(
      {required this.id,
        required this.userName,
        required this.accessToken,
        required this.refreshToken});
}

class TaskId{
  final String? id;
  TaskId({required this.id});
}