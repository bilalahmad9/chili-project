part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class PushAdminPage extends AuthenticationEvent {}

class PushLoginPage extends AuthenticationEvent {}

class PushPdfPage extends AuthenticationEvent {}

class PushNewPAge extends AuthenticationEvent {}

class PushMemberpage extends AuthenticationEvent {}
