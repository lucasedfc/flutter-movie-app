import 'package:flutter/material.dart';
import 'package:movie_app/src/models/movie_model.dart';

class MovieVertical extends StatelessWidget {
  final List<Movie> movies;

  MovieVertical({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    final _pageController =
        new PageController(initialPage: 0, viewportFraction: 0.8);

      // set up listener here
      _pageController.addListener(() {
        if (_pageController.position.atEdge) {
          if (_pageController.position.pixels == 0) {
            _pageController.position.animateTo(
              _pageController.position.pixels + 50.0,
              duration: Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
            );
          }
          // you are at top position
          else {
            _pageController.position.animateTo(
              _pageController.position.maxScrollExtent - 10.0,
              duration: Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
            );
          }
          // you are at bottom position
        }
      });

    return Container(
      height: _screenSize.height.toDouble(),
      child: PageView.builder(
          scrollDirection: Axis.vertical,
          pageSnapping: false,
          controller: _pageController,
          itemCount: movies.length,
          itemBuilder: (context, i) => _card(context, movies[i])),
      // children: _cards(context))
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    final _screenSize = MediaQuery.of(context).size;

    movie.uniqueId = UniqueKey().toString();

    var movieYear;
    if (movie.releaseDate.isNotEmpty) {
      movieYear = DateTime.parse(movie.releaseDate).year;
    } else {
      movieYear = '----';
    }

    final movieCard = Container(
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(
                  movie.getPosterImg(),
                ),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: _screenSize.height.toDouble() * 0.70,
              ),
            ),
          ),
          Text('${movie.title} (${movieYear.toString()})',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle),
        ],
      ),
    );

    return GestureDetector(
      child: movieCard,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }
}
