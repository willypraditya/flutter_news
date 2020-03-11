import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'models/article.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  ArticleScreen({@required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter News'),
      ),
      body: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                article.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Center(
              child: CachedNetworkImage(
                imageUrl: article.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              // child: Image(image: NetworkImage(article.image)),
            ),
            Padding(
                padding: EdgeInsets.all(10), child: Text(article.content ?? ''))
          ],
        ),
      ),
    );
  }
}
