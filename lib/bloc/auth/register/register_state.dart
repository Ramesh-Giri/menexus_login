import 'package:flutter/material.dart';

@immutable
abstract class RegisterState {}

class RegisterInit extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  RegisterFailure({required this.errorMessage});
}

class RegisterSuccess extends RegisterState {}
