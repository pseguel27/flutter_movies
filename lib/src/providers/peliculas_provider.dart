import 'dart:async';
import 'dart:convert'; //json
import 'package:flutter_peliculas/src/models/actores_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey    = 'e6af43ec510546407bff0b3bb7e38413';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularesPage = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarResuesta( Uri url) async {
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList( decodedData['results'] );

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'language' : _language,
    });

    return await _procesarResuesta( url );
  }


  Future<List<Pelicula>> getPopulares() async {
    
    if(_cargando) return [];
    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString(),
    });

    final resp = await _procesarResuesta( url );
    _populares.addAll(resp);
    popularesSink( _populares );

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast( String peliId ) async{
    
    final url = Uri.https( _url, '3/movie/$peliId/credits',{
      'api_key'  : _apikey,
      'language' : _language,
    });

    final resp = await http.get( url );
    final decodedData = json.decode ( resp.body );

    final cast = new Cast.fromJsonList( decodedData['cast']);
    return cast.actores;

  }

}