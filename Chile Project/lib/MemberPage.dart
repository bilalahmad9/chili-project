import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postapp/authentication/bloc/authentication_bloc.dart';
import 'package:postapp/util/menu.dart';

class MemberPage extends StatelessWidget {
  MemberPage({this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        title: Text("Admin - Pantalla 2"),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Hola $username ',
            style: TextStyle(fontSize: 20.0),
          ),
          RaisedButton(
            child: Text("Cerrar Sesion"),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(PushLoginPage());
            },
          ),
        ],
      ),
    );
  }
}
