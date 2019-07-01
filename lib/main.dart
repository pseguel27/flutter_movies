import 'package:flutter/material.dart';
import 'package:flutter_peliculas/src/pages/home_page.dart';
//snippet mateApp para iniciar proyecto hw 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //quitar cinta debug arriba
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/'   : ( BuildContext context ) => HomePage(),
      }
    );
  }
}