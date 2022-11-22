import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menexus/firebase_options.dart';
import 'package:menexus/repository/user_repository.dart';
import 'package:menexus/screens/home_screen.dart';
import 'package:menexus/screens/login_screen.dart';
import 'package:menexus/screens/profile_screen.dart';
import 'package:menexus/screens/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();
  runApp(MultiRepositoryProvider(providers: [
    RepositoryProvider<UserRepository>(
      create: (context) => UserRepository(),
    ),
  ],child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home_screen': (context) => const HomeScreen(),
        '/profile_screen': (context) => const ProfileScreen(),

      },
      title: 'Menexus',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),

    );
  }
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
