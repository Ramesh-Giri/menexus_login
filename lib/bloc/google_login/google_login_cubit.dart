import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/user_repository.dart';
import 'google_login_state.dart';

class GoogleLoginCubit extends Cubit<GoogleLoginState> {
  UserRepository _userRepository;

  GoogleLoginCubit(this._userRepository) : super(GoogleLoginInitial());

  void signInWithGoogle() async {
    emit(GoogleLoginInProgress());
    try {
      var appUser;
      appUser = await _userRepository.signInWithGoogle();
      if (appUser == null) {
        emit(GoogleLoginFailure('Canceled!!'));
      } else {
        emit(GoogleLoginSuccess(appUser: appUser));
      }
    } catch (e, stackTrace) {
      print('Google fail error $e');
      print('Google fail stackTace $stackTrace');
      emit(GoogleLoginFailure(e.toString()));
    }
  }
}
