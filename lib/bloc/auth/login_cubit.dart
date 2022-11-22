import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/bloc/auth/login_state.dart';

import '../../repository/user_repository.dart';
import '../user/user_cubit.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepository;

  LoginCubit(super.initialState,
      {required this.userRepository});

  loginUserByEmailPassword(String emailAddress, String password) async {
    try {
      emit(LoginLoading());
      await userRepository.loginUserByEmailPassword(emailAddress, password);
      emit(LoginSuccess());
    } on FirebaseException catch (e) {
      emit(LoginFailure(errorMessage: e.message.toString()));
    }
  }

}
