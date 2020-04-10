import 'package:flutter/material.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/providers/movie_provider.dart';

class DataSearch extends SearchDelegate {
  
  final movieProvider = new MovieProvider();

String selected = '';

  final movies = [
    'Titanic',
    'Rapido y furioso',
    'Rambo',
    'Conan',
    'Terminator',
    'Rocky',
    'Cars',
    '1917',
    'Los simpsons'
  ];

  final recentMovies = [
  'Spiderman',
  'Hulk'
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // Action appBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icon on the left
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Builder for the results
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(selected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions when someone is typing

    /* final searchList = (query.isEmpty)
                        ? recentMovies
                        : movies.where( 
                          (movie) => movie.toLowerCase().startsWith(query.toLowerCase())
                        ).toList();

    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(searchList[index]),
          onTap: () {
            selected = searchList[index];
            showResults(context);
          },
        );
      }
      ); */

      if( query.isEmpty) {
        return Container();
      } 

      return FutureBuilder(
        future: movieProvider.searchMovie(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if(snapshot.hasData) {

            final movies = snapshot.data;

            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.originalTitle),
                  onTap: () {
                    close(context, null);
                    movie.uniqueId = UniqueKey().toString();
                    Navigator.pushNamed(context, 'detail', arguments: movie);
                  },
                );
                }).toList()
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }

}