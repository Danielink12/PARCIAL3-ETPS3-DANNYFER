import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parcial3dannyfer/json/estudiante.dart';
import 'package:http/http.dart' as http;

/* 
  Parcial realizo por:
  Daniel Elias Alas Deras 25-0457-2018
  Fernando Antonio Flores Cornejo 25-1840-2018
*/

Future<Nasa> fNasa() async {
  final response =
      await http.get(Uri.parse('https://www.freetogame.com/api/game?id=452'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Nasa.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Nasa {
  final String title;
  final String hdurl;

  const Nasa({
    required this.title,
    required this.hdurl,
  });

  factory Nasa.fromJson(Map<String, dynamic> json) {
    return Nasa(
      title: json['title'],
      hdurl: json['thumbnail'],
    );
  }
}

void main() => runApp(Home());

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FREE TO GAME',
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<Nasa> futureNasa;

  @override
  void initState() {
    super.initState();
    futureNasa = fNasa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: barraApp(),
      body: Contenido(),
    );
  }

  Widget TituloImagen() {
    return FutureBuilder<Nasa>(
      future: futureNasa,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget imagen() {
    return FutureBuilder<Nasa>(
      future: futureNasa,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.network(snapshot.data!.hdurl);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  //METODO - BARRA APP
  barraApp() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 4, 4, 80),
      elevation: 10,
      //LO ENVOLVEMOS EN UN PADDING
      title: Padding(
        //margen
        padding: const EdgeInsets.only(left: 10, right: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //titulo
          Text(
            "API FREE TO GAME",
            //estilo del texto
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }

  Widget Contenido() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Desarrollado por",
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: List.generate(estudiantes.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 180,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(estudiantes[index]['img']),
                                  fit: BoxFit.cover),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(child: TituloImagen()),
          SizedBox(
            height: 30,
          ),
          Center(child: imagen()),
        ],
      ),
    );
  }
}
