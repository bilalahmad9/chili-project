import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:postapp/AdminPage.dart';
import 'package:postapp/NewPage.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is PushLoginPage) {
      yield ShowLoginPage();
    }
    if (event is PushAdminPage) {
      yield ShowAdminPage();
    }
    if (event is PushNewPAge) {
      yield ShowNewPage();
    }
    if (event is PushPdfPage) {
      yield ShowPdfPage();
    }
  }
}
