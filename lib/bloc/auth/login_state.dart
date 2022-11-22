import 'package:flutter/widgets.dart';

@immutable
abstract class LoginState {}

class LoginInit extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure({required this.errorMessage});
}

class LoginSuccess extends LoginState {}
