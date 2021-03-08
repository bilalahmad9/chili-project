//IMPORTACIONES DE TERCEROS
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:postapp/authentication/bloc/authentication_bloc.dart';
import 'package:postapp/main.dart';
import 'package:postapp/util/menu.dart';
import 'package:postapp/util/token_check.dart';

//PRIMERO TRAER DATOS
Future<Album> fetchAlbum() async {
  var response = await http.get('https://dany.pw/api.php');

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

class AdminPage extends StatefulWidget {
  var autorizado = 0;

  //AdminPage({Key key}) : super(key:  key);
  AdminPage({this.username, this.token});
  final String username;
  final String token;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String msg = '';

  Future<List> tokensito() async {
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
        msg = "";
        BlocProvider.of<AuthenticationBloc>(context).add(PushNewPAge());
      });
    }

    return datauser;
  }

  Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
     const PrimaryColor = const Color(0xFFfccf03);
    return MaterialApp(
      title: 'Aplicacion conectada a Internet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            title: Text('Tabla de Indicadores',style: TextStyle(
    color: Colors.black
  )),
            elevation: 0,
          ),
          drawer: MenuLateral(),
          body: Column(
            children: [
             // SizedBox(height: MediaQuery.of(context).size.height / 3.5),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Center(
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.15,
                    color: Colors.black.withOpacity(0.45),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                    ),
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
                          // return ListView(
                          //   children: crearItems(opciones),
                          //   );

                          return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20,
                                  sortColumnIndex: 2,
                                  sortAscending: false,
                                  columns: [
                                    DataColumn(label: Text("Tipo Cliente")),
                                    DataColumn(label: Text("Plazo 0 - 30")),
                                    DataColumn(label: Text("Plazo 31 - 60")),
                                    DataColumn(label: Text("Pazo 61 - 90")),
                                    DataColumn(label: Text("Pazo 61 - 90")),
                                    DataColumn(label: Text("Pazo 91 - 120")),
                                    DataColumn(label: Text("Pazo > 120")),
                                  ],
                                  rows: [
                                    DataRow(selected: true, cells: [
                                      DataCell(Text("RIESGOSO")),
                                      DataCell(Text(opciones[1])),
                                      DataCell(Text(opciones[1])),
                                      DataCell(Text(opciones[0])),
                                      DataCell(Text(opciones[0])),
                                      DataCell(Text(opciones[2])),
                                      DataCell(Text(opciones[2])),
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text("TOTAL:")),
                                      DataCell(Text(opciones[2])),
                                      DataCell(Text(opciones[2])),
                                      DataCell(Text(opciones[0])),
                                      DataCell(Text(opciones[0])),
                                      DataCell(Text(opciones[1])),
                                      DataCell(Text(opciones[1])),
                                    ])
                                  ],
                                ),

                              ));

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

                ],
              ),
            ],
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
        //SizedBox(
         // width: 30.0,
        //),
        //SizedBox(
         // width: 30.0,
        //),
        //Expanded(
          //  child: SizedBox(
          //width: 5.0,
        //)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: FloatingActionButton(
                  heroTag: "btn1",
                  child: Text(
                    "Refresh",
                    style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _refresh),
            ),
            Spacer(),
            RaisedButton(
              child: Text("Ver Pdf"),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(PushPdfPage());
              },
              color: Colors.white,
              elevation: 5,

            ),
          ],
        ),
        //FloatingActionButton(
        //child: Text("Otra Pagina",style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),onPressed: _ir),
      /*  RaisedButton(
          child: Text("Cerrar Sesion"),
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(PushLoginPage());
          },
        ),
        RaisedButton(
          child: Text("Otra Pagina"),
          onPressed: () {
            tokensito();
          },
        ),*/
       /* RaisedButton(
          child: Text("Ver Pdf"),
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(PushPdfPage());
          },
        ),*/
        Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15),
          child: Text(
             '   Hola $username, Bienvenido a la aplicación                  ',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ),
        Text(
          msg,
          style: TextStyle(fontSize: 20.0, color: Colors.red),
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
}
