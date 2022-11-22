import 'package:meta/meta.dart';

import '../../model/app_user.dart';

@immutable
abstract class MembersState {}

class MembersInitial extends MembersState {}

class MembersLoading extends MembersState {}

class MembersFailure extends MembersState {
  final String error;
  final String stackTrace;

  MembersFailure({required this.error, required this.stackTrace});
}

class MembersSuccess extends MembersState {
  final List<AppUser> membersList;

  MembersSuccess({required this.membersList});
}