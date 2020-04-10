import 'package:flutter/material.dart';
import 'package:movie_app/src/providers/movie_provider.dart';
import 'package:movie_app/src/search/search_delegate.dart';
import 'package:movie_app/src/widgets/card_swiper_widget.dart';
import 'package:movie_app/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = new MovieProvider();

  @override
  Widget build(BuildContext context) {

    moviesProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies on Cinema'),
        backgroundColor: Colors.indigoAccent,
        centerTitle: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), 
          onPressed: () {
            showSearch(
              context: context, 
              delegate: DataSearch()
            );
          }
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swiperCard(), _footer(context)],
        ),
      ),
    );
  }

  Widget _swiperCard() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );

    // moviesProvider.getNowPlaying();
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Popular', style: Theme.of(context).textTheme.subhead)),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                movies: snapshot.data,
                nextPage: moviesProvider.getPopular
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
              
            },
          ),
        ],
      ),
    );
  }
}
