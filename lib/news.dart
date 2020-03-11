import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models/article.dart';
import 'services/db.dart';
import 'article.dart';

class FlutterNews extends StatefulWidget {
  @override
  _FlutterNewsState createState() => _FlutterNewsState();
}

class _FlutterNewsState extends State<FlutterNews> {
  Future<List<Article>> futureArticles;

  Future<List<Article>> fetchArticles() async {
    try {
      final Response<dynamic> response = await Dio().get(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=ef02f6e6a4d54d0eac801e9a3ed31555');
      print('Online');
      List<Article> article = [];
      (response.data['articles'] as List).forEach((item) {
        article.add(Article.fromJson(item));
      });

      await DB.delete(Article.table);

      for (var i = 0; i < article.length; i++) {
        Article item = Article(
            title: article[i].title,
            description: article[i].description,
            image: article[i].image,
            author: article[i].author,
            content: article[i].content);

        await DB.insert(Article.table, item);
      }

      return article;
    } catch (e) {
      print('Offline');
      final List<Map<String, dynamic>> maps = await DB.query('article');

      final article = List.generate(maps.length, (i) {
        return Article(
            title: maps[i]['title'],
            description: maps[i]['description'],
            image: maps[i]['image'],
            author: maps[i]['author'],
            content: maps[i]['content']);
      });

      return article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter News'),
        ),
        body: FutureBuilder<List<Article>>(
          future: fetchArticles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ArticleScreen(article: snapshot.data[index]))),
                    child: (Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: ListTile(
                              title: Text(snapshot.data[index].title),
                              subtitle: Text(
                                snapshot.data[index].description ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
