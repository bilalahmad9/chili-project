part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class ShowLoginPage extends AuthenticationState {}

class ShowAdminPage extends AuthenticationState {}

class ShowNewPage extends AuthenticationState {}

class ShowMemberpage extends AuthenticationState {}

class ShowPdfPage extends AuthenticationState {}
