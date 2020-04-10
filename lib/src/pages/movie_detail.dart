import 'package:flutter/material.dart';
import 'package:movie_app/src/models/actors_model.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/providers/movie_provider.dart';

class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;



    final screenSize = MediaQuery.of(context).size;

    final _pageController = new PageController(
       initialPage: 1,
       viewportFraction: 0.3
    );

    _pageController.addListener(() {
      if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
        _pageController.position.animateTo(
          _pageController.position.maxScrollExtent - screenSize.width * 0.35,
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
        );
      }
      if (_pageController.position.pixels == _pageController.position.minScrollExtent) {
        _pageController.position.animateTo(
          screenSize.width * 0.3,
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
        );
      }
    }
    
    );

    return Scaffold(

      body: CustomScrollView(
      slivers: <Widget>[
        _createAppbar(movie),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _posterTitle(context, movie),
            _description(movie),
            _createCasting(movie)
          ]),
        )
      ],
    ));
  }

  Widget _createAppbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(movie.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        background: FadeInImage(
          image: NetworkImage(movie.getBackDropImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 20),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie) {

    final movieYear = DateTime.parse(movie.releaseDate);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${movie.title} (${movieYear.year.toString()}) ',
                    style: Theme.of(context).textTheme.title,
                    overflow: TextOverflow.ellipsis),
                Text(movie.originalTitle,
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(),
                        style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Movie movie) {
    final movieProvider = new MovieProvider();

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _createActorPageView( context, snapshot.data);
        } else {
          return Center(
            child: LinearProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createActorPageView(BuildContext context, List<Actor> actors) {

    final screenSize = MediaQuery.of(context).size;
    final _pageController = new PageController(
       initialPage: 1,
       viewportFraction: 0.3
    );

    _pageController.addListener(() {
      if (_pageController.position.pixels == _pageController.position.maxScrollExtent) {
        _pageController.position.animateTo(
          _pageController.position.maxScrollExtent - screenSize.width * 0.35,
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
        );
      }
      if (_pageController.position.pixels == _pageController.position.minScrollExtent) {
        _pageController.position.animateTo(
          screenSize.width * 0.3,
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
        );
      }
    }
    
    );

    
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: actors.length,
        itemBuilder: (context, i) => actorCard(context, actors[i]),
      ),
    );
  }

  Widget actorCard(BuildContext context, Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'actor', arguments: actor);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  image: NetworkImage(actor.getPhoto()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  height: 150.0,
                  fit: BoxFit.cover),
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis),
          Text(actor.character, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
