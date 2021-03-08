import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postapp/authentication/bloc/authentication_bloc.dart';
import 'package:postapp/main.dart';
import 'package:postapp/util/token_check.dart';

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text("EJEMPLO MENU"),
            accountEmail: Text("info@newcapital.cl"),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUcZMeU0qVeUGBZEa__Q635wOgm9AG-NDfjg&usqp=CAU"),
                  fit: BoxFit.cover),
            ),
          ),
          Ink(
            color: Colors.yellow[600],
            child: new ListTile(
              title: Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                tokensito(token: token, context: context, home: true);
              },
            ),
          ),
          new ListTile(
            title: Text("Indicadores 2"),
            onTap: () {
              tokensito(token: token, context: context);
            },
          ),
          new ListTile(
            title: Text("Cerrar Sesion"),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(PushLoginPage());
            },
          ),
        ],
      ),
    );
  }
}
