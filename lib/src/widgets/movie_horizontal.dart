import 'package:flutter/material.dart';
import 'package:flutter_peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });

  final _pageController = new PageController(          
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of( context ).size;
    
    //escuchar cambios en pageViewCOntroller
    _pageController.addListener((){
      
      if( _pageController.position.pixels >= _pageController.position.maxScrollExtent -200 ){
        //print('carga nuevos populares');
        siguientePagina();
      }

    });
    
    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: ( context,i  ) => _tarjeta( context, peliculas[i], _screenSize ),
        //children: _tarjetas( context ),
      ),
    );
  }

  Widget _tarjeta( BuildContext context, Pelicula pelicula, Size screen ){

      pelicula.uniqueId = '${ pelicula.id }-poster';

      final tarjeta = Container(
        margin: EdgeInsets.only( right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: screen.height * 0.2,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text( 
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of( context ).textTheme.caption,
            )
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          Navigator.pushNamed(context, 'detalle',arguments: pelicula);
        },
      );
  }

 /*List<Widget> _tarjetas( context ){

    return peliculas.map( ( pelicula ) {
      return Container(
        margin: EdgeInsets.only( right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage( pelicula.getPosterImg() ),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text( 
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of( context ).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }*/

}