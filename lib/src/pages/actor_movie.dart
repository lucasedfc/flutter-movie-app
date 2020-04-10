import 'package:flutter/material.dart';
import 'package:movie_app/src/models/actors_model.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/providers/movie_provider.dart';
import 'package:movie_app/src/widgets/movie_vertical.dart';

class ActorPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('${actor.name} Movies'),
        backgroundColor: Colors.indigoAccent,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
              child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _getActorCredit(actor)
              ],
          ),
        ),
      ),
    );
  
  }

  Widget _getActorCredit(Actor actor) {
    final movieProvider = new MovieProvider();

    return FutureBuilder(
      future: movieProvider.actorCredit(actor.id.toString()),
      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          return _createActorMovies(context, snapshot.data);
        } else {
          return Center(
            child: LinearProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createActorMovies(BuildContext context, List<Movie> movies) {
    return Container(
      //width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: MovieVertical(
                movies: movies,
            ))
        ],
      ),
    );
  }

  
}