import 'dart:async';
import 'dart:convert';

import 'package:movie_app/src/models/actors_model.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieProvider {
  String _apiKey = '67e526574227c0660c9af6e76aff122b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPage = 0;
  bool _loading = false;

  List<Movie> _popular = new List();

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Movie>> _processData(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _processData(url);
  }

  Future<List<Movie>> searchMovie( String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {
          'api_key': _apiKey, 
          'language': _language,
          'query': query
        });

    return await _processData(url);
  }

  Future<List<Movie>> actorCredit( String id) async {
    final url = Uri.https(_url, '3/person/$id/movie_credits',
        {
          'api_key': _apiKey, 
          'language': _language,
          'person_id': id
        });

        final resp = await http.get(url);
        final decodedData = json.decode(resp.body);
        final movies = new Movies.fromJsonList(decodedData['cast']);
        return movies.items;
    
  }

  Future<List<Actor>> getCast( String movieId) async {

    final url = Uri.https(_url, '3/movie/$movieId/credits',
    {'api_key': _apiKey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  }

  Future<List<Movie>> getPopular() async {

    if(_loading) return [];
    _loading = true;
    _popularPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularPage.toString()
    });

    final resp = await _processData(url);

    // Add stream data
    _popular.addAll(resp);
    popularSink(_popular);

_loading = false;
    return resp;
  }
}
