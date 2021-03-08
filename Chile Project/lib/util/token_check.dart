import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postapp/authentication/bloc/authentication_bloc.dart';
import 'package:http/http.dart' as http;

Future<String> tokensito({token, context, bool home = false}) async {
  final response = await http.post("https://dany.pw/token.php", body: {
    "token": '$token',
  });

  var datauser = json.decode(response.body);

  if (datauser.length == 0) {
    return "Token no autorizado";
  } else {
    if (home) {
      BlocProvider.of<AuthenticationBloc>(context).add(PushAdminPage());
    } else {
      BlocProvider.of<AuthenticationBloc>(context).add(PushNewPAge());
    }

    return null;
  }
}
