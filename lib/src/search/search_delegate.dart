import 'package:flutter/material.dart';
import 'package:flutter_peliculas/src/models/pelicula_model.dart';
import 'package:flutter_peliculas/src/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro appBar //limpiar cancelar busqueda
    return [
      IconButton(
        icon: Icon( Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar //icono regresar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close( context,null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }


  @override
  Widget buildSuggestions( BuildContext context){

    if( query.isEmpty ){
      return Container();
    }
    
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {


        if( snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text( pelicula.originalTitle ),
                onTap: (){
                  close( context, null );
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula );
                },
              );
            }).toList(),
          );
        }else{
          return Center(
            child: CircularProgressIndicator()
          );
        }


      },
    );

  }
}

/*

  final peliculas = [
    'Spiderman',
    'Volver al futuro',
    'E.t',
    'tmnt',
    'super mario bros',
    'metrika 27',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];



  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparececen cuando la persona escribe

    final listaSugerida = ( query.isEmpty ) ? peliculasRecientes: 
      peliculas.where( (p)=> p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: ( context, i){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text( listaSugerida[i] ),
          onTap: (){
            seleccion = listaSugerida[i];
            showResults( context );
          },
        );
      },
    );
  }
*/