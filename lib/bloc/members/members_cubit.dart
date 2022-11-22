import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/repository/user_repository.dart';

import 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  final UserRepository _membersRepository;

  MembersCubit(super.initialState, this._membersRepository);

  fetchMembersExcept(String appUserId) async {
    emit(MembersLoading());
    try {
      var data = await _membersRepository.fetchMembersExcept(appUserId);

      emit(MembersSuccess(membersList: data));
    } catch (e, stackTrace) {
      emit(MembersFailure(
          error: e.toString(), stackTrace: stackTrace.toString()));
    }
  }

}
