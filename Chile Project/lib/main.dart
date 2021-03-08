import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:postapp/AdminPage.dart';
import 'package:postapp/MemberPage.dart';
import 'package:postapp/NewPage.dart';
import 'package:postapp/PdfPage.dart';
import 'package:postapp/authentication/bloc/authentication_bloc.dart';

String token = '';
void main() => runApp(new MyApp());

String username = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthenticationBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login PHP My Admin',
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is ShowAdminPage) {
                return AdminPage(
                  token: token,
                  username: username,
                );
              }
              if (state is ShowNewPage) {
                return NewPage(
                  token: token,
                  username: username,
                );
              }
              if (state is ShowMemberpage) {
                return MemberPage(
                  username: username,
                );
              }
              if (state is ShowPdfPage) {
                return PdfPage(username: username, token: token);
              }
              if (state is ShowAdminPage) {
                return MyHomePage();
              }

              return MyHomePage();
            },
          ),
          routes: <String, WidgetBuilder>{
            '/AdminPage': (BuildContext context) =>
                AdminPage(username: username, token: token),
            '/MemberPage': (BuildContext context) => MemberPage(
                  username: username,
                ),
            '/MyHomePage': (BuildContext context) => MyHomePage(),
            '/NewPage': (BuildContext context) =>
                NewPage(username: username, token: token),
            '/PdfPage': (BuildContext context) =>
                PdfPage(username: username, token: token),
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  String msg = '';
  bool isLoding = false;
  Future<List> _login() async {
    setState(() {
      isLoding = true;
    });
    final response = await http.post("https://dany.pw/login.php", body: {
      "username": user.text,
      "password": pass.text,
    });

    var datauser = json.decode(response.body);

    if (datauser.length == 0) {
      setState(() {
        isLoding = false;
        msg = "Error de ingreso";
      });
    } else {
      setState(() {
        isLoding = false;
        username = datauser[0]['username'];
        token = datauser[0]['token'];
      });
      if (datauser[0]['level'] == 'admin') {
        BlocProvider.of<AuthenticationBloc>(context).add(PushAdminPage());
      } else if (datauser[0]['level'] == 'member') {
        BlocProvider.of<AuthenticationBloc>(context).add(PushMemberpage());
      }
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {

    const PrimaryColor = const Color(0xFFfccf03);

    return Scaffold(
      appBar: AppBar(
         backgroundColor: PrimaryColor,
        title: Text("App Indicadores Prueba" ,style: TextStyle(
    color: Colors.black
  )),
        elevation: 0,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
             
                Image.asset(
                "./assets/images/logo_login.png",
                height: 125.0,
                width: 125.0,
                ),

                TextField(
                  controller: user,
                  decoration: InputDecoration(labelText: 'Usuario'),
                ),
                TextField(
                  controller: pass,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Clave'),
                ),
                !isLoding
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Login"),
                          onPressed: () {
                            _login();
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(),
                      ),
                Text(
                  msg,
                  style: TextStyle(fontSize: 20.0, color: Colors.red),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
