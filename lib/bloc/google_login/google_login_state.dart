
import 'package:meta/meta.dart';

import '../../model/app_user.dart';

@immutable
abstract class GoogleLoginState {}

class GoogleLoginInitial extends GoogleLoginState {}

class GoogleLoginInProgress extends GoogleLoginState {}

class GoogleLoginFailure extends GoogleLoginState {
  final String? error;

  GoogleLoginFailure(this.error);
}

class GoogleLoginSuccess extends GoogleLoginState {
  final String? message;
  final AppUser? appUser;

  GoogleLoginSuccess({this.message, this.appUser});
}
