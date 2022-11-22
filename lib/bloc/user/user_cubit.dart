import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/bloc/user/user_state.dart';

import '../../model/app_user.dart';
import '../../repository/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(super.initialState, this._userRepository);

  AppUser? _user;

  AppUser get appUser => _user!;

  fetchLoggedInUserData() async {
    try {
      emit(UserLoading());
      var userData = await _userRepository.fetchUserWithId(appUser.uId);
      emit(UserAuthenticated());
    } on FirebaseException catch (e) {
      emit(UserUnAuthenticated());
    }
  }

  logOut() async {
    emit(UserLoading());
    await FirebaseAuth.instance.signOut();
    emit(UserUnAuthenticated());
  }
}
