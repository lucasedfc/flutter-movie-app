import 'package:flutter/material.dart';
import 'package:movie_app/src/pages/actor_movie.dart';
import 'package:movie_app/src/pages/home_page.dart';
import 'package:movie_app/src/pages/movie_detail.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': ( BuildContext context) => HomePage(),
        'detail': (BuildContext context) => MovieDetail(),
        'actor': (BuildContext context) => ActorPage()
      }
    );
  }
}