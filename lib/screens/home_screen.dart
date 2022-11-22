import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/bloc/members/members_cubit.dart';
import 'package:menexus/bloc/members/members_state.dart';

import '../repository/user_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MembersCubit>(
          create: (_) =>
              MembersCubit(MembersInitial(), context.read<UserRepository>()),
        ),
      ],
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  late String appUserId;

  @override
  void initState() {
    super.initState();
    appUserId = FirebaseAuth.instance.currentUser!.uid;
    context.read<MembersCubit>().fetchMembersExcept(appUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: const Text(
            'Welcome',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile_screen');
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ))
          ],
        ),
        body: BlocBuilder<MembersCubit, MembersState>(
          builder: (BuildContext context, state) {
            if (state is MembersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MembersFailure) {
              return Center(
                child: Text(
                    'Members load error: ${state.error}, stackTrace ${state.stackTrace.toString()}'),
              );
            }
            if (state is MembersSuccess) {
              if (state.membersList.isEmpty) {
                return const Center(
                  child: Text('List Empty'),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => context
                        .read<MembersCubit>()
                        .fetchMembersExcept(appUserId),
                  ),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.membersList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          trailing: appUserId == state.membersList[index].uId
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                          leading: Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.yellow),
                            child: Center(
                              child: Text(
                                state.membersList[index].fullName[0].toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          title: Text(state.membersList[index].fullName),
                          subtitle: Text(state.membersList[index].emailAddress),
                        );
                      }),
                );
              }
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
