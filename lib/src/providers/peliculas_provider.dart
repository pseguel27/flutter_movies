import 'dart:convert'; //json

import 'package:http/http.dart' as http;
import 'package:flutter_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey    = 'e6af43ec510546407bff0b3bb7e38413';
  String _url       = 'api.themoviedb.org';
  String _languaje  = 'es-ES';

  Future<List<Pelicula>> _procesarResuesta( Uri url) async {
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList( decodedData['results'] );

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'languaje' : _languaje,
    });

    return await _procesarResuesta( url );
  }


  Future<List<Pelicula>> getPopulares() async {
    
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'languaje' : _languaje,
    });

    return await _procesarResuesta( url );
  }

}