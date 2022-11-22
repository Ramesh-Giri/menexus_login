import 'package:flutter/material.dart';

@immutable
abstract class UserState {}

class UserUnInitialized extends UserState {}

class UserAuthenticated extends UserState {}

class UserUnAuthenticated extends UserState {}

class UserLoading extends UserState {}
