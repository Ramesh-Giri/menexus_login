import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/bloc/auth/register/register_state.dart';

import '../../../repository/user_repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final UserRepository _userRepository;

  RegisterCubit(super.initialState, this._userRepository);

  void registerUserUsingEmailPassword(
      String name, String emailAddress, String password) async {
    emit(RegisterLoading());
    try {
      await _userRepository.registerUserUsingEmailPassword(
          name, emailAddress, password);
      emit(RegisterSuccess());
    } on FirebaseException catch (e) {
      emit(RegisterFailure(errorMessage: e.message.toString()));
      print('Reg Error ${e.toString()} ');
    }
  }
}
