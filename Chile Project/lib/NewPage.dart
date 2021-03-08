//IMPORTACIONES DE TERCEROS
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:postapp/main.dart';
import 'package:postapp/util/menu.dart';

import 'authentication/bloc/authentication_bloc.dart';

//PRIMERO TRAER DATOS
Future<Album> fetchAlbum(url) async {
  var response = await http.get(url);

  if (response.statusCode == 200) {
    // Esperando respuesta.

    return Album.fromJson(jsonDecode(response.body));
  } else {
    //Sino lanza excepcion
    throw Exception('Fallo al cargar');
  }
}

//LUEGO ACTUALIZAR DATOS SI ES ONPRESSED
Future<Album> updateAlbum() async {
  final http.Response response = await http.get('https://dany.pw/api.php');

  if (response.statusCode == 200) {
    // Espera respuesta
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // Sino lanza excepcion
    throw Exception('Error de sistema .');
  }
}

class Album {
  String valor1;
  String valor2;
  String valor3;

  Album({this.valor1, this.valor2, this.valor3});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      valor1: json['valor1'],
      valor2: json['valor2'],
      valor3: json['valor3'],
    );
  }
}

class NewPage extends StatefulWidget {
  NewPage({this.username, this.token});
  final String username;
  final String token;

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  var autorizado = 0;
  String msg = 'Verificando...';

  Future<List> _tokensito() async {
    final response = await http.post("https://dany.pw/token.php", body: {
      "token": '$token',
    });

    var datauser = json.decode(response.body);

    if (datauser.length == 0) {
      setState(() {
        msg = "Token no autorizado";
      });
    } else {
      setState(() {
        msg = "Token autorizado";
        var autorizado = 1;
      });
    }

    return datauser;
  }

  String url;
  Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    // _tokensito();

    url = "https://dany.pw/api.php";
    _futureAlbum = fetchAlbum(this.url);
  }

  @override
  Widget build(BuildContext context) {
    const PrimaryColor = const Color(0xFFfccf03);
    return MaterialApp(
      title: 'Pantalla 2 Indicadores Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          drawer: MenuLateral(),
          appBar: AppBar(
             backgroundColor: PrimaryColor,
            title: Text('Pantalla 2 Indicadores Admin',style: TextStyle(
    color: Colors.black
  )),
          ),
          body: Center(
            child: FutureBuilder<Album>(
              future: _futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ///////////////////////////////////
                  var opciones = [
                    snapshot.data.valor1.toString(),
                    snapshot.data.valor2.toString(),
                    snapshot.data.valor3.toString()
                  ];
                  return ListView(
                    children: crearItems(opciones),
                  );
                  /////////////////////////////////////

                  //   return Text(snapshot.data.titulo);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // cargando.........
                return CircularProgressIndicator();
              },
            ),
          ),
          floatingActionButton:
              _crearBotones() //MANDAMOS A LLAMAR A CREAR BOTONES
          ),
    );
  }

  //creamos los botones
  Widget _crearBotones() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          width: 30.0,
        ),

        SizedBox(
          width: 30.0,
        ),

        Expanded(
            child: SizedBox(
          width: 5.0,
        )),
        FloatingActionButton(
            child: Text(
              "Refresh",
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
            ),
            onPressed: _refresh),
        //FloatingActionButton(
        //child: Text("Otra Pagina",style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),onPressed: _ir),

        RaisedButton(
          child: Text("Cerrar Sesion"),
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(PushLoginPage());
          },
        ),
        RaisedButton(
          child: Text("Volver"),
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(PushAdminPage());
          },
        ),

        // Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
        Text(
          '   Hola $username, Bienvenido a la aplicación                  ',
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }

// WIDGET LISTA
  List<Widget> crearItems(opciones) {
    var lista = List<Widget>();
    for (String opt in opciones) {
      var tempWidget = ListTile(title: Text(opt));
      lista.add(tempWidget);
      // Divider es un widget que crea una division entre cada elemento de la lista.
      // Agregamos un Divider debajo de cada elemento de la lista
      lista.add(Divider());
    }
    return lista;
  }

//FUNCION VACIA TIPO VOID SIN RETORNO
  void _refresh() {
    setState(() {
      //ACTUALIZA ESTADO
      _futureAlbum = updateAlbum();
    });
  }

  void _ir() {
    setState(() {
      //ACTUALIZA ESTADO

      Navigator.pushReplacementNamed(context, '/AdminPage');
    });
  }
}
